# Session Reference: Let Other AI Tools Run The Kit

**Task:** `vendor-neutral-update`, DONE at close
**Repository:** MrFieldTech/Artificial-Field-Kit
**Developer:** GRM / MRFIELDTECH
**Written:** 2026-11-13 19:53:14 UTC
**Commits:** `2f2138c..240754d` on `task/vendor-neutral-update`
**Companion:** none

## Current State

Done. Release 2.4.0 lets any AI coding tool run the kit: `afk.sh` keeps a
pointer block at the top of `AGENTS.md` that sends a tool to `CLAUDE.md`
and `HOUSE.md` and says how to run the two skills without slash commands.
The kit's own wording no longer assumes Claude Code. Only Claude has run
it; a checklist for another vendor's tool is in the task's block.

## Decisions

- The vendor-neutral file is `AGENTS.md`, a pointer holding no rules;
  `CLAUDE.md` keeps the settings. GRM / MRFIELDTECH, 2026-11-13.
- `AGENTS.md` is project-owned; the kit writes only the block between its
  markers, adds it above existing text, and leaves a link alone. GRM /
  MRFIELDTECH, 2026-11-13.
- Another tool runs `/session-open <words>` and `/session-close` by reading
  the skill file, typed without `/` where the tool keeps it; both run only
  when the owner asks. GRM / MRFIELDTECH, 2026-11-13.
- Claude-specific wording becomes neutral, with Claude Code details kept as
  labeled notes; the mirrored skills and agent stay where they are; the
  README prompts are neutral with a Claude Code section. GRM /
  MRFIELDTECH, 2026-11-13.
- A repository's own text in `AGENTS.md` ranks with `CLAUDE.md`, which wins
  a conflict. GRM / MRFIELDTECH, 2026-11-13.
- The rebuild around a neutral layout waits, as `neutral-layout`. GRM /
  MRFIELDTECH, 2026-11-13.
- The prefix rule stays, and a local session starts on the default branch
  or a task branch. GRM / MRFIELDTECH, 2026-11-13.

## Verified Facts

- `bash check.sh` passed on `240754d`, including four `AGENTS.md` install
  cases. Source: the command.
- An install into a repository whose `AGENTS.md` has a start marker and no
  end marker leaves the file as it is and says so. Source: `afk.sh
  install` in a scratch repository.
- A Claude session told to start from `AGENTS.md` and use nothing else
  found seven gaps, all fixed: `temp` reached First Run and the stray stop
  before step 4; First Run never read `HOUSE.md`; uncommitted changes were
  never considered; no re-read of the skill after a summary; three GitHub
  steps had no `gh` command; a new block had no pointer to Format; upload
  was undefined. Source: the cold read, 2026-11-13.
- This session's cloud branch has two parts, `<prefix>/<name>`, so a
  branch's shape cannot tell a tool's branch from a developer's. Source:
  `git rev-parse --abbrev-ref HEAD` at open.

## Exact Values

- The release: `2.4.0`, update slug `afk-update-2-4-0`
- Pointer markers: a line starting `<!-- afk:pointer:start` and the line
  `<!-- afk:pointer:end -->`
- Template: `.claude/afk/templates/AGENTS.md`

## Artifacts

- `.claude/afk/templates/AGENTS.md` and this repository's `AGENTS.md`.
- `agents_pointer` in `.claude/afk/afk.sh`.
- Neutral wording in `.claude/afk/HOUSE.md`, both skills,
  `.claude/afk/references.md`, `.claude/afk/standards/site.md` and
  `README.md`; tests in `check.sh`; the 2.4.0 entry in `CHANGELOG.md`.
- `neutral-layout` queued in `TASKS.md`.

## Gotchas

- `check.sh` installs from a clone of `HEAD`, so a change must be committed
  before its install tests see it.
- Some tools keep `/` for their own commands, so the skills are also typed
  as `session-open <words>`.

## Flagged As Unverified

- Which tools read `AGENTS.md` and `.agents/skills/`, from secondary
  sources. Verified by: each vendor's own documentation.
- That another vendor's tool can follow the protocol. Verified by: the
  checklist in `vendor-neutral-update`'s block.

## Open Questions

- Should a close record what it notes for a later step, such as step 8's
  hash, in the task's block, so a summarized context does not lose it?
  MrFieldTech can answer.

## Credentials

None.

## Subjects

### Artificial Field Kit

**Slug:** `artificial-field-kit`
**Kind:** project

- From 2.4.0 any AI coding tool reaches the kit by the pointer at the top
  of `AGENTS.md`. Source: `.claude/afk/templates/AGENTS.md`.
- A session that opens on uncommitted changes stops until they are
  committed, stashed or discarded. Source: `session-open` step 1.
