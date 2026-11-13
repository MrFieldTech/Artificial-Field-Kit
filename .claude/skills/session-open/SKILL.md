---
name: session-open
description: >-
  Start an AI coding session, in Claude Code or any other tool, in a repository that uses Artificial Field Kit. Takes an optional task slug: an existing task resumes on its branch, a slug that names no task starts a new task under that name, claimed on its branch at once and then settled by grilling, and with no slug it lists the parked task branches and queued tasks and asks. In a repository that has never used the kit, it proposes the Session Settings and builds TASKS.md and HANDOFF.md first. Names the developer running it from their GitHub account and Claude Code branch prefix, warns before taking a task another developer still holds, and records who took each task. Reads the authority file, CLAUDE.md, TASKS.md and HANDOFF.md, reports the kit's version and any stray branch, puts the session on the task's own branch, task/<task-slug>, and works the task from the stopping point in its block. With the argument temp it opens a temporary session instead: it reads and reports the same way, answers questions without taking a branch or writing anything, merges the integration branch into the default branch when the owner asks, and turns what is to be kept or built into tasks when the owner asks. With the argument import it imports the session references of the repositories REFERENCES.md names, on a task of its own. With the argument backfill it writes the session reference the session it runs in is missing, or in a brand new session asks which past closes with no reference to write, on a task of its own that closes itself. Runs only when the owner invokes /session-open.
disable-model-invocation: true
---

# Session Open

Resume from committed files alone. The owner supplies at most the slug of the
task they want, after `/session-open` or in their message: no hash, no branch
name, no summary of last time. Everything needed is in the repository, and if
it is not in the repository it did not survive, which is a `session-close`
failure to report rather than a gap to fill by guessing.

This skill names no value that differs between repositories. Each one is in the
`## Session Settings` section of `CLAUDE.md`, and `.claude/afk/HOUSE.md` holds
the rules this skill applies. Below, the owner, the authority file, the default
branch and the integration branch are what Session Settings says they are.

Every session works on the branch of one task, `task/<task-slug>`. Run these
steps in order. Do not skip ahead to the work. The exceptions are
`/session-open temp`, which opens a temporary session by Temporary Session,
`/session-open import`, which imports by Import, and `/session-open
backfill`, which writes a missing reference by Backfill, all at the end of
this file.

## 1. Find the developer and fetch everything

Before anything checks out another branch, note the branch the session
started on, with `git rev-parse --abbrev-ref HEAD`. Then name the developer
running the session, `<PREFIX> / <HANDLE>`, by Developers in
`.claude/afk/HOUSE.md`: the handle from the account behind the session's
GitHub access, and the prefix from the branch just noted. Ask for the handle
only when the GitHub access names no account.

```
git fetch origin "+refs/heads/*:refs/remotes/origin/*" --prune
```

If `git rev-parse --is-shallow-repository` prints `true`, also run
`git fetch --unshallow origin`. A shallow clone hides the history the later
steps compare against.

## 2. Find the base and read state

**First, is this the kit's first run here?** It is when `CLAUDE.md` has no
`## Session Settings` section and no branch on the remote carries a `TASKS.md`
holding a `**Slug:**` line. Check each remote branch with
`git grep -l '^\*\*Slug:\*\*' origin/<branch> -- TASKS.md`. If it is the first
run, follow First Run at the end of this file and then come back to step 3.

A task branch carrying `TASKS.md` while the default branch does not is a first
task that has not merged yet. That is not a first run. Read the settings and
state files from that branch in place of the base below, and run the kit check
at the end of this step after step 5, because until that task merges the kit
is only on its branch.

**The base** is `origin/<integration branch>` when it exists. When it does not,
GitHub deleted it after it merged into the default branch, which is the normal
end of a round, and the base is `origin/<default branch>`. With
`Integration branch: none`, the base is always the default branch. Do not
create the integration branch here. The first task to merge creates it.

```
git checkout --detach <base>
```

Read, in this order, as they exist on the base:

1. The authority file, when Session Settings names one. It overrides everything,
   including this file.
2. `CLAUDE.md`, and `.claude/afk/HOUSE.md`, which it imports.
3. `TASKS.md`
4. `HANDOFF.md`

