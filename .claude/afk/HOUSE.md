# House Rules

These rules apply in every repository that uses Artificial Field Kit, AFK
for short, called the kit below. The kit installs this file, and the first
line of the repository's `CLAUDE.md` imports it. Never edit it inside a
project: a change goes to the kit and reaches the project by an update. The kit's own repository is the one place it is edited.

Every value that differs between repositories is in the `## Session Settings`
section of `CLAUDE.md`. The keys are defined at the end of this file.

Where these rules say "the owner", they mean the developer running the
session. Every developer is an owner: anyone who works the repository with
Claude Code and this kit, with push access to it. Any of them may answer any
question, promote the integration branch, take a kit update, and answer for a
stray. Developers below says how a session knows which one it is.

## Which file wins

When two sources disagree, the first of these wins:

1. The authority file, when Session Settings names one.
2. The rest of `CLAUDE.md`.
3. This file.
4. The `session-open` and `session-close` skills.
5. The practices in `.claude/afk/practices/`.

Read the authority file rather than working from memory of it. It is
versioned and it changes. A conflict between it and an instruction from the
owner is not resolved by picking one. Say so plainly and stop.

## Rules for every action

- Never invent a detail. Unknown information becomes
  `TODO: <the specific question that would fill it>`. A file that is forty
  percent TODO is correct output. A file that is fluent and wrong is a failure
  nobody catches until it matters.
- Never assume a file path, a command, a hostname or a setting. One that was
  not confirmed becomes a TODO asking for it.
- Never use an em dash.
- Work in pieces that end at a clean boundary. When output or context might
  run out, stop at a boundary and say exactly where to resume. Never continue
  past a boundary hoping it fits.
- A credential is never left only in the conversation and never written
  anywhere the Credentials setting does not send it. It is never committed in
  plaintext: a value committed to the repository is encrypted first, by the
  method the Credentials setting names. With `kit standard`, that is an age
  encrypted `<slug>.secrets.md` file, by `.claude/afk/credentials.md`. With no
  rule set, with no method named or none the container can run, or in a
  repository not confirmed private, it is committed nowhere: it goes in the
  reply for the owner to place, and the reply says it is the only copy. The
  one exception is an encrypted companion copied bit for bit under
  `.claude/imported/`, committed there only on the developer's explicit
  instruction, by Copies in `.claude/afk/references.md`.

## Sessions and branches

Every session starts with `/session-open` and ends with `/session-close`. If a
session begins without `/session-open`, ask the owner to run it before doing
any work. If context is running low and `/session-close` has not run, say so.

`/session-open temp` opens a temporary session instead, for questions about
the repository. It reads the state and answers, and it writes, commits and
pushes nothing and takes no branch, except that it merges the integration
branch into the default branch when the owner asks. When something from it is to be kept or
built, the session turns it into a task, with its own branch, and from then on
it is an ordinary session that ends with `/session-close`. A temporary session
that opened no task needs no close.

`/session-open import` imports the session references of the repositories
`REFERENCES.md` names, on a task of its own, `import-<yymmddhhmmss>`.
`/session-open backfill` writes the session reference the session it runs
in is missing, for everything it did that no reference covers, on a task of
its own, `backfill-<yymmddhhmmss>`, which closes itself. Run as the first thing in a new session, it asks which past closes
with no reference to write instead.

There are three kinds of branch, and no others.

| Branch | What it is |
|---|---|
| The default branch | Production. It moves only by a pull request from the integration branch, and only when the owner asks. |
| The integration branch | Where finished and blocked tasks collect. It moves only by pull requests from task branches. |
| `task/<task-slug>` | One per task in `TASKS.md`, named after the task's slug. Every session works on one, except a temporary session that has opened no task. |

Branches the Other branches setting names are left alone. Anything else is a
stray: a branch by any other name, or a `task/` branch whose slug is not a
task in `TASKS.md`. A branch the cloud harness assigns before any skill runs
is never pushed. The session works on its task branch instead.

- **One branch per task, not per session.** A task that takes three sessions
  is still one branch. A task branch on the remote means the task is taken, so
  sessions on different tasks can run at the same time.
- **Commit as you go and push the task branch after every commit.** Until it
  merges it holds the only copy of the work.
- **Never commit to the default branch or the integration branch directly,
  never force push anything, and never delete a branch.** GitHub's automatic
  deletion of merged branches removes task branches and the integration
  branch. Any other branch that should go is the owner's to delete.
- **At close, a task that is `DONE`, `DISMISSED` or `BLOCKED` merges into
  the integration branch** by a pull request the session opens and merges. A task stopped
  partway stays parked on its branch, with its stopping point in its block in
  `TASKS.md`, and `session-open` lists it at every open.
