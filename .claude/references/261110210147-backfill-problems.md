# Session Reference: Point The Backfill Recovery Prompt At The Right Branch And Repository

**Task:** `backfill-problems`, DONE at close
**Repository:** MrFieldTech/Claude-Kit
**Developer:** GRM / MRFIELDTECH
**Written:** 2026-11-10 21:01:47 UTC
**Commits:** `6d6212a..333e4c2` on `task/backfill-problems`
**Companion:** none

## Current State

Done. Release 1.16.0 has the BACKFILL RECOVERY PROMPT choose the
repository the session worked in, find the base as `session-open` step 2
does, and check and read the kit there instead of on the default branch.
`references.md` says a backfill covers only its own repository. Merged
into `preview` at this close; not promoted to `main`.

## Decisions

- The recovery prompt checks for the kit, checks its release and reads the
  kit files on the integration branch when it exists on the remote, else
  on the default branch. MrFieldTech, 2026-11-10.
- With more than one repository in the session, a backfill goes into the
  one the session committed to or ran a kit open in, never one it only
  read from, and the session asks when work landed in more than one.
  MrFieldTech, 2026-11-10.

## Verified Facts

- The 1.15.0 prompt's items 2 to 4 checked and read the kit on the default
  branch only. Source: `README.md` at `40fe967`, Backfill.
- A kit update merges into the integration branch at close and reaches the
  default branch only on promotion, so a just-updated repository failed
  the 1.15.0 prompt's release check. Source: the reply of a session in
  another of the owner's repositories, pasted into this session's
  `/session-open` on 2026-10-19.
- The 1.15.0 prompt said "this repository" and never chose between
  repositories when a session had more than one. Source: `README.md` at
  `40fe967`.
- `bash check.sh` passed on `333e4c2`. Source: the command's output in
  this session.

## Exact Values

- Release: `1.16.0`
- Update slug: `kit-update-1-16-0`

## Artifacts

- `README.md`: the Backfill introduction, items 1 to 5 of the BACKFILL
  RECOVERY PROMPT, the update slug.
- `.claude/kit/references.md`: Its own repository only, under Backfilling.
- `CHANGELOG.md`, `VERSION`: release 1.16.0.

## Gotchas

- `check.sh` fails on the status line until the release is committed.
- The prompt's items were renumbered: the self-close approval is now item
  9, not item 8.

## Flagged As Unverified

- Whether the 1.16.0 prompt picks the right repository and base in a
  session with two repositories. Verified by: a run in one whose kit
  update sits unpromoted on the integration branch.

## Open Questions

None.

## Credentials

None.

## Subjects

### Claude-Kit backfill

**Slug:** `kit-backfill`
**Kind:** process

- From 1.16.0 the recovery prompt works from the base, the integration
  branch when it exists. Source: `README.md`, Backfill, items 3 to 5.
- A backfill covers only its own repository, and a repository the session
  only read from gets none. Source: `.claude/kit/references.md`,
  Backfilling.
