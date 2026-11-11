# Session Reference: Carry The Site And Design Standards In The Kit

**Task:** `skill-incorporation`, DONE at close
**Repository:** MrFieldTech/Artificial-Field-Kit
**Developer:** GRM / MRFIELDTECH
**Written:** 2026-11-11 18:40:10 UTC
**Commits:** `4995d34..003517b` on `task/skill-incorporation`
**Companion:** none

## Current State

Done. Release 2.1.0 adds `.claude/afk/standards/`: `site.md`, the site
standard, `content-policy.md`, its content policy template, and
`design.md`, twenty design rules, named in a new Standards section of
`HOUSE.md`. Two tasks are open for later: `house-instructions`, the
owner's general instructions and Permission to Fail, and `vendored-skills`,
outside skills mirrored into the kit.

## Decisions

- The kit is the site standard's source, generic; the repository that held
  it turns its copy into a pointer by a task there. GRM / MRFIELDTECH,
  2026-11-11.
- One site standard in parts: static first, a free Cloudflare Pages site;
  full featured when a site takes in visitors' data, with a warning before
  it needs more than Cloudflare's free plan. GRM / MRFIELDTECH, 2026-11-11.
- The free plan sets the warning line, read from Cloudflare's pricing pages
  when a site is built. GRM / MRFIELDTECH, 2026-11-11.
- Design is its own standard, for any interface. GRM / MRFIELDTECH,
  2026-11-11.
- Fonts are always served from the site's own origin. GRM / MRFIELDTECH,
  2026-11-11.
- Analytics never capture key events and mask every input. GRM /
  MRFIELDTECH, 2026-11-11.
- Signup confirms 13 or older and stores only the confirmation and its
  time, never a birth date or age. GRM / MRFIELDTECH, 2026-11-11.
- Email to a list carries a visible one-click unsubscribe, the one-click
  headers and the mailing address. GRM / MRFIELDTECH, 2026-11-11.
- Uploads need a consent checkbox, a content policy from a kit template
  and a Report Infringement link; the copyright agent is a checklist TODO
  for United States sites. GRM / MRFIELDTECH, 2026-11-11.
- Part 2's questions are never asked of a static site. GRM / MRFIELDTECH,
  2026-11-11.
- Part 2 fixes no stack for now. GRM / MRFIELDTECH, 2026-11-11.
- The standard follows the kit's version; its own number ends at 1.2.
  GRM / MRFIELDTECH, 2026-11-11.
- The request splits into three tasks, each its own release. GRM /
  MRFIELDTECH, 2026-11-11.

## Verified Facts

- `code-simplifier` in anthropics/claude-plugins-official is an agent,
  `plugins/code-simplifier/agents/code-simplifier.md`, Apache License 2.0.
  Source: a clone at `43fd1f9`.
- mukul975/Anthropic-Cybersecurity-Skills holds 818 skills in 49 MB,
  Apache License 2.0. Source: a clone at `54a7988`.
- emilkowalski/skills holds 18 skills, MIT; `mobile-native` is for web
  apps on phones, not native apps. Source: a clone at `715c180`.
- cloudflare/security-audit-skill holds one skill, MIT. Source: a clone at
  `c1c8a8c`.
- `check.sh` failed every address in a kit-owned file, including
  placeholder addresses such as `https://www.<domain>/`. Source: `bash
  check.sh` on the first `site.md` commit.
- `afk.sh` installs everything under `.claude/afk/`, so a new folder there
  needs no installer change. Source: `afk.sh` lines 14 and 54 to 65.

## Exact Values

- The standards folder: `.claude/afk/standards/`
- The release: `2.1.0`, update slug `afk-update-2-1-0`

## Artifacts

- `.claude/afk/standards/site.md`, `content-policy.md`, `design.md`.
- `HOUSE.md`: a Standards section, and standards fifth in Which file wins.
- `check.sh`: placeholder addresses allowed; every standard must be named
  in `HOUSE.md`.
- `TASKS.md`: blocks for `house-instructions` and `vendored-skills`, with
  the owner's request and uploaded instructions quoted in full.
- `.claude/imported/session-import/Generic_Instructions-261111174732.md`,
  the placeholder for the uploaded instructions.

## Gotchas

- `check.sh` clones `HEAD`, so a `VERSION` change fails its status check
  until committed.
- `AFK_PRIVATE_TERMS` was not set, so this reference and the upload were
  not checked against the private terms list; the upload got a
  placeholder.

## Flagged As Unverified

- Cloudflare's free plan includes Pages Functions, Workers, KV and D1
  within daily limits. Verified by: reading Cloudflare's pricing pages.
- The legal grounds Part 2 cites: the under 13 line, copyright agent
  registration, providers acting on one-click headers. Verified by: the
  owner, where a site operates.

## Open Questions

None.

## Credentials

None.

## Subjects

### Site standard

**Slug:** `site-standard`
**Kind:** process

- Lives at `.claude/afk/standards/site.md` from 2.1.0; Part 1 static,
  Part 2 full featured, HOST rules between them. Source: this release.

### Design standard

**Slug:** `design-standard`
**Kind:** process

- Lives at `.claude/afk/standards/design.md` from 2.1.0, DESIGN-1 to
  DESIGN-20. Source: this release.