- **The integration branch merges into the default branch only when the owner
  asks,** by a pull request the session opens and merges, and only when every
  check has passed on the code it holds and nothing conflicts.

With `Integration branch: none` there are two kinds of branch. A task that is
`DONE` or `DISMISSED` merges into the default branch by pull request at
close, and a `BLOCKED` task parks like an `ACTIVE` one, because its partial work would
otherwise reach production.

**When a merge conflicts.** The paths under Generated files are never merged
by hand: take either side and run the Regenerate commands again. Where both
sides only added lines to `TASKS.md` or `HANDOFF.md`, keep both. When each
side added a whole task block, git may interleave the two around the lines
they share, such as `**Status:**` and `**Opened:**`: rebuild each block
whole, as its own side wrote it, one after the other, and check each against
the Format in `session-close`. Anything else stops the merge for the owner. Both sides are committed work, and picking one
loses the other.

## Developers

Several developers can work one repository at once, each in their own
sessions. A session names the developer running it as `<PREFIX> / <HANDLE>`,
in capitals, which `session-open` settles before it takes a task:

- **Handle.** The account behind the session's GitHub access. Developers who
  share one account are that account. When the access names no account, the
  session asks the developer for their GitHub handle, the one thing about
  them it asks, and with no answer the handle is `UNKNOWN`.
- **Prefix.** The Branch prefix from the developer's Claude Code settings, as
  it shows in the branch the harness checked out before the session began:
  the part before its first `/`, when that branch is not the default branch,
  the integration branch, an Other branch or a task branch. With none, the
  name is the handle alone and `/` is left out. The prefix is never added to
  a branch name.

**Holder lines.** Directly under each task's heading, newest first, a log of
who held the task:

```
DROPPED | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
HOLDING | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
```

`session-open` adds a `HOLDING` line when it takes a task, and
`session-close` adds a `DROPPED` line above it, whatever the task's status.
The holder words are never a task's status words, so a holder line is never
read as a status. Times are UTC. A task whose top holder line is `HOLDING`
for another developer
is held: they took it and have not closed it, whether they are working it now
or their session ended without a close. Any developer may take it over, but
only once told who holds it and since when, and only when they say so.

Decisions and open questions are recorded with the developer's name and the
date. Every open question is shown to every developer: whoever works the task
a question concerns, or asks about open questions, is given it, whoever raised
it.

## State files

`TASKS.md` is the work queue, and each task's block holds its specification
and, while it is open, where it stopped. `HANDOFF.md` holds what sits above any
one task: the session log, what is blocked, decisions, open questions, and
what is unverified. `session-close` writes both and `session-open` reads
both. Both are edited in place rather than replaced, because two sessions
may close into them.

**Session references** are the facts each session learned, one file per
task branch at every close, under `.claude/references/`, with the session's
credentials in a companion file. Another repository imports them by
`/session-open import`. `.claude/afk/references.md` holds the rules: read it
before writing one at close, before turning imports on, before an import,
and before a backfill.

**Copies** under `.claude/imported/` are the repository's own bit for bit
record of what it was given: each reference it imports, with its companion,
and every file a developer uploads to a session. A file that is not copied
gets a placeholder describing it. Read Copies in `.claude/afk/references.md`
whenever a developer uploads a file, and before an import.

When Generated files lists `TODO.md`, it holds every `TODO:` in the repository
as a question and is never edited by hand. Answer a question where it is asked
and run the sweep again.

## Practices

Five practices hold how recurring kinds of work are done. Each is a file in
`.claude/afk/practices/`, read in full when its case comes up. The session
reaches for it on its own, and the owner never has to name one.

- **Grilling**, `grilling.md`: when a new task's branch is claimed, and
  when the owner asks for a plan, a design or an idea to be stress-tested.
- **Diagnosing**, `diagnosing.md`: when something fails that should pass,
  such as a check, a build, a Regenerate command or a command the work
  relies on, when the owner reports something broken, wrong or slow, and
  for a task whose work is a fix.
- **Writing for agents**, `writing-for-agents.md`: before writing or editing
  a file an agent reads as instructions, such as `CLAUDE.md`, the authority
  file or a skill.
- **Questionnaire**, `questionnaire.md`: when answers must come from
  someone other than the owner, or from the owner in a sitting of their
  own, such as a task about to block on several questions.
- **Retrospective**, `retro.md`: at close when the session met friction,
  and when the owner asks what went wrong or what would have prevented it.

## Response format

These rules govern what goes back to the owner and how. They do not change
how much work is done. Read as many files, run as many checks, and verify as
thoroughly as the task needs. The output is short. The work is not.

### Do not narrate

- No preamble restating the request before starting.
- No running commentary on files being read, considered, or ruled out.
- No progress updates between tool calls unless a step fails.
- No closing summary of the summary and no sign off.
- Do not list every file touched. Name a file only when the change to it is
  something the owner needs to know.

