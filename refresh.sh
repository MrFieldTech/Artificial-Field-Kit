#!/usr/bin/env bash
# Refresh the kit's mirrors of outside skills and agents from upstream.
# Kept in the kit's own repository and never installed.
#
#   bash refresh.sh <name>      refresh one source vendor/SOURCES names
#   bash refresh.sh --all       refresh every source
#
# Each source is copied bit for bit from its upstream's default branch into
# vendor/<name>/, replacing what was there, and vendor/<name>.upstream records
# where it came from: the repository, the commit, the path within it, the
# license file and the date. Commits nothing: a refresh is a release, by the
# rules in CLAUDE.md.
#
# AFK_VENDOR_BASE replaces https://github.com as the place sources are
# cloned from, for check.sh.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

BASE="${AFK_VENDOR_BASE:-https://github.com}"
TMP_DIR=""
trap '[ -z "$TMP_DIR" ] || rm -rf "$TMP_DIR"' EXIT

die() {
  printf 'refresh: %s\n' "$*" >&2
  exit 1
}

[ -f vendor/SOURCES ] || die "no vendor/SOURCES here"

sources() {
  grep -vE '^[[:space:]]*(#|$)' vendor/SOURCES
}

refresh_one() {
  local name="$1" line repo path license
  line="$(sources | awk -v n="$name" '$1 == n')"
  [ -n "$line" ] || die "vendor/SOURCES names no source $name"
  read -r _ repo path _ <<< "$line"

  TMP_DIR="$(mktemp -d)"
  GIT_TERMINAL_PROMPT=0 git clone --quiet --depth 1 -- "$BASE/$repo" "$TMP_DIR/up" \
    || die "could not clone $BASE/$repo"
  local commit from
  commit="$(git -C "$TMP_DIR/up" rev-parse HEAD)"
  from="$TMP_DIR/up"
  [ "$path" = "." ] || from="$TMP_DIR/up/$path"
  [ -d "$from" ] || die "$repo has no $path at $commit"
  rm -rf "$from/.git"

  license=""
  for candidate in LICENSE LICENSE.md LICENSE.txt COPYING; do
    if [ -f "$from/$candidate" ]; then license="$candidate"; break; fi
  done
  [ -n "$license" ] || die "$repo has no license file in $path, so it cannot be mirrored"

  rm -rf "vendor/$name"
  mkdir -p "vendor/$name"
  cp -a "$from/." "vendor/$name/"
  {
    printf '# Written by refresh.sh. Never edit by hand.\n'
    printf 'repository: %s\n' "$repo"
    printf 'path: %s\n' "$path"
    printf 'commit: %s\n' "$commit"
    printf 'license: %s\n' "$license"
    printf 'refreshed: %s\n' "$(date -u +%Y-%m-%d)"
  } > "vendor/$name.upstream"
  rm -rf "$TMP_DIR"
  TMP_DIR=""
  printf 'refresh: vendor/%s at %s\n' "$name" "${commit:0:7}"
}

case "${1:-}" in
  "") sed -n '2,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 1 ;;
  --all) for name in $(sources | awk '{print $1}'); do refresh_one "$name"; done ;;
  *) refresh_one "$1" ;;
esac
