# Session Reference: Add The Owner's General Instructions And Permission To Fail To The House Rules

**Task:** `house-instructions`, DONE at close
**Repository:** MrFieldTech/Artificial-Field-Kit
**Developer:** GRM / MRFIELDTECH
**Written:** 2026-11-11 19:35:45 UTC
**Commits:** `2768c9d..ac6d2e7` on `task/house-instructions`
**Companion:** none

## Current State

Done. Release 2.2.0 puts the owner's general instructions and a Permission
to fail section into `HOUSE.md`, and `check.sh` fails on an en dash.

## Decisions

- Permission to Fail's rules on inventing, guessing and pointing out
  errors join Rules for every action; the real attempt and the failure
  report are their own section. MrFieldTech, 2026-11-11.
- The general instructions merge into existing sections; Response format
  gains Writing for the owner and Commands for the owner. MrFieldTech,
  2026-11-11.
- The failure report sits under What brevity never suppresses, in place of
  part 1's description. MrFieldTech, 2026-11-11.
- En dashes are banned with em dashes, and `check.sh` enforces it.
  MrFieldTech, 2026-11-11.
- No Audience key; a repository sets a higher level in its `CLAUDE.md`.
  MrFieldTech, 2026-11-11.
- American English and spelling out acronyms go in. MrFieldTech,
  2026-11-11.
- "Tell me a confirmed fact so it can be recorded" is dropped, because the
  close records facts. MrFieldTech, 2026-11-11.
- Confirming commands first applies only to commands the owner runs.
  MrFieldTech, 2026-11-11.

## Verified Facts

- No tracked file held an en dash before 2.2.0. Source: `grep` for U+2013
  over the repository.
- `bash check.sh` passed in full on `ac6d2e7`. Source: the command.
- The git remote now redirects pushes to
  MrFieldTech/Artificial-Field-Kit. Source: the push output.

## Exact Values

- The release: `2.2.0`, update slug `afk-update-2-2-0`

## Artifacts

- `.claude/afk/HOUSE.md`: Rules for every action widened, Permission to
  fail added, Response format with the answer first and two new
  subsections.
- `check.sh`: section 2 also fails on an en dash.
- `VERSION`, `CHANGELOG.md`, `README.md`: release 2.2.0.

## Gotchas

- `check.sh` clones `HEAD`, so a `VERSION` change fails its status check
  until committed.
- `AFK_PRIVATE_TERMS` was not set, so this reference was not checked
  against the private terms list.

## Flagged As Unverified

- The 2.2.0 response rules have not run in a live session. Verified by:
  the first session that loads 2.2.0.

## Open Questions

None.

## Credentials

None.

## Subjects

### House rules

**Slug:** `house-rules`
**Kind:** process

- From 2.2.0, `HOUSE.md` has a Permission to fail section, and Response
  format has Writing for the owner and Commands for the owner. Source:
  this release.
