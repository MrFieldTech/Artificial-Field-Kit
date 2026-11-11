# Retrospective

Look back over a session for what in the repository's environment made the
work slower or wrong, and propose changes to the environment rather than to
the code: what is checked automatically, where things are found, and what
the steering files say. The next session then starts from a better place.

`session-close` runs this before it edits `HANDOFF.md`, when the session met
friction. It also runs whenever the owner asks what went wrong, or what
would have prevented something, in any words.

## Friction

Any of these in the session being closed:

- A check, a Regenerate command or a build failed.
- A diagnosis ran, by `diagnosing.md`, or a task's block records a missing
  guard.
- The owner corrected the session, or a rule in `HOUSE.md`, `CLAUDE.md` or
  the authority file was broken.
- Something took many searches or reads to find.
- A command, path or fact the session needed was missing, or written down
  wrong.

With none of these there is nothing to look back on, and the retrospective
ends without a word.

## Where to look

Read the session and the state files, then look here, taking first what
would have changed the session most:

- **Automated checks.** A mistake a command could have caught. Read the
  repository's own checks first, its Checks before merge, its CI workflows
  and its package scripts, because a check that exists but never runs is the
  finding, not a missing one. A repository whose Checks before merge is
  `none` and whose CI runs nothing has no guardrail, and that is a finding
  in itself.
- **Rules that should be checks.** A rule with a fixed, searchable form,
  such as a banned character, a file that must not exist, or a pattern a
  file must not hold, belongs in a check rather than in prose. A check holds
  every time, and prose holds when it is remembered. Prose is for judgement.
- **Navigation.** What the session needed and could not find quickly: a
  pointer in `CLAUDE.md` naming where something lives, or a gotcha written
  where the next session will read it.
- **Steering files.** A line in `CLAUDE.md` or the authority file that
  changes nothing, repeats another file, or has gone stale. Every line there
  loads in every session. `writing-for-agents.md` holds the test.
- **Information access.** Something the session could not see that would
  have settled a question at once: a log, a preview, a read-only view of a
  service.
- **Tool economy.** A command that cost far more than its answer was worth,
  and a cheaper way to the same answer.

## What comes out

Proposals, most severe first, each one sentence on what to change and one
on what it would have prevented in this session. Each is a question that
offers a task for it, so the owner decides. At close, each becomes a direct
question under Open Questions in `HANDOFF.md`. Asked for during a session,
they are the reply's numbered questions, and `session-close` carries any
still unanswered into `HANDOFF.md`. The retrospective itself opens no task
and changes no other file.

A proposal to change a kit-owned file is a change for the kit's own
repository, and its question says so, because kit-owned files change only
by a kit update.

Adapted under the MIT License from a public collection of agent skills.
`NOTICE.md` in the kit's own repository holds its notice.
