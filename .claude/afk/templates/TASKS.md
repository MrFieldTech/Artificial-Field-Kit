# Tasks

## Purpose

The work queue for this repository and the source of truth for what remains.
Each task's block holds its full specification, and an open task's block holds
exactly where it stopped. `session-close` writes this file and `session-open`
reads it. `.claude/afk/HOUSE.md` holds the rules.

## How Tasks Are Worked

Every task is worked on its own branch, `task/<task-slug>`, named after its
slug. `/session-open <task-slug>` resumes a task, or starts a new one when the
slug names no task. With no slug, `session-open` lists the parked task branches
and the queued tasks and asks what to work on. Open Tasks are in the order they
are to be worked. Sessions on different tasks can run at the same time.

At close, a finished or dismissed task merges by pull request and GitHub
deletes its branch.
A task stopped partway stays `ACTIVE` and parked on its branch.

Tasks carry a slug and never a number, so a task can be reordered, split, or
closed without disturbing any reference to it. Task slugs are unique and
permanent and name the task's branch.

| Marker | Meaning |
|---|---|
| `TODO` | Not started, and has no branch |
| `ACTIVE` | In progress on its branch, or parked there between sessions |
| `BLOCKED` | Cannot proceed, and its `Blocked:` line says what would unblock it. A task whose remaining work only the owner can do stays here rather than leaving the queue |
| `DONE` | Finished, merged, and moved to Closed Tasks |
| `DISMISSED` | Not to be done, with a `Dismissed:` line saying why, merged, and moved to Closed Tasks |

Each task's heading is its title. Directly under it are its holder lines,
newest first, which record who took the task and who dropped it, as
`.claude/afk/HOUSE.md` describes under Developers:

```markdown
DROPPED | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
HOLDING | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
```

Then:

```markdown
**Slug:** `<task-slug>`
**Status:** TODO | ACTIVE | BLOCKED | DONE | DISMISSED
**Opened:** <YYYY-MM-DD>
**Blocked:** <what would unblock it, only when BLOCKED>
**Closed:** <YYYY-MM-DD, only when DONE or DISMISSED>
**Dismissed:** <why the work will not be done, only when DISMISSED>
```

Then the detail block, as prose.

## Open Tasks

## Closed Tasks