**If the skill on disk is newer than the one loaded.** A session whose
checkout was older than the base loaded the older `session-open` when it
started. When `.claude/skills/session-open/SKILL.md` on disk now differs
from the text this session is following, read the file on disk and follow
it from step 2, and do the same for `session-close` at close. A session
with no kit in its checkout never loaded the skill at all; the Backfill
recovery prompt in the kit's `README.md` brings it here.

Read `HANDOFF.md` in full. Flagged As Unverified names facts that look settled
and are not, and acting on one of them is how a wrong fact gets written down
and stops being questioned.

**Then check the kit:**

```
bash .claude/afk/afk.sh status
```

It prints the `Kit:` line for step 6: the installed version, whether the kit's
source has a newer one, and any kit-owned file edited in place. When it
reports a newer release, say in part 1 of the reply that the owner takes it
with the update prompt in the kit's README. Never update the kit here. An
update is the owner's call, made on a task branch in its own commit with
`bash .claude/afk/afk.sh update`. A kit-owned file edited in place is
reported and not reverted, because the edit may be the only copy of a fix
that belongs in the kit.

## 3. Survey the branches

```
git branch -r
```

Sort every remote branch except `origin/HEAD`:

- `origin/<default branch>`, `origin/<integration branch>`, and every branch
  the Other branches setting names are expected.
- `origin/task/<slug>` is a task branch when `<slug>` is a task in `TASKS.md`,
  on the base or on that branch. It is parked, or another session is working it
  right now, and the two look the same from here. Read its task's status and
  stopping point from the branch itself, with
  `git show origin/task/<slug>:TASKS.md`.
- A task branch whose task is `DONE` or `DISMISSED` on the base should have been deleted by
  GitHub when its pull request merged. Report it for the owner to delete and
  carry on.
- A task branch whose task is `DONE`, `DISMISSED` or `BLOCKED` on the branch
  but not on the base is a close that has not merged: its session may be
  between its handoff commit and its merge right now, or may have stopped
  there. Report it as `<status> on its branch, not merged, its close may
  still be running`, with its top holder line. Never offer to merge it. Its
  pull request belongs to its own session, or to the developer who takes
  the task over.
- Anything else is a stray: a branch by any other name, including one a
  session's tool checked out for an earlier session, such as a Claude Code
  cloud session's assigned branch, or a `task/` branch with no task
  behind it.

For each stray, report the branch name, the number of commits it has that the
default branch does not, and the files it adds:

```
git log --oneline origin/<default branch>..<branch> | wc -l
git diff --name-status origin/<default branch> <branch> | grep '^A'
```

When there is an integration branch, list the open pull requests into it
through whatever GitHub access the session has, a GitHub connector or the `gh`
command line. There should be none. One left open means a session ended
between opening and merging it, and GitHub would aim it at the default branch
the next time the integration branch is deleted, so report it with the strays.
With no GitHub access, say so on the `Strays:` line.

Report strays and stop until the owner answers. Do not merge them, do not
delete them, and do not start work with the report unread. A stray is the one
failure mode that loses finished work permanently. Two exceptions carry on
without stopping, reported on the `Strays:` line: a stray holding no commit the
default branch lacks, because nothing on it can be lost, and a branch the
owner already answered for in this session's First Run.

## 4. Choose the task

If the owner named `temp`, with or without `task/` in front, stop following
these steps here and follow Temporary Session at the end of this file. If they
named `import`, follow Import, and if `backfill`, follow Backfill, both at
the end of this file.

The owner names a task by its slug, after `/session-open` or in their message,
with or without `task/` in front: `/session-open footer-rebuild` and
`/session-open task/footer-rebuild` mean the same. Take the first case that
applies.

**a. They named a task that has a branch.** Resume it.

**b. They named a task in `TASKS.md` that has no branch.** Start its branch. If
the task is `DONE` or `DISMISSED`, ask whether to reopen it or to open a new task under
another slug, and stop until they answer.

**c. They named a slug that is no task.** Open a new task under that slug.
If the slug breaks the rule below, propose one that keeps it and stop until
they answer, because a claimed slug is permanent. Step 5 claims it and writes
its block under Open Tasks in `TASKS.md`: a title, the slug, status
`ACTIVE`, today's date, and a detail block recording what they asked for.
Step 6 then settles it by grilling before any other work.

