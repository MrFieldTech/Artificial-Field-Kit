#!/usr/bin/env bash
# Refresh the kit's mirrors of outside skills and agents from upstream.
# Kept in the kit's own repository and never installed.
#
#   bash refresh.sh --check            list each source with an update
#   bash refresh.sh --changes <name>   the commits and files an update brings
#   bash refresh.sh --diff <name> [<file>]
#                                      the update's changes in full, or one
#                                      file's, as a patch
#   bash refresh.sh --skip <name>      skip upstream's current version
#   bash refresh.sh <name>             refresh one source vendor/SOURCES names
#   bash refresh.sh --all              refresh every source
#
# A refresh copies a source bit for bit from its upstream's default branch
# into vendor/<name>/, replacing what was there, and vendor/<name>.upstream
# records where it came from: the repository, the commit, the path within
# it, the license file and the date. The license is also copied to
# .claude/afk/licenses/<name>.txt, which every install carries, so each
# repository that installs a mirrored skill holds its license. Commits
# nothing: a refresh is a release, by the rules in CLAUDE.md.
#
# --check compares upstream's current content with the mirror as committed,
# so a commit upstream that leaves the mirrored path alone is no update. It
# prints one line per source: "current", "<old>..<new> available", or
# "<new> skipped" when --skip recorded that version. --skip writes the
# version into vendor/<name>.upstream, and the next version upstream is
# offered again.
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

# Sets repo and path for a source vendor/SOURCES names.
source_of() {
  local line
  line="$(sources | awk -v n="$1" '$1 == n')"
  [ -n "$line" ] || die "vendor/SOURCES names no source $1"
  read -r _ repo path _ <<< "$line"
}

upstream_field() {
  [ -f "vendor/$1.upstream" ] || die "vendor/$1 has never been refreshed"
  sed -n "s/^$2: //p" "vendor/$1.upstream" | head -n 1
}

# The tree of a path at a commit in a clone, "." meaning the whole tree.
tree_at() {
  if [ "$3" = "." ]; then
    git -C "$1" rev-parse "$2^{tree}"
  else
    git -C "$1" rev-parse "$2:$3"
  fi
}

# Clone upstream into $TMP_DIR/up without file contents, which git fetches
# only when a command needs them. With "shallow", only the newest commit.
clone_upstream() {
  local depth=()
  [ "${2:-}" = shallow ] && depth=(--depth 1)
  TMP_DIR="$(mktemp -d)"
  GIT_TERMINAL_PROMPT=0 git clone --quiet "${depth[@]}" --filter=blob:none --no-checkout \
    -- "$BASE/$1" "$TMP_DIR/up" >/dev/null 2>&1 || die "could not clone $BASE/$1"
}

done_with_clone() {
  rm -rf "$TMP_DIR"
  TMP_DIR=""
}

write_upstream() {
  local name="$1" commit="$2" license="$3" skipped="${4:-}"
  {
    printf '# Written by refresh.sh. Never edit by hand.\n'
    printf 'repository: %s\n' "$repo"
    printf 'path: %s\n' "$path"
    printf 'commit: %s\n' "$commit"
    printf 'license: %s\n' "$license"
    printf 'refreshed: %s\n' "$(upstream_field_or_today "$name")"
    [ -z "$skipped" ] || printf 'skipped: %s\n' "$skipped"
  } > "vendor/$name.upstream.new"
  mv "vendor/$name.upstream.new" "vendor/$name.upstream"
}

upstream_field_or_today() {
  if [ -n "${KEEP_DATE:-}" ] && [ -f "vendor/$1.upstream" ]; then
    sed -n 's/^refreshed: //p' "vendor/$1.upstream" | head -n 1
  else
    date -u +%Y-%m-%d
  fi
}

