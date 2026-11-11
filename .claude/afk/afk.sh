#!/usr/bin/env bash
# Artificial Field Kit, AFK: install, update, and report the kit in a
# repository.
#
#   bash <kit checkout>/.claude/afk/afk.sh install <repository>
#       Copy the kit-owned files from a checkout of the kit into a repository
#       and write .claude/afk/MANIFEST. Commits nothing.
#   bash .claude/afk/afk.sh status
#       Print the one line session-open reports as Kit:. Changes nothing.
#   bash .claude/afk/afk.sh update
#       Fetch the kit from the source MANIFEST records and install it over the
#       copy here. Commits nothing.
#
# Kit-owned files are everything under .claude/afk/ and the two skill
# directories. An install replaces them whole and touches nothing else,
# except when it moves a repository from a release before 2.0.0, when the
# kit was Claude-Kit and lived in .claude/kit/: then it also removes
# .claude/kit/, points the CLAUDE.md import at .claude/afk/HOUSE.md, and
# lists every other file that still names the old paths.
# An install or update refuses to overwrite a kit-owned file edited in place
# unless given --discard-local-edits, because the edit may be the only copy
# of a fix that belongs in the kit.
#
# Needs bash, git, and sha256sum or shasum. Nothing else.

set -euo pipefail

AFK_DIRS=(".claude/afk" ".claude/skills/session-open" ".claude/skills/session-close")
MANIFEST=".claude/afk/MANIFEST"
# Where a release before 2.0.0 installed itself.
OLD_DIRS=(".claude/kit" ".claude/skills/session-open" ".claude/skills/session-close")
OLD_MANIFEST=".claude/kit/MANIFEST"
TMP_DIR=""
trap '[ -z "$TMP_DIR" ] || rm -rf "$TMP_DIR"' EXIT

die() {
  printf 'afk.sh: %s\n' "$*" >&2
  exit 1
}