**d. They named nothing but asked for new work.** First look for an open
task that already covers it: each task branch, and each task under Open
Tasks. Offer each match as a lettered option beside a new task, and stop
until they answer. A match they choose is case a or b. With no match, or
when they choose a new task, open one as case c under a slug the session
chooses, keeping the rule below, and name the slug in the first round of
grilling. The slug is a label, so it is not asked first.

**e. They named nothing and asked for nothing.** List every task branch with
its task's title, status, top holder line, stopping point and preview
address when there is one, then every task under Open Tasks that has no branch and is not `BLOCKED`,
and ask whether to resume one, start one, or start something new. With nothing
to list, say so and ask what the new task is. Do not invent work. Stop until
they answer.

A task slug is lowercase letters, digits and hyphens, no longer than the Task
slug limit, unique among tasks, none of the Reserved slugs, never `temp`,
`import` or `backfill`, and of the form `import-<yymmddhhmmss>` or
`backfill-<yymmddhhmmss>` only when Import or Backfill opens it.

A task branch the owner did not name or choose is never taken. A parked branch
and one another session is working look the same, and two sessions on one task
is the collision the task branches exist to prevent.

**A held task.** Read the top holder line of the chosen task's block, on its
branch when it has one. When it is `HOLDING` for another developer, the task
is held: say who holds it and since when, that they may be working it right now
or may have ended their session without a close, and stop until the owner
says to take it over. When they do not, go back to this step without it.

## 5. Get onto the task branch

**If `origin/task/<slug>` exists, resume it:**

```
git checkout -B task/<slug> origin/task/<slug>
git merge --no-edit <base>
git merge --no-edit origin/<default branch>
```

The last merge is a no-op in the usual case and it is cheap. It matters when the
default branch carries a merge that the integration branch does not.

Add the holder line below, commit, and push.

**If it does not exist, create it and claim it:**

```
git checkout -B task/<slug> <base>
git merge --no-edit origin/<default branch>
```

Set the task's status to `ACTIVE` in its block, or add the block for cases c
and d, add the holder line below, commit, and push at once:

```
git push -u origin task/<slug>
```

**The holder line.** Directly under the task's heading, above any holder
lines already there, add one for this session, with the UTC time now:

```
HOLDING | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
```

The pushed branch is the claim, and the holder line says whose it is. A
session opening after this one sees the task as taken. If the push is rejected because the branch now exists, another
session claimed the task first: tell the owner and go back to step 4 without
it.

**If a merge conflicts,** apply the conflict rule in `.claude/afk/HOUSE.md`.
The paths under Generated files are never merged by hand: take either side,
run the Regenerate commands, and stage what they write. Where both sides only
added lines to `TASKS.md` or `HANDOFF.md`, keep both, and where git
interleaved two whole task blocks, rebuild each whole by that rule. For
anything else, run
`git merge --abort`, report the conflicting file names, and stop until the
owner answers. Do not resolve a content conflict unattended. Both sides are
committed work and picking one loses the other.

Never create a branch by any other name, never commit to the default branch or
the integration branch, and never push the branch the session started on.

If a merge in this step changed any file under `.claude/skills/` or
`.claude/afk/`, re-read `.claude/skills/session-open/SKILL.md` and follow the
version now on disk from step 6. If it changed the authority file, `CLAUDE.md`
or `HANDOFF.md`, read them again.

## 6. Report, then work

Report exactly these lines, as one fenced code block with no backticks inside
it, then continue without waiting for a reply:

```
Task:     <task slug>, <resumed | started from the queue | new>
Branch:   task/<slug> <resumed at <hash> | created from <the base branch's name>>
Preview:  <the Task preview address with the slug in it | none>
Base:     <origin/<integration branch> at <hash> | origin/<default branch> at <hash>, <integration branch> absent>
Kit:      <the line afk.sh status printed>
Holder:   <the holder line this session added>
Parked:   <none | the other task branches, each with its task's status and top holder line>
Strays:   <none | branch names and any open pull request into the integration branch>
Questions: <none | each open question in HANDOFF.md that concerns this task, then N others>
Next:     <the stopping point in the task's block, or its first step>
```

