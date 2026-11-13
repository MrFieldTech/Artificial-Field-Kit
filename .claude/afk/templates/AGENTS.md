<!-- afk:pointer:start. Artificial Field Kit writes this block and every kit update rewrites it. Write this repository's own instructions below the end marker. -->
# Instructions For Any AI Coding Tool

This repository runs on Artificial Field Kit, a session protocol for AI
coding tools. Claude Code loads it from `CLAUDE.md` on its own. Any other
tool starts here.

## Read first

Before any work, and again whenever your context has been summarized or
cut short, read these in full, in this order, skipping one your tool has
already loaded:

1. `CLAUDE.md`. Named for Claude Code, written for every tool. It holds
   this repository's Session Settings and its own rules.
2. `.claude/afk/HOUSE.md`, the house rules. The first line of `CLAUDE.md`,
   `@.claude/afk/HOUSE.md`, is Claude Code's syntax for loading it; in
   any other tool, read the file it names.

The house rules govern every reply. Where they and this block disagree,
they win.

## The two commands

The owner starts every session with `/session-open` and ends it with
`/session-close`. Each is a skill: a Markdown file of steps.

- `/session-open <words>`: read `.claude/skills/session-open/SKILL.md` and
  follow it, with `<words>` as what follows the command.
- `/session-close`: read `.claude/skills/session-close/SKILL.md` and follow
  it.

Run either only when the owner asks for it. When your tool keeps `/` for
its own commands, the owner types them without it, as `session-open
<words>`, meaning the same. A skill file opens with a block between `---`
lines, settings for Claude Code that any other tool skips.

## Other skills and agents

Each folder in `.claude/skills/` holds a skill in `SKILL.md`. When a
skill's `description` fits the work, read it and follow it. The files in
`.claude/agents/` are in Claude Code's agent format and run only there.

## Words from Claude Code

The kit's files name a few Claude Code features. Where your tool has none,
the step that uses one says what to do without it.

- **Cloud session:** a session running in a hosted container that is
  discarded afterwards, so only what is pushed survives.
- **The branch the session started on:** the branch checked out before
  any skill ran. A cloud session is assigned one. It is never pushed.
- **Connector:** a tool the session has for a service such as GitHub. The
  `gh` command line serves the same purpose.
<!-- afk:pointer:end -->
