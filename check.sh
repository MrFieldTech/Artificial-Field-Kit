#!/usr/bin/env bash
# Checks the kit before it merges. Run from anywhere: bash check.sh
#
# 1. No kit-owned file holds an address, and neither one nor a session
#    reference holds a name on the private list of project terms when one is
#    given.
# 2. No file in the repository holds an em dash or an en dash, outside the
#    mirrors under vendor/.
# 3. The scripts parse, each skill's frontmatter is whole, every practice
#    is pointed at and every pointer names a practice that exists, the
#    AGENTS.md pointer names files that exist and opens this repository's
#    AGENTS.md, and every kit-owned directory keeps LF line endings.
# 4. A task block's field lines and holder lines read the same wherever a
#    kit-owned file or this repository's TASKS.md writes them out.
# 5. VERSION is a version number, CHANGELOG.md has an entry for it, and the
#    README's update block names it.
# 6. An install into a scratch repository works end to end: the manifest,
#    the status line, the guard against overwriting local edits, the
#    pointer in AGENTS.md, the mirrored skills and agents, and the TODO
#    sweep.
# 7. The secrets tool stores, places, locks, checks, shows, rekeys and
#    decrypts values with age, and prints the steps for keys. Skipped when
#    age is not installed, except in CI. The Node decrypter is tested when
#    node is installed, fully when CHECK_NODE_MODULES names a node_modules
#    directory holding the age-encryption package.
# 8. This repository's own TODO.md is current.
#
# Exits non-zero on the first section that fails, after printing why.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
AFK_ROOT="$(pwd)"

AFK_OWNED=(.claude/afk .claude/skills/session-open .claude/skills/session-close)

fail() {
  printf 'check: %s\n' "$*" >&2
  exit 1
}