With `Integration branch: none`, the `Base:` line names the default branch
alone. With the handle `UNKNOWN`, the `Holder:` line says the GitHub access
named no account and the owner gave no handle. The `Questions:` line takes
each question under Open Questions in `HANDOFF.md` that names this task, its
files or a decision its block leaves open, in a word or two each, and counts
the rest. Every one of them is shown in full whenever the owner asks about
open questions, whoever raised it. A preview address serves the newest build of the task branch. For a
branch created in this step, the host builds it from the push that claimed it,
so the address works a few minutes later; say so on the `Preview:` line.

A task this session opened by case c or d is settled first by grilling,
`.claude/afk/practices/grilling.md`, on its claimed branch: each round is
written into its block and pushed before it is asked, and each answer
becomes a decision there. Done when the frontier is empty.

Then work the task from its stopping point. Follow its detail block. Do not
re-plan a task the block already specifies and do not ask the owner to
re-confirm anything recorded under Decisions Made. When the block leaves open
a decision the next step depends on, settle it first by grilling,
`.claude/afk/practices/grilling.md`, and record the answer in the block.

## While working

Commit as you go and push the task branch after every commit. Until it merges,
it holds the only copy of the work, and the container a cloud session runs in
does not outlive the session. Where the repository builds previews, every push
also rebuilds the task's own.

Never commit to the default branch or the integration branch, never create a
branch other than a task's, and never force push.

A session can work more than one task, one at a time. Before switching, write
the current task's stopping point into its block, commit, and push its branch,
then take the next task by steps 4 and 5. `session-close` closes every task
branch the session worked on.

If a task turns out to be blocked on a decision only the owner can make, mark
it `BLOCKED` in its block with the question written out, add the question under
the Open Questions heading in `HANDOFF.md`, and tell the owner. They decide
whether to close it now or to switch to another task first.

When it is blocked instead on answers someone other than the owner must
give, or on more than a couple the owner needs time to find, gather them by
a questionnaire, `.claude/afk/practices/questionnaire.md`, and mark it
`BLOCKED` the same way, its `Blocked:` line naming the questionnaire.

If a credential is produced or discovered, place it before it is forgotten, by
the Credentials setting and the credential rule in `.claude/afk/HOUSE.md`. Do
not leave it only in the conversation without saying so.

Never use an em dash.

## Temporary Session

For questions about the repository, its state and its details, where nothing
is to be built yet. It ran steps 1 to 3 like any session, so its answers come
from the committed state and not from memory, with two differences: in a
repository new to the kit it does not run First Run, and says so, and a stray
does not stop it, because it changes nothing, though every stray is reported.

**It stays read-only.** It stays detached on the base, takes no branch, and
writes, commits and pushes nothing. A file uploaded to it is kept only if it
opens a task, by Copies in `.claude/afk/references.md`. It never pushes the branch the session
started on. The one exception is a promotion the owner asks for, below. Report these lines, as one fenced code block with no
backticks inside it, then answer what the owner asked:

```
Task:     none, temporary session
Branch:   none, detached at <the base branch's name> <hash>
Base:     <as in step 6>
Kit:      <the line afk.sh status printed>
Parked:   <none | the task branches, each with its task's status and top holder line>
Strays:   <none | as in step 6>
Questions: <none | the number of open questions in HANDOFF.md>
```

**Promoting the integration branch.** The owner may ask, in any words, for
the integration branch to merge into the default branch. That is not a
keyword: work out from the conversation whether it is what they mean, and ask
when it is not clear. Then read step 9 of `.claude/skills/session-close/SKILL.md`
and follow it, with these differences:

- With `Integration branch: none`, or when the integration branch is absent
  or holds nothing the default branch lacks, there is nothing to promote. Say
  so and stop.
- Check 1 never holds without waiting, because this session merged nothing
  into the integration branch. Wait for every check GitHub reports on its
  head, as `session-close` step 8 waits. If its head moves while waiting,
  wait again on the new head.
- An open pull request into the integration branch stops the promotion, named
  in the reply. GitHub deletes the integration branch after the merge and
  retargets that pull request at the default branch.
- On a conflict, name the conflicting files and stop. A commit reached the
  default branch outside the protocol. Offer a task to resolve it: its branch
  comes from the integration branch and merges the default branch in, the
  owner's answers go in its block, and its close merges it into the
  integration branch, after which the promotion can be asked for again.
- It records nothing in the repository. The pull request into the default
  branch and its merge commit are the record.

The session stays temporary afterwards and needs no close for the promotion.

