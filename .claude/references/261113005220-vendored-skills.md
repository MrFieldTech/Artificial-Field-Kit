# Session Reference: Mirror Outside Skills And Agents Into The Kit

**Task:** `vendored-skills`, DONE at close
**Repository:** MrFieldTech/Artificial-Field-Kit
**Developer:** GRM / MRFIELDTECH
**Written:** 2026-11-13 00:52:20 UTC
**Commits:** `d5dbf75..904db23` on `task/vendored-skills`
**Companion:** none

## Current State

Done. Release 2.3.0 mirrors four outside sources under `vendor/` and
installs their skills and agent into every repository as kit-owned files,
the cybersecurity skills only by name. `refresh.sh` refreshes a mirror and
checks for upstream updates.

## Decisions

- The mirrors live in this repository under `vendor/<name>/`, and
  `afk.sh` fetches the kit by a blobless sparse clone, so a repository
  downloads only what it installs. MrFieldTech, 2026-11-11.
- Mirrors are kept bit for bit; `check.sh` and the TODO sweep skip
  `vendor/`. MrFieldTech, 2026-11-11.
- Installed copies are kit-owned, listed under `vendored` in `MANIFEST`.
  MrFieldTech, 2026-11-11.
- The cybersecurity skills install only by the Security skills key,
  default `none`; each is read before it is named, and all are reviewed
  later in `security-skill-review`. MrFieldTech, 2026-11-11.
- A clash with a repository's own skill or agent stops the install.
  MrFieldTech, 2026-11-11.
- cloudflare/security-audit-skill installs everywhere; this repository
  does not install the mirrors into itself. MrFieldTech, 2026-11-11.
- Each skill installs to `.claude/skills/<name>/` and the agent to
  `.claude/agents/`, not one plugin folder. MrFieldTech, 2026-11-12.
- Only `plugins/code-simplifier/` of anthropics/claude-plugins-official is
  mirrored. MrFieldTech, 2026-11-13.
- Sessions here run `refresh.sh --check` at every open and before every
  release, and for an update say what changed and offer update, remind
  later or skip. MrFieldTech, 2026-11-13.

## Verified Facts

- Claude Code loads project skills only from `.claude/skills/<name>/` and
  nested `<dir>/.claude/skills/`, and project agents only from
  `.claude/agents/`; a plugin folder under `.claude/skills/` loads with its
  skills namespaced. Source: Claude Code's skills and sub-agents
  documentation, read 2026-11-11.
- `afk.sh status` fetched the whole kit at every open before 2.3.0.
  Source: `fetch_source` in `.claude/afk/afk.sh` at 2.2.0.
- A blobless sparse clone of the 50 MB cybersecurity collection came to
  1.5 MB in about a second, and an install from the task branch on GitHub
  with two Security skills to 1.9 MB. Source: the commands.
- A repository on 2.2.0 updated to 2.3.0 from a local clone and read
  current. Source: `afk.sh update` and `status` in a scratch repository.
- `bash check.sh` passed on `904db23`. Source: the command.
- A Git tree hash of a mirrored path upstream equals the committed tree of
  `vendor/<name>`, so `refresh.sh --check` compares content without
  downloading it. Source: `git rev-parse` on both, 2026-11-13.

## Exact Values

- The release: `2.3.0`, update slug `afk-update-2-3-0`
- Mirrored commits: emilkowalski/skills `f7ce8c0`,
  cloudflare/security-audit-skill `c1c8a8c`,
  anthropics/claude-plugins-official `e0ab6e5` (`plugins/code-simplifier`),
  mukul975/Anthropic-Cybersecurity-Skills `54a7988`
- Counts: 19 emilkowalski skills, 1 security audit skill, 1 agent, 818
  cybersecurity skills

## Artifacts

- `vendor/` with `SOURCES`, one directory and one `.upstream` file per
  source.
- `refresh.sh`: refresh, `--check`, `--changes`, `--diff`, `--skip`.
- `.claude/afk/afk.sh`: sparse fetch, the vendor plan, clash stop,
  `vendored` in `MANIFEST`.
- `.claude/afk/licenses/`: each source's license.
- `.claude/afk/HOUSE.md`: Mirrored skills section, Security skills key.
- `check.sh`: tests of the mirrors' install and of `refresh.sh`.
- `CLAUDE.md`: the update-check project rule.

## Gotchas

- Under `set -o pipefail`, `cmd | grep -q` or `cmd | head -n 1` fails
  when `cmd` writes more after the reader exits; capture into a variable
  first.
- Upstream changed between counting and mirroring: emilkowalski/skills
  gained `learn-taste`, and anthropics/claude-plugins-official moves often
  outside the mirrored folder.
- Running an older `afk.sh install` over a newer install drops the
  `vendored` list, so the next install reads every mirrored skill as a
  clash.
- `AFK_PRIVATE_TERMS` was not set, so this reference was not checked
  against the private terms list.

## Flagged As Unverified

- No repository has taken 2.3.0 from GitHub's default branch. Verified
  by: the first update to 2.3.0.
- Installed mirrors may read as edited on a Windows checkout that turns LF
  into CRLF. Verified by: `afk.sh status` there.
- No session has used a mirrored skill or the agent. Verified by: a
  session in a repository on 2.3.0.

## Open Questions

None.

## Credentials

None.

## Subjects

### The kit's mirrored skills

**Slug:** `kit-mirrored-skills`
**Kind:** system

- Sources and what each installs are listed in `vendor/SOURCES`. Source:
  the file.
- A Security skill is installed by naming it in backticks under Security
  skills in `CLAUDE.md` and running `bash .claude/afk/afk.sh update`.
  Source: `HOUSE.md`, Mirrored skills.

### The kit's installer

**Slug:** `kit-installer`
**Kind:** system

- From 2.3.0 it fetches the kit by `git clone --depth 1 --filter=blob:none
  --sparse` and checks out only kit-owned paths and installed mirrors.
  Source: `.claude/afk/afk.sh`.
