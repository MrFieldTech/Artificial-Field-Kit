#!/usr/bin/env bash
# Not kit-owned, and never installed. Before 2.0.0 the kit was Claude-Kit
# and lived in .claude/kit/, and its update fetches the source and runs
# .claude/kit/kit.sh from it as the installer. This file is that installer
# for every release before 2.0.0: it hands the install to
# .claude/afk/afk.sh, which moves the repository to .claude/afk/, and it
# records the kit's new address in place of its old one.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source="${KIT_SOURCE:-}"
lower="$(printf '%s' "$source" | tr '[:upper:]' '[:lower:]')"
case "${lower%/}" in
  https://github.com/mrfieldtech/claude-kit | https://github.com/mrfieldtech/claude-kit.git | \
  git@github.com:mrfieldtech/claude-kit | git@github.com:mrfieldtech/claude-kit.git)
    source="https://github.com/MrFieldTech/Artificial-Field-Kit" ;;
esac
AFK_SOURCE="$source" exec bash "$here/.claude/afk/afk.sh" "$@"