**Watch for what is worth keeping.** A decision the owner makes, a fact the
session confirms that the state files lack, a request to change or build
something, a question left open. None of it survives the session unless it
reaches a task's block. When one comes up, offer to keep it, as a numbered
question in the reply, and say which way the session proposes:

- **Turn this session into a task,** when the conversation has been about one
  thing and the owner wants it built or recorded now.
- **Open a task for later,** one per topic, when the conversation covered
  several, or when the owner wants the work queued rather than started. Offer
  as many as there are topics worth keeping, each with its proposed slug and
  title.

The owner may also ask for either at any time without an offer.

**Turning it into a task.** Each task takes its slug from the owner. If they
named none, propose one that keeps the slug rule in step 4 and ask. Then open
it by step 4 case c and claim it by step 5: a new branch from the base, the
task's block under Open Tasks in `TASKS.md`, committed and pushed at once. The
block records, beyond what case c asks:

- why the task was made and what it is for;
- the background from this session that a later session needs to start
  without it: what was asked, what was looked at and found, and what the
  session said, in as much detail as the work needs;
- each decision the owner made, with their name and the date, and each
  question left open, written out.

A task the owner wants built now is worked from here like any other: report
step 6's lines and start. A task opened for later is grilled only as far as
its block needs to say why it exists and what it is for. The decisions it
leaves open are written out in its block, for step 6 to settle when a session
starts it. It stays `ACTIVE` with its stopping point `Not started.` and its
first step, and the session checks the base out again, detached, before the
next one. From the moment it opens its first task, it is an ordinary session:
it ends with `/session-close`, which closes every task branch it opened.

A temporary session that opened no task needs no `/session-close`. If context
runs low while something worth keeping is still only in the conversation, say
so on the low-context line and offer to open its task before anything else.

## Import

For `/session-open import`. It ran steps 1 to 3 like any session, and a
stray stops it there, because it opens a task. In a repository new to the
kit it does not run First Run: say so and stop. Read
`.claude/afk/references.md` before anything below; it holds the rules for
each step.

1. **Turned on?** Read `REFERENCES.md` on the base. With none, say imports
   are not turned on, offer the setup in `.claude/afk/references.md` as a
   numbered question, and stop. Nothing is written.
2. **One at a time.** When a `task/import-<yymmddhhmmss>` branch exists on
   the remote, `import-` and twelve digits and nothing else, follow One at
   a time in `.claude/afk/references.md` and stop until the developer
   answers. Nothing is written.
3. **Attach each source** under Sources, read-only, through the session's
   GitHub access, and clone it outside the repository. Where the tool keeps
   a list of the session's repositories, as a Claude Code cloud session
   does, attach it with read access only, never registering it in that
   list, so its `CLAUDE.md` and skills never load. Fetch the
   branch its row names. A source that cannot be reached is reported, and
   its row is left as it is.
4. **List what is new** in each source by What is new in
   `.claude/afk/references.md`. Done when every reachable source has its
   list, empty or not.
5. **Report** these lines, as one fenced code block with no backticks
   inside it:

   ```
   Task:     <none, nothing to import | import-<yymmddhhmmss>, new>
   Base:     <as in step 6>
   Kit:      <the line afk.sh status printed>
   Parked:   <as in step 6>
   Strays:   <as in step 6>
   Sources:  <each source, with its count of new references or unreachable>
   ```

   With nothing new in any source, stop here. Nothing is written and no
   branch is taken.
6. **Open the task** `import-<yymmddhhmmss>`, the time in UTC now, by step 4
   case c with no grilling: its block lists each source and each new
   reference, oldest first, each `not imported`, and the Import procedure
   `REFERENCES.md` names. Claim it by step 5.
7. **Import** each reference by The import in `.claude/afk/references.md`,
   by the Import procedure `REFERENCES.md` names, the kit default first
   settling every subject's home by its Homes step, one commit per reference
   holding the import, its copies by Copies, its source's row in
   `REFERENCES.md`, and the reference marked `imported` or `omitted` in the
   task's block, pushed after each. Done when every listed reference is
   `imported` or `omitted`, or the task parks or blocks on a question by
   the usual rules.

It then ends with `/session-close`, like any task.

## Backfill

For `/session-open backfill`. It ran steps 1 to 3 like any session, and a
stray stops it there. In a repository new to the kit it does not run First
Run: say so and stop. Read Backfilling in `.claude/afk/references.md`
before anything below.