### End every turn with two parts

1. A short plain description of what was done. Past tense, specific, no
   adjectives. Name what was added, moved, or changed. Target under 100 words
   unless the change list genuinely needs more.
2. A numbered list of questions the owner needs to answer.

If there are no questions, write `No questions` in place of the list.

Never bury a question in prose. Questions appear only in the numbered list.
One question per number. Write each question so it can be answered without
re-reading the turn, which means the context the question needs goes inside
the question, kept concise and to the point.

When a question has a small set of plausible answers, list them as lettered
options under the number so the owner can reply `1b, 2a`.

### Questions are not TODOs

They are different mechanisms and neither substitutes for the other.

- A `TODO: <specific question>` goes into a file whenever a detail is unknown
  or a path is unconfirmed.
- A numbered question is only for what blocks the next step or a decision only
  the owner can make.
- When TODOs are written into a file, do not also raise them as questions
  unless one blocks the work right now. Count them in part 1 instead, for
  example `wrote 4 TODOs in <file>`.

### What brevity never suppresses

Keep full detail, in prose, outside the two-part structure, for:

- Errors and failures. Full text, exact command, exact path.
- Anything destructive or irreversible, stated before it is done.
- Anything that looks like a credential sitting somewhere it should not be.
- A conflict between the authority file and an instruction. Say so plainly and
  stop.
- A direct request from the owner for explanation, reasoning, or more detail.
  Answer in full and ignore the length target.
- A requested artifact. A commit message, file contents, or a draft is the
  whole reply, unshortened and unsummarized.

### Stopping points and warnings

- A clean boundary and where to resume go in part 1, not in the question list.
  They state where work stopped. They are not a decision for the owner.
- If a session begins without `/session-open`, the request to run it is the
  entire reply. Do no work and do not append the two-part structure.
- A low-context warning is one line at the top of part 1. It does not become
  a question.
- Something only the owner can do, where there is no choice to make, is a
  line at the top of part 1 beginning `Action needed:`. It does not become a
  question.

## Session Settings keys

`CLAUDE.md` holds a `## Session Settings` section with one bullet per key, in
this order. `session-open` sets every value the first time it runs in a
repository and asks only about what it cannot settle. Change a value there,
never in a kit-owned file.

- **Owner.** The account that owns the repository. It does not limit who
  answers: every developer is an owner, by Developers above.
- **Authority file.** A file that overrides `CLAUDE.md`, this file and both
  skills, or `none`.
- **Default branch.** Production, usually `main`.
- **Integration branch.** Where finished and blocked tasks collect before the
  default branch, `preview` unless changed, or `none`.
- **Other branches.** Branches the protocol leaves alone and never reports as
  strays, such as a `gh-pages` deployment branch, or `none`.
- **Task preview address.** Where a task branch's build is served, with
  `<slug>` where the task slug goes, or `none`.
- **Integration preview address.** Where the integration branch's build is
  served, or `none`.
- **Task slug limit.** The longest a task slug may be. 23 unless a repository
  needs otherwise: Cloudflare Pages cuts a branch's preview address at 28
  characters, and `task-` takes five, so 23 keeps every address whole.
- **Reserved slugs.** Names a task slug may not take, or `none`. `temp`,
  `import` and `backfill` are never task slugs, whatever this setting says,
  because they open a temporary session, an import and a backfill, and
  only those take slugs of the form `import-<yymmddhhmmss>` and
  `backfill-<yymmddhhmmss>`.
- **Regenerate.** Commands that rewrite the generated files, run in the order
  given, or `none`.
- **Generated files.** The paths those commands write, or `none`.
- **Checks before merge.** Commands run before a task's pull request is
  opened, or `none`. Only commands the session's container can run. The pull
  request's own checks run as well.
- **Credentials.** Where a credential goes. `none`, the default, means
  nowhere in the repository. `kit standard` means age encrypted
  `<slug>.secrets.md` files, as `.claude/afk/credentials.md` describes, and
  switching to it runs the setup there. A repository that keeps credentials
  its own way, or whose build neither of the kit's decrypters serves, names
  its own place or rule instead, with the reason the kit standard does not
  serve. A place of its own inside the repository also names how a value is
  encrypted there: the tool, and the public key or recipient it encrypts
  to. Every secrets command, check and setup step in the kit applies only
  under `kit standard`. The key that decrypts is never in the repository or
  the session.
- **Secrets checks.** Commands that check this repository's own handling of
  credentials, beyond `secrets.py check`, one per check, or `none`. The
  setup in `.claude/afk/credentials.md` writes them, and `session-close`
  runs them under `kit standard`.
- **State file format.** The format `TASKS.md` and `HANDOFF.md` keep: `kit
  templates`, or a rule in the authority file.
