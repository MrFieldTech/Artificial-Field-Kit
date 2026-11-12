@.claude/afk/HOUSE.md

# Artificial Field Kit

The session protocol and house rules shared by MrFieldTech's repositories, installed
into each one as a pinned copy. This repository is the source. The files under
`.claude/afk/` and the two skills in `.claude/skills/` are edited here and
nowhere else, and this repository's own sessions run on them directly.
`README.md` says what the kit is and how it is installed.

## Session Settings

Read by `session-open` and `session-close`, which name no value of their own.
What each key means is at the end of `.claude/afk/HOUSE.md`. Change a value
here, never in a kit-owned file.

- **Owner:** MrFieldTech
- **Authority file:** none
- **Default branch:** `main`. Every install and update takes it, so it moves
  only when MrFieldTech asks.
- **Integration branch:** `preview`
- **Other branches:** none
- **Task preview address:** none
- **Integration preview address:** none
- **Task slug limit:** 23
- **Reserved slugs:** none
- **Regenerate:** `python3 .claude/afk/todo_sweep.py --exclude check.sh
  --exclude 'vendor/*'`. The fixtures in `check.sh` are TODOs by design,
  and the mirrors under `vendor/` are upstream's.
- **Generated files:** `TODO.md`
- **Checks before merge:** `bash check.sh`
- **Credentials:** none. Nothing here needs one, and this repository is
  public.
- **Secrets checks:** none
- **State file format:** kit templates

## Project rules

- **Nothing the kit installs names a project, and nothing here names the
  owner's other projects.** A kit-owned file is installed into every
  repository, and this repository is public, so it names no project, person,
  account, host, address or credential. When a name leaks in, remove it and
  have the owner add it to the `AFK_PRIVATE_TERMS` repository secret, which
  `check.sh` reads in CI, so it cannot return. The list itself never enters
  the repository.
- **Every change to a kit-owned file is a release.** Bump `VERSION`, add a
  `CHANGELOG.md` entry, and keep `README.md` true, all in the same pull
  request. Keeping it true includes the slug in its update block, which names
  the new version with hyphens, such as `afk-update-1-1-0`. A change that alters what a repository must do after updating
  says so in its entry.
- **The kit-owned files are the source here.** There is no `MANIFEST` in this
  repository, and the rule that kit-owned files are never edited applies to
  the repositories that install them, not to this one.
- **This repository's session references name none of the owner's other
  projects.** It is public, and a reference is published when its task
  branch is pushed at close. Before the close commits a reference, it reads
  `AFK_PRIVATE_TERMS` from the environment and replaces each match in the
  reference with `[redacted]`. When the variable is not set, the close
  writes the reference naming no other project and says in its report that
  the terms were not checked. `check.sh` fails on any match left.
- **This repository never imports from other repositories.** It has no
  `REFERENCES.md` and never turns imports on. A file uploaded to a session
  here is copied under `.claude/imported/session-import/` only when it holds
  no term from `AFK_PRIVATE_TERMS`, read from the environment as the close
  reads it; one that holds a term, or that cannot be checked because the
  variable is not set, gets the placeholder instead, naming no other project.
  `check.sh` fails on any match under `.claude/imported/`.
- **`.claude/kit/kit.sh` stays.** It is not kit-owned and is never
  installed: a release before 2.0.0 updates by running it from this
  repository, and it hands the install to `.claude/afk/afk.sh`. Removing it
  strands every repository still on 1.x, so it goes only when MrFieldTech
  says none is left.
- **A skill stays generic by reading Session Settings.** A value that differs
  between repositories becomes a settings key, defined at the end of
  `HOUSE.md` and given a default in `.claude/afk/templates/CLAUDE.md`, never a
  literal in a skill.