# 1. A kit-owned file is installed into every repository, public or private,
# so it may name no project, person, account, host or address.
#
# Addresses are caught by pattern: a web address, an email address, or a
# host name under a common top-level domain.
ADDRESS='https?://|[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}|\b[A-Za-z0-9-]+\.(com|net|org|io|dev|app|gg|co|us|me|ai)\b'
# grep exits 1 when nothing matches and 2 when it cannot search, which must
# fail the check rather than pass it.
#
# A standard writes addresses with a placeholder for the host, such as
# https://www.<domain>/, which name no project. A whole address is allowed
# when its host is a <placeholder> or localhost, or when it is the sitemap
# protocol's XML namespace or the escaped prefix a check command greps for.
ALLOWED='^((https?://)?(www\.)?<[a-z-]+>|https?://localhost[:/]|http://www\.sitemaps\.org/schemas/sitemap/0\.9$|https://www\\\.$)'
status=0
# The licenses of the mirrors under .claude/afk/licenses/ are upstream's text,
# kept whole, and name only their own license's address.
hits="$(grep -rnIE --exclude-dir=licenses "$ADDRESS" "${AFK_OWNED[@]}")" || status=$?
[ "$status" -ne 0 ] && [ "$status" -ne 1 ] && fail "the address pattern could not be searched"
bad=""
while IFS= read -r line; do
  [ -n "$line" ] || continue
  text="${line#*:*:}"
  tokens="$(grep -oE "[^[:space:]\`\"'(]*(${ADDRESS})[^[:space:]\`\"')]*" <<< "$text" || true)"
  if grep -vqE "$ALLOWED" <<< "$tokens"; then bad+="$line"$'\n'; fi
done <<< "$hits"
if [ -n "$bad" ]; then
  printf '%s' "$bad"
  fail "the lines above hold an address, which belongs to one project"
fi
# Names cannot be caught by pattern, so they come from a list kept out of
# this public repository: the AFK_PRIVATE_TERMS repository secret in CI, or an
# untracked .private-terms file locally, holding one extended regular
# expression. Add a term there whenever a project's detail leaks in. Without
# either, this part is skipped, and CI still runs it on every pull request.
terms="${AFK_PRIVATE_TERMS:-}"
if [ -z "$terms" ] && [ -f .private-terms ]; then
  terms="$(tr -d '\n' < .private-terms)"
fi
# This repository's own session references and copies are public too, so
# they are held to the same list. CLAUDE.md has the close redact a match
# before a reference is committed, and a copy holding one is not made.
TERMS_SCANNED=("${AFK_OWNED[@]}")
[ -d .claude/references ] && TERMS_SCANNED+=(.claude/references)
[ -d .claude/imported ] && TERMS_SCANNED+=(.claude/imported)
if [ -n "$terms" ]; then
  status=0
  grep -rnIE "$terms" "${TERMS_SCANNED[@]}" || status=$?
  [ "$status" -ne 0 ] && [ "$status" -ne 1 ] && fail "the private terms are not a valid pattern"
  [ "$status" -eq 0 ] && fail "the lines above name something that belongs to one project"
  echo "check: kit-owned files hold no address, and they, the references and the copies name no project"
else
  echo "check: kit-owned files hold no address (no private terms given, so names were not checked)"
fi

# 2. The house rules forbid the em dash and the en dash, in the kit as
#    everywhere else. The mirrors under vendor/ are kept bit for bit as
#    upstream wrote them, and are not the kit's writing.
if git ls-files -z -- . ':!vendor' | xargs -0 grep -nI -e $'\xe2\x80\x94' -e $'\xe2\x80\x93' --; then
  fail "the lines above hold an em dash or an en dash"
fi
echo "check: no em dash or en dash"

# 3. Syntax, skill frontmatter, and line endings. A checkout on Windows
# turns LF into CRLF unless .gitattributes says otherwise, and bash cannot
# run afk.sh with CRLF endings.
bash -n .claude/afk/afk.sh
for script in todo_sweep.py secrets.py; do
  python3 -c 'import ast, sys; ast.parse(open(sys.argv[1]).read())' ".claude/afk/$script"
done
if command -v node >/dev/null 2>&1; then
  node --check .claude/afk/secrets-decrypt.mjs
fi
for skill in session-open session-close; do
  file=".claude/skills/$skill/SKILL.md"
  [ "$(sed -n 1p "$file")" = "---" ] || fail "$file does not open with frontmatter"
  grep -qx "name: $skill" "$file" || fail "$file does not name itself $skill"
  grep -qx "disable-model-invocation: true" "$file" || fail "$file can be invoked by the model"
  grep -q '^description: ' "$file" || fail "$file has no description"
done
# A practice is read only when a pointer names it, so a practice no pointer
# names is never read, and a pointer to a missing file sends a session
# nowhere. HOUSE.md's Practices section is where every practice is named.
practices_section="$(sed -n '/^## Practices$/,/^## /p' .claude/afk/HOUSE.md)"
[ -n "$practices_section" ] || fail "HOUSE.md has no Practices section"
for file in .claude/afk/practices/*.md; do
  grep -qF "\`$(basename "$file")\`" <<< "$practices_section" \
    || fail "HOUSE.md's Practices section does not name $file"
done
for name in $(grep -oE '`[a-z-]+\.md`' <<< "$practices_section" | tr -d '`' | sort -u); do
  [ -f ".claude/afk/practices/$name" ] || fail "HOUSE.md names the practice $name, which does not exist"
done
standards_section="$(sed -n '/^## Standards$/,/^## /p' .claude/afk/HOUSE.md)"
[ -n "$standards_section" ] || fail "HOUSE.md has no Standards section"
for file in .claude/afk/standards/*.md; do
  grep -qF "\`$(basename "$file")\`" <<< "$standards_section" \
    || fail "HOUSE.md's Standards section does not name $file"
done
for name in $(grep -oE '`[a-z-]+\.md`' <<< "$standards_section" | tr -d '`' | sort -u); do
  [ -f ".claude/afk/standards/$name" ] || fail "HOUSE.md names the standard $name, which does not exist"
done
for path in $(grep -rhoE '\.claude/afk/standards/[a-z-]+\.md' "${AFK_OWNED[@]}" | sort -u); do
  [ -f "$path" ] || fail "a kit-owned file points at $path, which does not exist"
done
for path in $(grep -rhoE '\.claude/afk/practices/[a-z-]+\.md' "${AFK_OWNED[@]}" | sort -u); do
  [ -f "$path" ] || fail "a kit-owned file points at $path, which does not exist"
done
for dir in "${AFK_OWNED[@]}"; do
  grep -qx '\* text eol=lf' "$dir/.gitattributes" 2>/dev/null \
    || fail "$dir has no .gitattributes keeping LF line endings"
done
if grep -rlI $'\r' "${AFK_OWNED[@]}"; then
  fail "the files above hold a carriage return"
fi
echo "check: scripts parse, skills are whole, practices and standards are pointed at, and line endings stay LF"

# The pointer for other tools names the files a session reads first, and
# this repository's own AGENTS.md carries the current pointer.
for path in CLAUDE.md .claude/afk/HOUSE.md .claude/skills/session-open/SKILL.md \
  .claude/skills/session-close/SKILL.md; do
  grep -qF "\`$path\`" .claude/afk/templates/AGENTS.md \
    || fail "the AGENTS.md template does not name $path"
  [ -f "$path" ] || fail "the AGENTS.md template names $path, which does not exist"
done
pointer_lines="$(wc -l < .claude/afk/templates/AGENTS.md)"
[ "$(head -n "$pointer_lines" AGENTS.md)" = "$(cat .claude/afk/templates/AGENTS.md)" ] \
  || fail "AGENTS.md does not open with the current .claude/afk/templates/AGENTS.md"

# 4. A task block's format is written out in more than one file, and a
# field or holder line added to one copy and missed in another is caught
# nowhere else. .claude/afk/templates/TASKS.md is the source. Every fenced
# example of the format in a kit-owned file, and in this repository's
# TASKS.md, must read exactly as the template's: the whole field block, and
# a holder line as one of the template's two lines or both in its order.
# Only text above a TASKS.md file's Open Tasks heading is read, so a task's
# own lines are never compared.
python3 - "${AFK_OWNED[@]}" TASKS.md <<'EOF' || fail "a task block's format differs from .claude/afk/templates/TASKS.md, as printed above"
import pathlib, re, sys

def examples(path):
    text = pathlib.Path(path).read_text(encoding="utf-8")
    if pathlib.Path(path).name == "TASKS.md":
        text = text.split("\n## Open Tasks", 1)[0]
    blocks, block = [], None
    for line in text.splitlines():
        if line.startswith("```"):
            if block is not None:
                blocks.append(block)
            block = None if block is not None else []
        elif block is not None:
            block.append(line)
    return blocks

# The holder words before 1.10.0 are matched too, so a copy left on them fails.
holder = re.compile(r"(HOLDING|DROPPED|(IN)?ACTIVE) \| ")
template = ".claude/afk/templates/TASKS.md"
blocks = examples(template)
holders = [b for b in ([l for l in b if holder.match(l)] for b in blocks) if b]
labels = re.compile(r"\*\*[A-Z][a-z]+:\*\* ")
fields = [b for b in ([l for l in b if labels.match(l)] for b in blocks) if b]
if len(holders) != 1 or len(fields) != 1:
    sys.exit(f"check: {template} must hold one fenced holder example and one fenced field block")
holders, fields = holders[0], fields[0]
field = re.compile("|".join(re.escape(l.split(" ", 1)[0] + " ") for l in fields))

files = []
for arg in sys.argv[1:]:
    p = pathlib.Path(arg)
    files += sorted(p.rglob("*.md")) if p.is_dir() else [p]
bad = False
for path in files:
    for block in examples(path):
        found = [l for l in block if holder.match(l)]
        if found and found != holders and not (len(found) == 1 and found[0] in holders):
            print(f"{path}: holder lines\n  " + "\n  ".join(found), file=sys.stderr)
            bad = True
        found = [l for l in block if field.match(l)]
        if found and found != fields:
            print(f"{path}: field lines\n  " + "\n  ".join(found), file=sys.stderr)
            bad = True
sys.exit(1 if bad else 0)
EOF
echo "check: task block formats match the template"

# 5. Every release is numbered and recorded.
version="$(tr -d '[:space:]' < VERSION)"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "VERSION holds '$version', not a version number"
grep -q "^## $version\b" CHANGELOG.md || fail "CHANGELOG.md has no '## $version' entry"
grep -qx "/session-open afk-update-${version//./-}" README.md \
  || fail "README.md's update block does not open with /session-open afk-update-${version//./-}"
echo "check: version $version is recorded"

# 6. End to end, in a scratch repository with nothing of its own.
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
repo="$scratch/repo"
git init --quiet "$repo"
git -C "$repo" -c user.name=check -c user.email=check@example.invalid \
  commit --quiet --allow-empty -m "empty"

# Install from a clean clone of this checkout's HEAD, so uncommitted edits do
# not make the status line disagree with itself.
git clone --quiet "file://$AFK_ROOT" "$scratch/kit"
AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" >/dev/null

for file in $(cd "$scratch/kit" && find "${AFK_OWNED[@]}" -type f | sort); do
  [ -f "$repo/$file" ] || fail "install left out $file"
  grep -q "  $file\$" "$repo/.claude/afk/MANIFEST" || fail "MANIFEST does not list $file"
done
[ -x "$repo/.claude/afk/afk.sh" ] || fail "install left afk.sh without its execute bit"

status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
[ "$status" = "$version, current" ] || fail "status after install reads '$status', not '$version, current'"

printf '\nA local edit.\n' >> "$repo/.claude/afk/HOUSE.md"
status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
case "$status" in
  *"edited locally: .claude/afk/HOUSE.md"*) ;;
  *) fail "status did not report a local edit: '$status'" ;;
esac
if AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" >/dev/null 2>&1; then
  fail "install overwrote a kit-owned file edited in place"
fi
AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" --discard-local-edits >/dev/null
status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
[ "$status" = "$version, current" ] || fail "status after reinstall reads '$status'"

(cd "$repo" && bash .claude/afk/afk.sh update >/dev/null)
status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
[ "$status" = "$version, current" ] || fail "status after update reads '$status'"
echo "check: install, status, and update work"

# The kit's pointer at the top of AGENTS.md, for tools other than Claude
# Code: written when missing, added above a repository's own text, rewritten
# in place when stale, and never written through a link.
pointer="$scratch/kit/.claude/afk/templates/AGENTS.md"
cmp -s "$repo/AGENTS.md" "$pointer" || fail "install did not write AGENTS.md from its template"
own="$scratch/own"
git init --quiet "$own"
printf '# Our rules\n\nthe repository'"'"'s own\n' > "$own/AGENTS.md"
AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$own" >/dev/null
[ "$(head -n "$(wc -l < "$pointer")" "$own/AGENTS.md")" = "$(cat "$pointer")" ] \
  || fail "install did not put the kit's pointer at the top of an AGENTS.md that had none"
grep -qx "the repository's own" "$own/AGENTS.md" || fail "install lost the text of an AGENTS.md that was there"
sed 's/^# Instructions For Any AI Coding Tool$/# A stale pointer/' "$own/AGENTS.md" > "$own/AGENTS.md.old"
mv "$own/AGENTS.md.old" "$own/AGENTS.md"
AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$own" >/dev/null
grep -q 'A stale pointer' "$own/AGENTS.md" && fail "install did not rewrite a stale pointer in AGENTS.md"
[ "$(grep -c '^<!-- afk:pointer:start' "$own/AGENTS.md")" = 1 ] || fail "install wrote the pointer into AGENTS.md twice"
grep -qx "the repository's own" "$own/AGENTS.md" || fail "rewriting the pointer lost the text below it"
linked="$scratch/linked"
git init --quiet "$linked"
printf 'the settings\n' > "$linked/CLAUDE.md"
ln -s CLAUDE.md "$linked/AGENTS.md"
AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$linked" >/dev/null
[ "$(cat "$linked/CLAUDE.md")" = "the settings" ] || fail "install wrote the pointer through an AGENTS.md link"
echo "check: AGENTS.md takes the kit's pointer and keeps the repository's own text"

# The mirrors: every skill and agent vendor/SOURCES installs everywhere is
# installed and listed, a by-name skill only when Security skills names it,
# and an unknown name, a local edit and a clash each stop the install.
everywhere="$(sed -n '/^vendored:$/,$ s/^  //p' "$repo/.claude/afk/MANIFEST")"
for source in $(grep -vE '^[[:space:]]*(#|$)' vendor/SOURCES | awk '$6 == "everywhere" {print $1}'); do
  [ -f "$repo/.claude/afk/licenses/$source.txt" ] || fail "install left out the license of $source"
done
for unit in $everywhere; do
  [ -e "$repo/$unit" ] || fail "install left out $unit, which MANIFEST lists"
done
grep -qx '\.claude/agents/[^/]*\.md' <<< "$everywhere" || fail "install installed no mirrored agent"
expected_skills="$(grep -vE '^[[:space:]]*(#|$)' vendor/SOURCES | awk '$6 == "everywhere" && $4 != "-" {print $1, $4}' \
  | while read -r source glob; do git ls-files "vendor/$source/${glob%/\*}" | grep -cE "^vendor/$source/${glob%/\*}/[^/]+/SKILL\.md$"; done \
  | awk '{ s += $1 } END { print s + 0 }')"
[ "$(grep -c '^\.claude/skills/' <<< "$everywhere")" = "$expected_skills" ] \
  || fail "install installed $(grep -c '^\.claude/skills/' <<< "$everywhere") mirrored skills, not the $expected_skills vendor/SOURCES installs everywhere"
by_name_source="$(grep -vE '^[[:space:]]*(#|$)' vendor/SOURCES | awk '$6 == "by-name" {print $1, $4}' | awk 'NR == 1')"
if [ -n "$by_name_source" ]; then
  read -r source glob <<< "$by_name_source"
  named="$(git ls-files "vendor/$source/${glob%/\*}" | sed -n "s#^vendor/$source/${glob%/\*}/\([^/]*\)/SKILL\.md\$#\1#p" | awk 'NR == 1')"
  [ ! -e "$repo/.claude/skills/$named" ] || fail "install installed $named, which Security skills does not name"
  printf '# Project\n\n- **Security skills:** `%s`\n' "$named" > "$repo/CLAUDE.md"
  AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" >/dev/null
  [ -f "$repo/.claude/skills/$named/SKILL.md" ] || fail "install left out $named, which Security skills names"
  status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
  [ "$status" = "$version, current" ] || fail "status with a Security skill reads '$status'"
  printf '\nA local edit.\n' >> "$repo/.claude/skills/$named/SKILL.md"
  case "$(cd "$repo" && bash .claude/afk/afk.sh status)" in
    *"edited locally: .claude/skills/$named/SKILL.md"*) ;;
    *) fail "status did not report a local edit to a mirrored skill" ;;
  esac
  if AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" >/dev/null 2>&1; then
    fail "install overwrote a mirrored skill edited in place"
  fi
  printf '# Project\n\n- **Security skills:** none\n' > "$repo/CLAUDE.md"
  AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" --discard-local-edits >/dev/null
  [ ! -e "$repo/.claude/skills/$named" ] || fail "install kept $named after Security skills stopped naming it"
fi
printf '# Project\n\n- **Security skills:** `no-such-skill`\n' > "$repo/CLAUDE.md"
if AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$repo" >/dev/null 2>&1; then
  fail "install ran with a Security skill the kit does not mirror"
fi
rm "$repo/CLAUDE.md"
status="$(cd "$repo" && bash .claude/afk/afk.sh status)"
[ "$status" = "$version, current" ] || fail "status after the mirror checks reads '$status'"
clash="$scratch/clash"
git init --quiet "$clash"
first="$(sed -n 1p <<< "$everywhere")"
mkdir -p "$(dirname "$clash/$first")"
printf 'the repository'"'"'s own\n' > "$clash/$first.own"
mv "$clash/$first.own" "$clash/$first"
if AFK_SOURCE="$scratch/kit" bash "$scratch/kit/.claude/afk/afk.sh" install "$clash" >/dev/null 2>&1; then
  fail "install replaced $first, which the repository wrote"
fi
[ ! -e "$clash/.claude/afk" ] || fail "install changed a repository it refused"
echo "check: the mirrors install, by name where asked, and stop on a clash"

# refresh.sh, against a local upstream: a refresh records the commit, a
# check reads current, then available once upstream changes the mirrored
# path but not for a change elsewhere, a skip holds until the next version,
# and changes lists the commit.
up="$scratch/upstreams/owner/repo"
mkdir -p "$up/plugins/one" "$up/other"
git init --quiet "$up"
printf 'license\n' > "$up/plugins/one/LICENSE"
printf 'first\n' > "$up/plugins/one/SKILL.md"
printf 'elsewhere\n' > "$up/other/file"
upcommit() {
  git -C "$up" add -A
  git -C "$up" -c user.name=check -c user.email=check@example.invalid commit --quiet -m "$1"
}
upcommit "first"
mirror="$scratch/mirror"
mkdir -p "$mirror/vendor"
cp refresh.sh "$mirror/"
printf 'one  owner/repo  plugins/one  -  -  everywhere\n' > "$mirror/vendor/SOURCES"
git init --quiet "$mirror"
refresh() { (cd "$mirror" && AFK_VENDOR_BASE="file://$scratch/upstreams" bash refresh.sh "$@"); }
refresh one >/dev/null
cmp -s "$up/plugins/one/SKILL.md" "$mirror/vendor/one/SKILL.md" || fail "refresh.sh did not mirror the source"
[ -f "$mirror/.claude/afk/licenses/one.txt" ] || fail "refresh.sh did not copy the license"
grep -qx "commit: $(git -C "$up" rev-parse HEAD)" "$mirror/vendor/one.upstream" || fail "refresh.sh did not record the commit"
git -C "$mirror" add -A
git -C "$mirror" -c user.name=check -c user.email=check@example.invalid commit --quiet -m mirror
[ "$(refresh --check)" = "one current" ] || fail "refresh.sh --check reads '$(refresh --check)' after a refresh"
printf 'moved\n' > "$up/other/file"
upcommit "elsewhere"
[ "$(refresh --check)" = "one current" ] || fail "refresh.sh --check offered a change outside the mirrored path"
printf 'second\n' > "$up/plugins/one/SKILL.md"
upcommit "second version"
case "$(refresh --check)" in
  "one "*"available") ;;
  *) fail "refresh.sh --check reads '$(refresh --check)', not available" ;;
esac
changes="$(refresh --changes one)"
grep -q 'second version' <<< "$changes" || fail "refresh.sh --changes did not list the commit"
grep -q 'elsewhere' <<< "$changes" && fail "refresh.sh --changes listed a commit outside the mirrored path"
grep -qx '+second' <<< "$(refresh --diff one SKILL.md)" || fail "refresh.sh --diff did not show the change"
refresh --skip one >/dev/null
case "$(refresh --check)" in
  "one "*"skipped") ;;
  *) fail "refresh.sh --check reads '$(refresh --check)' after a skip" ;;
esac
printf 'third\n' > "$up/plugins/one/SKILL.md"
upcommit "third version"
case "$(refresh --check)" in
  "one "*"available") ;;
  *) fail "refresh.sh --check did not offer the version after a skipped one" ;;
esac
refresh one >/dev/null
grep -q '^skipped:' "$mirror/vendor/one.upstream" && fail "a refresh kept the skip"
echo "check: refresh.sh refreshes, checks, lists changes and skips"

# A repository on a release before 2.0.0, when the kit was Claude-Kit in
# .claude/kit/, updates by running .claude/kit/kit.sh from the source with
# KIT_SOURCE set to the source its manifest names. The forwarder there must
# move it to .claude/afk/ and the kit's new address, losing nothing.
old="$scratch/old"
git init --quiet "$old"
mkdir -p "$old/.claude/kit/templates" "$old/.claude/skills/session-open" "$old/.claude/skills/session-close"
printf 'old house rules\n' > "$old/.claude/kit/HOUSE.md"
printf 'old sweep\n' > "$old/.claude/kit/todo_sweep.py"
printf 'old template\n' > "$old/.claude/kit/templates/TASKS.md"
printf 'old open\n' > "$old/.claude/skills/session-open/SKILL.md"
printf 'old close\n' > "$old/.claude/skills/session-close/SKILL.md"
old_manifest() {
  printf '# Written by kit.sh install. Never edit by hand.\nversion: 1.16.0\n'
  printf 'source: https://github.com/MrFieldTech/Claude-Kit\ncommit: unknown\nfiles:\n'
  for f in .claude/kit/HOUSE.md .claude/kit/templates/TASKS.md .claude/kit/todo_sweep.py \
    .claude/skills/session-close/SKILL.md .claude/skills/session-open/SKILL.md; do
    printf '  %s  %s\n' "$( (sha256sum "$old/$f" 2>/dev/null || shasum -a 256 "$old/$f") | cut -d' ' -f1)" "$f"
  done
}
old_manifest > "$old/.claude/kit/MANIFEST"
printf '@.claude/kit/HOUSE.md\n\n# Project\n\n- **Regenerate:** `python3 .claude/kit/todo_sweep.py`\n' > "$old/CLAUDE.md"
printf '# Tasks\n\nthe project queue\n' > "$old/TASKS.md"
mkdir -p "$old/.claude/references"
printf 'ran .claude/kit/kit.sh\n' > "$old/.claude/references/261015000000-old.md"
git -C "$old" add -A
git -C "$old" -c user.name=check -c user.email=check@example.invalid commit --quiet -m "1.16.0"

printf 'a local edit\n' >> "$old/.claude/kit/HOUSE.md"
if KIT_SOURCE=https://github.com/MrFieldTech/Claude-Kit bash "$scratch/kit/.claude/kit/kit.sh" install "$old" >/dev/null 2>&1; then
  fail "the move from .claude/kit/ overwrote a kit-owned file edited in place"
fi
git -C "$old" checkout --quiet -- .claude/kit/HOUSE.md
moved="$(KIT_SOURCE=https://github.com/MrFieldTech/Claude-Kit bash "$scratch/kit/.claude/kit/kit.sh" install "$old")"
[ ! -e "$old/.claude/kit" ] || fail "the move left .claude/kit/ behind"
for file in $(cd "$scratch/kit" && find "${AFK_OWNED[@]}" -type f | sort); do
  cmp -s "$scratch/kit/$file" "$old/$file" || fail "the move did not install $file"
done
grep -qx 'source: https://github.com/MrFieldTech/Artificial-Field-Kit' "$old/.claude/afk/MANIFEST" \
  || fail "the move did not record the kit's new address in the manifest"
[ "$(sed -n 1p "$old/CLAUDE.md")" = "@.claude/afk/HOUSE.md" ] || fail "the move did not point CLAUDE.md's import at .claude/afk/HOUSE.md"
grep -qF 'python3 .claude/kit/todo_sweep.py' "$old/CLAUDE.md" || fail "the move changed CLAUDE.md beyond its import"
[ "$(cat "$old/TASKS.md")" = "$(printf '# Tasks\n\nthe project queue')" ] || fail "the move changed TASKS.md"
grep -qx '  CLAUDE.md' <<< "$moved" || fail "the move did not list CLAUDE.md as still naming .claude/kit/"
grep -q 'references' <<< "$moved" && fail "the move listed a session reference, which is a record and stays"
printf '# TODO\n\nGenerated by `.claude/kit/todo_sweep.py` from every `TODO:` in the repository.\n' > "$old/TODO.md"
(cd "$old" && python3 .claude/afk/todo_sweep.py >/dev/null 2>&1) \
  || fail "the sweep refused a TODO.md written by its release before 2.0.0"
echo "check: a repository on a release before 2.0.0 moves to .claude/afk/"

# The sweep: a question, a statement, a wrapped question, a marker in
# backticks and one in a code fence, and a file the sweep must not read.
cat > "$repo/notes.md" <<'EOF'
# Notes

TODO: Who owns the backup schedule?

TODO: the port number.

TODO: Which host does the nightly job run on, and
who is told when it fails?

The convention is `TODO: <question>`, which is not itself a TODO.

```
TODO: inside a fence, which is an example.
```
EOF
printf 'x = 1  # TODO: Is this still used?\n' > "$repo/code.py"
printf 'TODO: never read?\n' > "$repo/key.secrets.md"
mkdir -p "$repo/.claude/references"
printf 'TODO: never read either?\n' > "$repo/.claude/references/261015000000-check.md"
git -C "$repo" add notes.md code.py key.secrets.md .claude/references
(cd "$repo" && python3 .claude/afk/todo_sweep.py >/dev/null)
expected='# TODO

Generated by `.claude/afk/todo_sweep.py` from every `TODO:` in the repository. Never edit it by
hand: answer each question where it is asked, then run the sweep again.

**4 open, in 2 files.** 1 is not yet written as a question.

## `code.py`

- Line 1: Is this still used?

## `notes.md`

- Line 3: Who owns the backup schedule?
- Line 5: the port number. **Not yet a question.**
- Line 7: Which host does the nightly job run on, and who is told when it fails?
'
[ "$(cat "$repo/TODO.md")" = "${expected%$'\n'}" ] || {
  diff <(printf '%s' "$expected") "$repo/TODO.md" >&2 || true
  fail "the sweep wrote something other than expected, diff above"
}
(cd "$repo" && python3 .claude/afk/todo_sweep.py --check >/dev/null) \
  || fail "the sweep calls its own fresh output stale"
printf 'TODO: A new question?\n' >> "$repo/code.py"
if (cd "$repo" && python3 .claude/afk/todo_sweep.py --check >/dev/null 2>&1); then
  fail "the sweep missed a stale TODO.md"
fi
printf '# My own list\n' > "$repo/TODO.md"
if (cd "$repo" && python3 .claude/afk/todo_sweep.py >/dev/null 2>&1); then
  fail "the sweep overwrote a TODO.md it did not write"
fi
echo "check: the TODO sweep works"

# 7. The secrets tool, in a scratch repository of its own, with keys made
# outside it as the owner would make them. Values are fixed strings, so a
# grep for one proves it never reached a file in plaintext.
if command -v age >/dev/null 2>&1 && command -v age-keygen >/dev/null 2>&1; then
  srepo="$scratch/srepo"
  keys="$scratch/keys"
  mkdir -p "$keys"
  git init --quiet "$srepo"
  cp -R "$repo/.claude" "$srepo/"
  cp "$scratch/kit/.claude/afk/templates/HANDOFF.md" "$srepo/HANDOFF.md"
  # The template has no Credentials In Transit since 1.6.0. An older
  # HANDOFF.md keeps one, and the tool still reads it there.
  printf '\n## Credentials In Transit\n\nNone.\n' >> "$srepo/HANDOFF.md"
  for k in one two three; do age-keygen -o "$keys/$k" 2>/dev/null; done
  pub() { age-keygen -y "$keys/$1"; }
  secrets() { (cd "$srepo" && python3 .claude/afk/secrets.py "$@"); }

  (cd "$srepo" && python3 .claude/afk/secrets.py check >/dev/null) \
    || fail "secrets check fails on a repository with no secrets"
  if printf 'v' | secrets set secrets/svc.secrets.md "Token" >/dev/null 2>&1; then
    fail "secrets set encrypted with no secrets-recipients.txt"
  fi
  printf '# Owner\n%s\n# Recovery\n%s\n' "$(pub one)" "$(pub two)" > "$srepo/secrets-recipients.txt"

  secrets set secrets/svc.secrets.md "Token" >/dev/null <<< 'check-value-one'
  printf 'check-line-a\ncheck-line-b' | secrets set secrets/svc.secrets.md "Private key" >/dev/null
  secrets set secrets/svc.secrets.md "Token" >/dev/null <<< 'check-value-two'
  secrets set HANDOFF.md "Pending token" >/dev/null <<< 'check-value-transit'
  age -a -r "$(pub one)" -r "$(pub two)" > "$scratch/block" <<< 'check-value-placed'
  secrets place secrets/svc.secrets.md "Placed" < "$scratch/block" >/dev/null
  age -a -r "$(pub one)" > "$scratch/block" <<< 'x'
  if secrets place secrets/svc.secrets.md "Short" < "$scratch/block" >/dev/null 2>&1; then
    fail "secrets place took a block encrypted to fewer keys than secrets-recipients.txt lists"
  fi
  if printf 'v' | secrets set notes.md "Token" >/dev/null 2>&1; then
    fail "secrets set wrote to a file that is not a .secrets.md file"
  fi
  if grep -rq 'check-value\|check-line' "$srepo/secrets" "$srepo/HANDOFF.md"; then
    fail "a value reached a file in plaintext"
  fi
  secrets check >/dev/null || fail "secrets check fails on values set and placed by the tool"

  shown="$(secrets show secrets/svc.secrets.md --identity "$keys/two")"
  for want in '`check-value-two`' 'check-line-a' 'check-line-b' '`check-value-placed`'; do
    grep -qF -- "$want" <<< "$shown" || fail "secrets show did not give back $want"
  done
  grep -q 'check-value-one' <<< "$shown" && fail "secrets set kept a replaced value"
  [ "$(grep -c '^\*\*Token\*\*$' "$srepo/secrets/svc.secrets.md")" = 1 ] \
    || fail "secrets set added a second Token label instead of replacing its value"
  grep -qF '`check-value-transit`' <<< "$(SECRETS_AGE_KEY="$(cat "$keys/one")" secrets show HANDOFF.md)" \
    || fail "secrets show did not read a value in transit with SECRETS_AGE_KEY"

  printf -- '---\nslug: old\nupdated: 2026-01-01\n---\n\n**Password**\n\n`check-plain`\n\n**Codes**\n\n```\ncheck-code-1\ncheck-code-2\n```\n' \
    > "$srepo/old.secrets.md"
  if secrets check >/dev/null 2>&1; then fail "secrets check passed a file holding plaintext"; fi
  secrets lock old.secrets.md >/dev/null
  grep -q 'check-plain\|check-code' "$srepo/old.secrets.md" && fail "secrets lock left plaintext behind"
  secrets check >/dev/null || fail "secrets check fails after lock"
  grep -qF 'check-code-2' <<< "$(secrets show old.secrets.md --identity "$keys/one")" \
    || fail "secrets lock lost a value of more than one line"

  cp "$srepo/HANDOFF.md" "$scratch/handoff"
  sed -i.bak 's/^\*\*Pending token\*\*$/&\n\n`check-leak`/' "$srepo/HANDOFF.md"
  if secrets check >/dev/null 2>&1; then fail "secrets check passed plaintext under Credentials In Transit"; fi
  cp "$scratch/handoff" "$srepo/HANDOFF.md"
  printf -- '---\nslug: other\nupdated: 2026-01-01\n---\n' > "$srepo/wrong.secrets.md"
  if secrets check >/dev/null 2>&1; then fail "secrets check passed a file whose slug is not its name"; fi
  rm "$srepo/wrong.secrets.md" "$srepo/HANDOFF.md.bak"

  printf '%s\n' "$(pub three)" > "$srepo/secrets-recipients.txt"
  secrets rekey --identity "$keys/one" >/dev/null
  grep -qF '`check-value-transit`' <<< "$(secrets show HANDOFF.md --identity "$keys/three")" \
    || fail "secrets rekey did not re-encrypt HANDOFF.md to the new key"
  grep -qF 'check-code-1' <<< "$(secrets show old.secrets.md --identity "$keys/three")" \
    || fail "secrets rekey did not re-encrypt to the new key"
  if secrets show secrets/svc.secrets.md --identity "$keys/one" >/dev/null 2>&1; then
    fail "a removed key still reads a value after rekey"
  fi
  grep -qF "$(pub three)" <<< "$(secrets steps)" || fail "secrets steps does not write the keys in"

  # A session reference's companion is a secrets file like any other, and
  # no build decrypts it.
  companion=".claude/references/261015000000-check.secrets.md"
  secrets set "$companion" "Token" >/dev/null <<< 'check-value-companion'
  grep -qx 'slug: 261015000000-check' "$srepo/$companion" || fail "a companion's slug is not its name"
  secrets check >/dev/null || fail "secrets check fails on a companion"

  # A copy under .claude/imported/ keeps its source's encryption and a name
  # its frontmatter does not give. Check reads it, and rekey and both
  # decrypters leave it alone.
  imported=".claude/imported/session-import/261015000000-check-261017000000.secrets.md"
  mkdir -p "$srepo/.claude/imported/session-import"
  age -a -r "$(pub one)" > "$scratch/block" <<< 'check-value-imported'
  { printf -- '---\nslug: 261015000000-check\nupdated: 2026-10-15\n---\n\n**Token**\n\n```age\n'
    cat "$scratch/block"; printf '```\n'; } > "$srepo/$imported"
  cp "$srepo/$imported" "$scratch/imported"
  secrets check >/dev/null || fail "secrets check fails on a copy under .claude/imported/"
  secrets rekey --identity "$keys/three" >/dev/null || fail "secrets rekey tried to re-encrypt a copy"
  cmp -s "$srepo/$imported" "$scratch/imported" || fail "secrets rekey changed a copy under .claude/imported/"

  # Decrypt for a build: a copy at the same path under a gitignored
  # directory, the check build's placeholders, and every refusal.
  printf '/build-secrets/\n' > "$srepo/.gitignore"
  if secrets decrypt --out "$srepo/build-secrets" >/dev/null 2>&1; then
    fail "secrets decrypt ran with no key"
  fi
  if SECRETS_AGE_KEY="$(cat "$keys/three")" secrets decrypt --out "$srepo/tracked" >/dev/null 2>&1; then
    fail "secrets decrypt wrote into a directory git does not ignore"
  fi
  if SECRETS_AGE_KEY="$(cat "$keys/one")" secrets decrypt --out "$srepo/build-secrets" >"$scratch/out" 2>&1; then
    fail "secrets decrypt passed with a key that reads no value"
  fi
  grep -qF 'old.secrets.md: Password will not decrypt' "$scratch/out" \
    || fail "secrets decrypt did not name the file and label that would not decrypt: $(cat "$scratch/out")"
  [ -e "$srepo/build-secrets" ] && fail "secrets decrypt wrote files before every value decrypted"
  SECRETS_AGE_KEY="$(cat "$keys/three")" secrets decrypt --out "$srepo/build-secrets" >/dev/null \
    || fail "secrets decrypt failed with a key that reads every value"
  copy="$srepo/build-secrets/secrets/svc.secrets.md"
  for want in '`check-value-two`' 'check-line-a' '`check-value-placed`' '**Token**' 'slug: svc'; do
    grep -qF -- "$want" "$copy" || fail "secrets decrypt did not write $want"
  done
  grep -q 'BEGIN AGE' "$copy" && fail "secrets decrypt left an encrypted block in its copy"
  grep -qF 'check-code-1' "$srepo/build-secrets/old.secrets.md" || fail "secrets decrypt missed a file"
  [ -e "$srepo/build-secrets/HANDOFF.md" ] && fail "secrets decrypt wrote HANDOFF.md"
  [ -e "$srepo/build-secrets/.claude" ] && fail "secrets decrypt wrote a session reference's companion"
  [ "$(cd "$srepo" && git status --porcelain --untracked-files=all | grep -c build-secrets)" = 0 ] \
    || fail "the decrypted copy is not ignored by git"
  rm -rf "$srepo/build-secrets"
  mkdir "$scratch/noage"
  ln -s "$(command -v python3)" "$(command -v git)" "$scratch/noage/"
  SECRETS_CHECK_BUILD=1 PATH="$scratch/noage" \
    secrets decrypt --out "$srepo/build-secrets" >/dev/null \
    || fail "a check build needed a key or the age tool"
  grep -q 'check-value' "$copy" && fail "a check build wrote a real value"
  grep -qF '`secrets-check-build-placeholder`' "$copy" || fail "a check build wrote no placeholder"

  keys_out="$(secrets keys)"
  for want in age-key-owner.txt age-key-build.txt age-key-recovery.txt SECRETS_AGE_KEY; do
    grep -qF "$want" <<< "$keys_out" || fail "secrets keys does not mention $want"
  done
  grep -qF age-key-ops.txt <<< "$(secrets keys owner ops)" || fail "secrets keys ignored the holders named"
  grep -q age-key-build <<< "$(secrets keys owner ops)" && fail "secrets keys added a holder not named"

  # The Node decrypter must write what secrets.py writes.
  if command -v node >/dev/null 2>&1; then
    rm -rf "$srepo/build-secrets"
    (cd "$srepo" && SECRETS_CHECK_BUILD=1 node .claude/afk/secrets-decrypt.mjs --out build-secrets >/dev/null) \
      || fail "the Node decrypter failed a check build"
    grep -qF '`secrets-check-build-placeholder`' "$copy" || fail "the Node check build wrote no placeholder"
    [ -e "$srepo/build-secrets/.claude" ] && fail "the Node decrypter wrote a session reference's companion"
    if (cd "$srepo" && node .claude/afk/secrets-decrypt.mjs --out build-secrets >/dev/null 2>&1); then
      fail "the Node decrypter ran with no key"
    fi
    if (cd "$srepo" && SECRETS_CHECK_BUILD=1 node .claude/afk/secrets-decrypt.mjs --out tracked >/dev/null 2>&1); then
      fail "the Node decrypter wrote into a directory git does not ignore"
    fi
    if [ -n "${CHECK_NODE_MODULES:-}" ]; then
      ln -s "$CHECK_NODE_MODULES" "$srepo/node_modules"
      printf 'node_modules\n' >> "$srepo/.gitignore"
      SECRETS_AGE_KEY="$(cat "$keys/three")" secrets decrypt --out "$scratch/py-out" >/dev/null
      rm -rf "$srepo/build-secrets"
      (cd "$srepo" && SECRETS_AGE_KEY="$(cat "$keys/three")" node .claude/afk/secrets-decrypt.mjs --out build-secrets >/dev/null) \
        || fail "the Node decrypter failed with a key that reads every value"
      diff -r "$scratch/py-out" "$srepo/build-secrets" >&2 \
        || fail "the Node decrypter wrote something other than secrets.py decrypt, diff above"
      if (cd "$srepo" && SECRETS_AGE_KEY="$(cat "$keys/one")" node .claude/afk/secrets-decrypt.mjs --out build-secrets >/dev/null 2>&1); then
        fail "the Node decrypter passed with a key that reads no value"
      fi
    fi
  fi
  echo "check: the secrets tool works"
elif [ -n "${CI:-}" ]; then
  fail "age is not installed, and CI must test the secrets tool"
else
  echo "check: the secrets tool was not tested (age is not installed)"
fi

# 8. This repository keeps its own TODO.md by the sweep it ships. This file is
# excluded because the fixtures above are TODOs by design, and vendor/ because
# its mirrors are upstream's.
python3 .claude/afk/todo_sweep.py --exclude check.sh --exclude 'vendor/*' --check