1. **One at a time, for past closes only.** A backfill in a session that
   has done something covers only that session's work, which no other
   backfill can cover, so it skips this step and any number can run at
   once. Run first in a brand new session, it lists past closes another
   backfill may be writing: when a `task/backfill-<yymmddhhmmss>` branch
   exists on the remote, `backfill-` and twelve digits and nothing else,
   name its task and the developer in its top holder line, offer to take it
   over, and stop until the developer answers.
2. **List what this backfill writes,** by What a backfill covers. In a
   session that has done something before `/session-open backfill`, that
   is one reference for everything the session did that no reference
   covers, whether or not it ran a kit close, and before the kit was
   installed as much as after. With nothing uncovered, say so and stop. In
   a brand new session, list the past closes with no reference, by Past
   closes, numbered, oldest first, with their count, and ask which to
   write: all, the numbers the developer names, or none. With none listed,
   or none chosen, say so and stop. Nothing is written and no branch is
   taken.
3. **Open the task** `backfill-<yymmddhhmmss>`, the time in UTC now, by
   step 4 case c with no grilling: its block lists each reference to write
   by its name, from Its name, and what it covers, the session's own work
   or a past close by its `handoff:` commit, oldest first, each `not
   written`. Claim it by step 5 and report step 6's lines.
4. **Write each reference** by Backfilling: from this conversation for what
   it did, otherwise from the repository. One commit per reference, with
   its entry marked `written` in the task's block, pushed after each. Done
   when every entry is `written`.
5. **Close** by `session-close`, steps 1 to 11, with no `/session-close`.

## First Run

For a repository that has never used the kit. `afk.sh install` has written the
kit-owned files into the working tree and nothing is committed yet. If
`.claude/afk/afk.sh` is not there, stop and ask the owner to install the kit
first, by the command in the kit's README.

1. **Find the default branch.** `git symbolic-ref --short refs/remotes/origin/HEAD`
   prints it after `origin/`, and the `HEAD branch:` line of
   `git remote show origin` names it when that ref is missing. A repository
   with no commits at all has none, and the last paragraph of this section
   covers it.

2. **Read the repository and settle a value for every Session Settings key.**
   The keys and what each means are at the end of `.claude/afk/HOUSE.md`. Look
   at:
   - `.github/workflows/` and any other CI configuration, for the checks that
     run on a pull request and the commands behind them.
   - The package manifest and build files, such as `package.json`,
     `pyproject.toml` or a `Makefile`, for build, test and lint commands.
   - Any existing `CLAUDE.md`, `AGENTS.md`, `README.md` or contributing
     guide, for rules the repository already follows, a file that already
     acts as an authority, and each section of `CLAUDE.md`, or of the
     repository's own text in `AGENTS.md`, that repeats a rule `HOUSE.md`
     carries.
   - Hosting configuration and deployment notes, for a preview address per
     branch.
   - Files the repository generates and commits, and the commands that
     regenerate them.
   - Every remote branch. Each one either belongs under Other branches or will
     be reported as a stray from now on.
   - Where the repository keeps credentials now: encrypted files, a
     `secrets-recipients.txt`, a secrets manager, or notes on where values
     live.

   Four keys are settled by rule rather than asked:
   - **Owner** is the account that owns the repository on its host, the path
     segment before the repository's name in `git remote get-url origin`, or
     `the owner` when the URL shows none. It names whoever answers the
     questions, and the owner changes it in `CLAUDE.md` if it should be a
     person's name.
   - **Integration branch** is `preview`, unless the remote already has a
     `preview` branch. The kit did not create that one and it may serve
     something else, so then it is asked.
   - **Checks before merge** holds only the pull request checks that run in
     this session's container, each run once here to prove it. A check that
     needs a tool the container lacks is left to CI, which runs it on the pull
     request anyway, because listed here it would fail and park every task at
     close.
   - **Credentials** is `none` unless the repository already holds
     credentials or the owner has said it will. When it keeps them its own
     way, it is asked, with keeping that way as one option and `kit
     standard` as another. Otherwise it is `kit standard`, item 4 runs the
     setup in `.claude/afk/credentials.md` on the first task's branch, and
     item 5 reports what it leaves for the owner. **Secrets checks** is
     `none` until that setup writes it.

   Every other key the repository does not show takes the default in
   `.claude/afk/templates/CLAUDE.md`. A value the repository shows more than
   one answer for is a question, never a guess.