refresh_one() {
  local name="$1" repo path license
  source_of "$name"

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
  mkdir -p "vendor/$name" .claude/afk/licenses
  cp -a "$from/." "vendor/$name/"
  cp "vendor/$name/$license" ".claude/afk/licenses/$name.txt"
  write_upstream "$name" "$commit" "$license"
  done_with_clone
  printf 'refresh: vendor/%s at %s\n' "$name" "${commit:0:7}"
}

# One line for a source: current, available or skipped.
check_one() {
  local name="$1" repo path mirrored head local_tree up_tree skipped
  source_of "$name"
  mirrored="$(upstream_field "$name" commit)"
  skipped="$(upstream_field "$name" skipped)"
  head="$(GIT_TERMINAL_PROMPT=0 git ls-remote -- "$BASE/$repo" HEAD 2>/dev/null | cut -f1)"
  [ -n "$head" ] || { printf '%s unreachable\n' "$name"; return 0; }
  if [ "$head" = "$mirrored" ]; then
    printf '%s current\n' "$name"
    return 0
  fi
  local_tree="$(git rev-parse "HEAD:vendor/$name" 2>/dev/null)" \
    || die "vendor/$name is not committed, so it cannot be compared"
  clone_upstream "$repo" shallow
  up_tree="$(tree_at "$TMP_DIR/up" HEAD "$path")"
  done_with_clone
  if [ "$up_tree" = "$local_tree" ]; then
    printf '%s current\n' "$name"
  elif [ "$up_tree" = "$skipped" ]; then
    printf '%s %s skipped\n' "$name" "${head:0:7}"
  else
    printf '%s %s..%s available\n' "$name" "${mirrored:0:7}" "${head:0:7}"
  fi
}

changes_one() {
  local name="$1" repo path mirrored
  source_of "$name"
  mirrored="$(upstream_field "$name" commit)"
  clone_upstream "$repo"
  printf 'Commits upstream since %s that touch %s:\n' "${mirrored:0:7}" "$path"
  git -C "$TMP_DIR/up" log --format='  %h %as %s' "$mirrored..HEAD" -- "$path"
  printf '\nFiles changed:\n'
  git -C "$TMP_DIR/up" diff --stat=100 "$mirrored" HEAD -- "$path" | sed 's/^/  /'
  done_with_clone
}

diff_one() {
  local name="$1" file="${2:-}" repo path mirrored where
  source_of "$name"
  mirrored="$(upstream_field "$name" commit)"
  where="$path"
  [ -z "$file" ] || where="$path/$file"
  [ "$where" != "./$file" ] || where="$file"
  clone_upstream "$repo"
  git -C "$TMP_DIR/up" diff "$mirrored" HEAD -- "$where"
  done_with_clone
}

skip_one() {
  local name="$1" repo path head tree
  source_of "$name"
  clone_upstream "$repo" shallow
  head="$(git -C "$TMP_DIR/up" rev-parse HEAD)"
  tree="$(tree_at "$TMP_DIR/up" HEAD "$path")"
  done_with_clone
  KEEP_DATE=1 write_upstream "$name" "$(upstream_field "$name" commit)" \
    "$(upstream_field "$name" license)" "$tree"
  printf 'refresh: vendor/%s skips upstream at %s until a newer version\n' "$name" "${head:0:7}"
}

case "${1:-}" in
  "") sed -n '2,30p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 1 ;;
  --all) for name in $(sources | awk '{print $1}'); do refresh_one "$name"; done ;;
  --check) for name in $(sources | awk '{print $1}'); do check_one "$name"; done ;;
  --changes) [ -n "${2:-}" ] || die "--changes needs a source"; changes_one "$2" ;;
  --diff) [ -n "${2:-}" ] || die "--diff needs a source"; diff_one "$2" "${3:-}" ;;
  --skip) [ -n "${2:-}" ] || die "--skip needs a source"; skip_one "$2" ;;
  -*) die "unknown option: $1" ;;
  *) refresh_one "$1" ;;
esac