usage() {
  sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

sha() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

# Every kit-owned file under a root, as paths relative to it, sorted, without
# the manifest and without anything Python caches. Given "old", the files of
# a release before 2.0.0.
kit_files() {
  local root="$1" dir dirs=("${AFK_DIRS[@]}") manifest="$MANIFEST"
  if [ "${2:-}" = old ]; then
    dirs=("${OLD_DIRS[@]}")
    manifest="$OLD_MANIFEST"
  fi
  for dir in "${dirs[@]}"; do
    [ -d "$root/$dir" ] || continue
    (cd "$root" && find "$dir" -type f \
      ! -path "$manifest" ! -name '*.pyc' ! -path '*/__pycache__/*')
  done | LC_ALL=C sort
}

# "<sha256>  <path>" for every kit-owned file under a root.
kit_sums() {
  local root="$1" file
  kit_files "$root" | while IFS= read -r file; do
    printf '%s  %s\n' "$(sha "$root/$file")" "$file"
  done
}

manifest_field() {
  sed -n "s/^$1: //p" "$2" | head -n 1
}

# "<sha256>  <path>" for every file the manifest lists.
manifest_sums() {
  sed -n 's/^  \([0-9a-f]\{64\}  .*\)$/\1/p' "$1"
}

# Kit-owned files whose content no longer matches the manifest, one per line,
# including files the manifest lists that are gone and files it does not list.
# Given "old", against the manifest of a release before 2.0.0.
local_edits() {
  local root="$1" which="${2:-}" manifest="$MANIFEST" want path
  [ "$which" = old ] && manifest="$OLD_MANIFEST"
  manifest_sums "$root/$manifest" | while read -r want path; do
    if [ ! -f "$root/$path" ]; then
      printf '%s (deleted)\n' "$path"
    elif [ "$(sha "$root/$path")" != "$want" ]; then
      printf '%s\n' "$path"
    fi
  done
  kit_files "$root" "$which" | while IFS= read -r path; do
    manifest_sums "$root/$manifest" | cut -c67- | grep -qxF "$path" \
      || printf '%s (added)\n' "$path"
  done
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || die "not inside a git repository"
}

# Clone the source into a directory, quietly and without prompting. The "--"
# keeps a source that begins with a dash from being read as an option.
fetch_source() {
  local source="$1" into="$2"
  case "$source" in
    /*) source="file://$source" ;;
  esac
  GIT_TERMINAL_PROMPT=0 git clone --quiet --depth 1 -- "$source" "$into" >/dev/null 2>&1
}

cmd_install() {
  local target="" discard=0 arg
  for arg in "$@"; do
    case "$arg" in
      --discard-local-edits) discard=1 ;;
      -*) die "unknown option: $arg" ;;
      *) [ -z "$target" ] || die "one repository at a time"; target="$arg" ;;
    esac
  done
  [ -n "$target" ] || die "usage: afk.sh install <repository>"

  local src
  src="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  [ -f "$src/VERSION" ] || die "$src is not a checkout of the kit: it has no VERSION file"
  [ -d "$target" ] || die "no such directory: $target"
  target="$(cd "$target" && pwd)"
  git -C "$target" rev-parse --git-dir >/dev/null 2>&1 || die "$target is not a git repository"
  [ "$src" != "$target" ] || die "this is the kit's own repository, which runs on its source files"

  # A release before 2.0.0 is moved when the target has its manifest and
  # none of its own.
  local old=""
  if [ ! -f "$target/$MANIFEST" ] && [ -f "$target/$OLD_MANIFEST" ]; then
    old=old
  fi

  if { [ -f "$target/$MANIFEST" ] || [ -n "$old" ]; } && [ "$discard" -eq 0 ]; then
    local edits
    edits="$(local_edits "$target" "$old")"
    if [ -n "$edits" ]; then
      printf 'afk.sh: these kit-owned files were edited in place:\n%s\n' "$edits" >&2
      die "move the change into the kit first, or run again with --discard-local-edits"
    fi
  fi

  local version commit source
  version="$(tr -d '[:space:]' < "$src/VERSION")"
  commit="$(git -C "$src" rev-parse HEAD 2>/dev/null || echo unknown)"
  source="${AFK_SOURCE:-$(git -C "$src" config --get remote.origin.url 2>/dev/null || echo unknown)}"

  local path
  if [ ! -f "$target/$MANIFEST" ] && [ -z "$old" ]; then
    kit_files "$target" | while IFS= read -r path; do
      printf 'afk.sh: replacing %s, which no kit install wrote\n' "$path" >&2
    done
  fi

  local dir
  for dir in "${AFK_DIRS[@]}"; do
    rm -rf "${target:?}/$dir"
  done
  [ -z "$old" ] || rm -rf "${target:?}/.claude/kit"
  kit_files "$src" | while IFS= read -r path; do
    mkdir -p "$target/$(dirname "$path")"
    cp "$src/$path" "$target/$path"
  done
  chmod +x "$target/.claude/afk/afk.sh"

  {
    printf '# Written by afk.sh install. Never edit by hand.\n'
    printf 'version: %s\n' "$version"
    printf 'source: %s\n' "$source"
    printf 'commit: %s\n' "$commit"
    printf 'files:\n'
    kit_sums "$target" | sed 's/^/  /'
  } > "$target/$MANIFEST"

  printf 'Installed Artificial Field Kit %s, commit %s, into %s\n' "$version" "${commit:0:7}" "$target"
  [ -z "$old" ] || move_old "$target"
}

# The rest of the move from a release before 2.0.0. The import in CLAUDE.md
# is rewritten here, because without it the house rules stop loading. Every
# other mention of the old paths is listed for the session to change, by the
# 2.0.0 entry in the kit's CHANGELOG.md, because only it can tell a live
# instruction from a record of what happened.
move_old() {
  local target="$1" files
  printf 'Moved the kit from .claude/kit/ to .claude/afk/\n'
  if [ -f "$target/CLAUDE.md" ] && grep -qx '@\.claude/kit/HOUSE\.md' "$target/CLAUDE.md"; then
    sed 's#^@\.claude/kit/HOUSE\.md$#@.claude/afk/HOUSE.md#' "$target/CLAUDE.md" > "$target/CLAUDE.md.afk"
    mv "$target/CLAUDE.md.afk" "$target/CLAUDE.md"
    printf 'Pointed the import in CLAUDE.md at .claude/afk/HOUSE.md\n'
  else
    printf 'CLAUDE.md has no line @.claude/kit/HOUSE.md to point at .claude/afk/HOUSE.md\n'
  fi
  files="$(git -C "$target" grep --untracked -lI -e '\.claude/kit' -e 'kit\.sh' -e 'KIT_SOURCE' -e 'KIT_PRIVATE_TERMS' -e 'Claude-Kit' \
    -- . ':!.claude/references' ':!.claude/imported' ':!.claude/afk' ':!.claude/skills/session-open' ':!.claude/skills/session-close' 2>/dev/null || true)"
  if [ -n "$files" ]; then
    printf 'These files still name the kit as it was before 2.0.0:\n'
    printf '%s\n' "$files" | sed 's/^/  /'
  fi
}

cmd_status() {
  local root
  root="$(repo_root)"

  if [ ! -f "$root/$MANIFEST" ]; then
    if [ -f "$root/VERSION" ] && [ -f "$root/.claude/afk/afk.sh" ] && [ -f "$root/.claude/afk/HOUSE.md" ]; then
      printf '%s, the kit source itself\n' "$(tr -d '[:space:]' < "$root/VERSION")"
    else
      printf 'not installed\n'
    fi
    return 0
  fi

  local version source edits state
  version="$(manifest_field version "$root/$MANIFEST")"
  source="$(manifest_field source "$root/$MANIFEST")"
  edits="$(local_edits "$root" | paste -sd ',' - | sed 's/,/, /g')"

  TMP_DIR="$(mktemp -d)"
  if ! fetch_source "$source" "$TMP_DIR/kit"; then
    state="source unreachable"
  elif [ ! -f "$TMP_DIR/kit/VERSION" ]; then
    state="the source has no release on its default branch"
  else
    local latest
    latest="$(tr -d '[:space:]' < "$TMP_DIR/kit/VERSION")"
    if [ "$(kit_sums "$TMP_DIR/kit")" = "$(manifest_sums "$root/$MANIFEST")" ]; then
      state="current"
    elif [ "$latest" = "$version" ]; then
      state="differs from the source at the same version"
    elif [ "$(printf '%s\n%s\n' "$version" "$latest" | sort -V | tail -n 1)" = "$latest" ]; then
      state="$latest available"
    else
      state="ahead of the source, which is at $latest"
    fi
  fi

  if [ -n "$edits" ]; then
    printf '%s, %s, edited locally: %s\n' "$version" "$state" "$edits"
  else
    printf '%s, %s\n' "$version" "$state"
  fi
}

cmd_update() {
  local root discard=""
  root="$(repo_root)"
  case "${1:-}" in
    "") ;;
    --discard-local-edits) discard="$1" ;;
    *) die "unknown option: $1" ;;
  esac
  [ -f "$root/$MANIFEST" ] || die "no $MANIFEST here: install the kit first"

  # The update runs the installer it fetches, so it names where that comes
  # from before fetching it, for whoever reads the output to confirm.
  local source
  source="$(manifest_field source "$root/$MANIFEST")"
  printf 'afk.sh: updating from %s, the source .claude/afk/MANIFEST names\n' "$source"
  TMP_DIR="$(mktemp -d)"
  fetch_source "$source" "$TMP_DIR/kit" || die "cannot fetch the kit from $source"
  [ -f "$TMP_DIR/kit/.claude/afk/afk.sh" ] || die "$source holds no kit"
  AFK_SOURCE="$source" bash "$TMP_DIR/kit/.claude/afk/afk.sh" install "$root" $discard
}

case "${1:-}" in
  install) shift; cmd_install "$@" ;;
  status) shift; cmd_status "$@" ;;
  update) shift; cmd_update "$@" ;;
  -h|--help|help) usage 0 ;;
  *) usage 1 ;;
esac