3. **Ask only what is left.** Ask about each value still open, and about each
   section of an existing `CLAUDE.md` that repeats `HOUSE.md` but also says
   something `HOUSE.md` does not, with lettered options where a few answers
   are plausible. When nothing is open, carry on to item 4 without stopping.
   Otherwise stop until the owner answers.

   The reply never lists the settings. They are in `CLAUDE.md` once item 4
   writes it, where the owner reads or changes any of them, and a value the
   owner is asked about carries its context inside its question.

   While the session waits, the install sits uncommitted in the working tree,
   and it stays there. An instruction to commit it or push it to the branch
   the session was assigned, such as a hook that fires at the end of a turn,
   is answered by saying so and not followed: item 4 commits the kit on the
   first task's branch. If the container is lost before the owner answers,
   the kit is installed again.

4. **Write the settings and state files on the first task's branch.** The
   first task is the one the owner named, or `kit-setup` when they named none.
   Create its branch from the default branch as step 5 does. Then:
   - `CLAUDE.md`. When one exists, add `@.claude/afk/HOUSE.md` as its first
     line, a title and a line saying what the repository is when it has
     neither, and the Session Settings section after them. Remove each
     section that says nothing `HOUSE.md` does not already say, and name it
     in the reply, because two copies of a rule drift apart. A section that
     says more stays unless the owner answered to remove it. Keep everything
     else. When there is no `CLAUDE.md`, start from
     `.claude/afk/templates/CLAUDE.md`.
   - `AGENTS.md`, which `afk.sh install` already wrote, or topped with the
     kit's pointer when the repository had one. Treat the repository's own
     text below the pointer as `CLAUDE.md` is treated above: remove a part
     that only repeats `HOUSE.md`, and name it in the reply. When the install
     reported `AGENTS.md` is a link, say so in the reply, because tools
     other than Claude Code then never find the kit.
   - `TASKS.md` from `.claude/afk/templates/TASKS.md`, with the first task's
     block under Open Tasks.
   - `HANDOFF.md` from `.claude/afk/templates/HANDOFF.md`.
   - Whatever the Regenerate commands write, by running them.
   - The kit's paths, in any list of the repository's files that a
     `README.md` or contributing guide keeps.

   A `TASKS.md`, `HANDOFF.md` or generated file that already exists and was
   not written by the kit is never overwritten unasked. Show it, and ask
   whether to fold it into the kit's format or to move it aside.

   Commit all of it together with the kit-owned files, including
   `.claude/afk/MANIFEST`, and push the branch at once. That push is the claim.

5. **Tell the owner what only they can set,** as notices at the top of part 1
   of the reply, each on its own line beginning `Action needed:`. They are
   not questions, because the workflow needs them and there is no choice to
   make:
   - Turn on Automatically delete head branches, under the repository's
     Settings, General, Pull Requests, if it is not on. Without it, merged
     task branches and the integration branch pile up, because a session
     cannot delete a branch.
   - When there is a preview host, add `task/*` and the integration branch to
     its list of branches that build previews.
   - When Credentials is `kit standard`, whatever the setup in
     `.claude/afk/credentials.md`, Setting it up, leaves for the owner, such
     as making the keys.
   - When the repository is public, turn on secret scanning with push
     protection, under its Settings, Advanced Security. Every close pushes a
     session reference, and push protection refuses a push that holds a
     credential in a format GitHub knows.

   Then ask, as numbered questions, about each rule in the repository's own
   files that contradicts `HOUSE.md`, such as a release process that pushes
   straight to the default branch. Leave the file as it is until the owner
   answers, and offer three options: change the file to match the kit, keep
   the rule as a project rule in `CLAUDE.md`, which then wins over
   `HOUSE.md`, or leave both as they are.

Then carry on from step 3. At step 4 the task is the first task, already on
its own branch, so step 5 has nothing left to do for it.

A repository with no commits at all has no default branch, and a pull request
needs a base. Create the default branch with a single commit holding only a
`README.md` that says what the repository is, push it, and carry on from item
2. It is the one commit the protocol makes directly on the default branch, and
the report says so.
