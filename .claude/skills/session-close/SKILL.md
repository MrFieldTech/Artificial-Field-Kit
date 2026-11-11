---
name: session-close
description: >-
  Close out a Claude Code session in a repository that uses Artificial Field Kit. For each task branch the session worked on, stops at a clean boundary, places every credential, updates the task's block in TASKS.md, looks back over a session that met friction, edits HANDOFF.md in place, writes the session reference, runs the repository's Regenerate commands, and pushes the branch. A failing Regenerate command or check is diagnosed before anything parks. A task that is DONE, DISMISSED or BLOCKED then merges into the integration branch by a pull request whose body carries evidence and a merge danger call, and GitHub deletes its branch; a task stopped partway stays parked on its branch. Merges the integration branch into the default branch only when the owner asks. Reports where to see each task's work. Runs only when the owner invokes /session-close.
disable-model-invocation: true
---

# Session Close

Leave the repository so a session with no memory of this one resumes from
committed files alone. Nothing is done until it is pushed. A handoff that
describes work sitting only in the working tree is worse than no handoff,
because the next session trusts it.

This skill names no value that differs between repositories. Each one is in the
`## Session Settings` section of `CLAUDE.md`, and `.claude/afk/HOUSE.md` holds
the rules this skill applies. Below, the owner, the authority file, the default
branch and the integration branch are what Session Settings says they are.

Every session works on task branches, `task/<task-slug>`. Close each task
branch this session worked on, one at a time, by steps 1 to 8. Most sessions
have one. Then do steps 9 to 11 once.

A temporary session, opened with `/session-open temp`, that opened no task
has nothing to close. Say so and stop. If something worth keeping is still
only in the conversation, offer to open a task for it first, as the temporary
session section of `session-open` says. A temporary session that opened tasks
closes each of their branches like any other.

## 1. Stop at a clean boundary

Do not begin new work. Finish only the file or step already in progress. If it
cannot be finished cleanly, leave it and record exactly where it stopped,
naming the file and the section.

Half-finished work described accurately is fine. Half-finished work described as
complete is the failure this skill exists to prevent.

## 2. Place every credential

Before anything is committed, account for every credential this session
produced, was given, or found sitting somewhere it should not be.

First confirm the repository's visibility through the session's GitHub
access. Then:

- **When the repository is confirmed private and the Credentials setting names
  a place or a rule,** such as a section of the authority file, follow it for
  each value. Where it sends a value to a file the repository does not
  commit, or to a store outside the repository, name that place in the
  handoff and never the value. Where it sends a value into a file the
  repository commits, `HANDOFF.md` included, encrypt the value by the method
  the setting names and commit only what the encryption prints. Check that
  the output does not contain the value before it is written anywhere.
- **When the repository is confirmed private and the setting is `kit
  standard`,** the method is `.claude/afk/credentials.md`: store each value
  in its `<slug>.secrets.md` with `python3 .claude/afk/secrets.py set`, or,
  when where it belongs is not settled, in this session's companion alone,
  by step 4, with a task opened to place it. Then run `python3 .claude/afk/secrets.py check`
  and each command under the Secrets checks setting, and commit nothing
  while one fails. With no `secrets-recipients.txt`, or no `age` tool the
  session can install, the next case applies.
- **Otherwise,** when the setting is `none`, or the repository is public, or its
  visibility cannot be confirmed, or a value bound for a committed file has no
  encryption method named or none this session's container can run, commit
  the value nowhere, `HANDOFF.md` included. Put it in the final report under
  its own heading, labelled with what it unlocks, and say plainly that the
  report is the only copy, so the owner can place it before the conversation
  ends. When a method was named but could not run, say why. With the setting
  `none`, say the repository has no method for keeping credentials and offer
  to set one up.

Every value this session produced, was given or changed is also copied into
its companion in step 4, by `.claude/afk/references.md`, wherever the rules
above commit it. Note each value the owner or anyone gave in plaintext in the
conversation, for step 11.

Never commit a value in plaintext. Never mask, truncate, or substitute a
reference where a value is recorded, in the report or in a file. Encrypting a
value by the setting's method is not masking it. A value that spans more than
one line, such as a private key or an encrypted block, is recorded whole in a
fenced code block of its own, exactly as it is: never joined onto one line,
wrapped, or re-indented, and never inside a table. Never leave a value only in
the conversation without saying so.

## 3. Update the task's block in TASKS.md

Keep the format the file already has: its frontmatter if it carries one, as the
State file format setting describes, and the named headings under Format below.
Set an `updated` field to today if there is one. Edit this task's block, and the
block of any task this session opened or changed, and nothing else. Another
session may be editing the rest.

Directly under the task's heading, above its other holder lines, add one for
this session, whatever the status below, with the UTC time now and the
developer `session-open` named, by Developers in `.claude/afk/HOUSE.md`:

```
DROPPED | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>
```

It drops the task, so the next developer to open it finds it free.

Set the status:

- `DONE` when the work is finished, or `DISMISSED` when it will not be done,
  with a `Dismissed:` line saying why. Move the block from Open Tasks to
  Closed Tasks and add a `Closed:` date. Move any question still open in the block to Open Questions in
  `HANDOFF.md`. The merge in step 8 is what makes it true, and if that merge
  does not happen, step 8 sets it back.
- `BLOCKED` when it needs something only the owner can supply, with the question
  written out and a `Blocked:` line naming what would unblock it. Say in the
  block what is already done, because with an integration branch that work
  merges into it.
- `ACTIVE` when it stopped partway. The block carries the exact stopping point
  and the next action, naming files and functions rather than intentions, and
  whatever context a fresh session needs to continue. `/session-open
  <task-slug>` resumes from exactly this.

## 4. Edit HANDOFF.md and write the session reference

First, when the session met friction, look back over it by the retrospective
in `.claude/afk/practices/retro.md`. Each proposal it keeps is a question for
Open Questions below.

Edit the file in place and never replace it, because another session may close
into it. Change only what this session produced or settled. Keep its format and
the named headings below, in this order, and add nothing else.

- **Purpose.** Unchanged between sessions.
- **Session Log.** Add one row for this task: the date, the developer as
  `<PREFIX> / <HANDLE>`, the task slug and where it ended, merged or parked,
  and the commit range of this session's work on its
  branch. Never the handoff commit's own hash or the pull request number, which
  do not exist when the row is written. When the owner asked in this session
  for the merge into the default branch, the row says the task went there too,
  and if step 9 cannot make that merge, its report says so. Add rows at the top
  and never remove one, because two closes that each only added a row merge
  cleanly, and one that also removed a row conflicts.
- **Blocked On.** Add, change or remove the row for any task this session
  blocked or unblocked.
- **Decisions Made.** Add the decisions taken this session that are recorded
  nowhere else, each with the developer who took it, the date, and its
  reasoning in one line. A decision that governs
  future work belongs in the authority file, or in `CLAUDE.md` when there is
  none, so move it there and note the move here. Mark a decision this session
  overturned as superseded rather than deleting it.
- **Open Questions.** Add direct questions, each answerable in a sentence,
  carrying the context needed to answer it without reading the rest of the
  file, and naming the developer who raised it, the date, and the task it
  concerns when there is one. Remove the ones this session answered, whoever
  raised them, since every developer is an owner. Each proposal from the retrospective is one of these
  questions, offering a task for it. A question that belongs to one file is a
  `TODO:` in that file, and is not repeated here.
- **Flagged As Unverified.** Add anything assumed, inferred, or believed but not
  checked, each with what would verify it, and remove what this session
  verified.

Never include anything a script generates, such as counts or coverage. Never
include the narrative of the session, restatements of the authority file or
`HOUSE.md`, or optimism such as "nearly finished". Where a task stopped belongs
in its block in `TASKS.md`, not here.

A `HANDOFF.md` that still holds a Credentials In Transit heading, from an
older kit or because the authority file requires one, keeps it and the
values in it. Add no value there unless the authority file sends it there.

Then write the session reference for this task branch, and its companion
when step 2 committed any value, by `.claude/afk/references.md`. Read that
file first. The reference is a new file: never edit one already committed.
It is done when every heading of the template is there, each holding facts
or `None.`, and every credential this session handled is under Credentials
by its label.

## 5. Regenerate derived files

Run each Regenerate command, in the order Session Settings gives. If any command
fails, find its cause by `.claude/afk/practices/diagnosing.md`. When the cause is
in this task's work and the fix fits in this session, fix it on the task
branch, commit, widen the Session Log row's commit range to include the fix,
and run the commands again. Otherwise record the exact command, the exact error
and what the diagnosis found under Flagged As Unverified, and continue. With
`Regenerate: none`, skip this step.

## 6. Make the handoff commit

Stage only `TASKS.md`, `HANDOFF.md`, the session reference and its companion,
and the paths under Generated files. Commit them together with a message beginning exactly `handoff: ` followed by a short
description of what moved.

No other commit may begin with that prefix.

## 7. Push the task branch

```
git push -u origin task/<slug>
```

If the push fails on the network, retry up to four times backing off 2, 4, 8
and 16 seconds, then stop and report the error. The branch is the only copy of
the work until it is pushed.

A task that is `ACTIVE` is now parked, and this is its last step. Confirm
`origin/task/<slug>` matches local `HEAD` and the working tree is clean, then go
on to the next task branch or to step 9.

## 8. Merge a finished task

A task that is `DONE`, `DISMISSED` or `BLOCKED` merges into the integration
branch. With `Integration branch: none`, a `DONE` or `DISMISSED` task merges
into the default branch and a
`BLOCKED` one parks, below, because its partial work would otherwise reach
production. Below, the target is the branch the task merges into.

A merge needs a pull request, so first confirm the session can open one,
through a GitHub connector or the `gh` command line. If it cannot, park the
task, below, write in its block that the merge waits only on a pull request,
and say so in the report. Change nothing on the remote but the task branch.

**Bring the base in.** When there is an integration branch and it does not
exist on the remote, GitHub deleted it after it merged into the default branch.
Create it again at the default branch's head, which adds no commit to it:

```
git push origin origin/<default branch>:refs/heads/<integration branch>
```

GitHub declines that push, as one that would publish a private email
address, when the owner keeps their address private and the default branch's
head is a merge made under it. Then create the branch through the session's
GitHub access instead, from the default branch, which publishes nothing new.

Then merge it into the task branch, and note the hash of `origin/<target>`
that this brings in, because step 9 compares against it:

```
git fetch origin
git merge --no-edit origin/<target>
git merge --no-edit origin/<default branch>
```

If a merge conflicts, apply the conflict rule in `.claude/afk/HOUSE.md`. The
paths under Generated files are never merged by hand: take either side, run the
Regenerate commands again, and stage what they write. Where both sides only
added lines to `TASKS.md` or `HANDOFF.md`, keep both, and where git
interleaved two whole task blocks, rebuild each whole by that rule. For
anything else, run
`git merge --abort` and park the task, below. Do not resolve a content conflict
unattended.

**Check the tree.** Run the Regenerate commands, then each command under Checks
before merge, then `git status --short`. If a check fails, find its cause by
`.claude/afk/practices/diagnosing.md`, fix it on the task branch, widen the
Session Log row's commit range to include the fix, and run the checks again.
Park the task only when the fix does not fit in this session, with the
diagnosis's stopping point in its block. If the Regenerate commands rewrote a
generated file, commit it. Push the task branch.

**Open and merge the pull request.** Through the session's GitHub access, open
a pull request from `task/<slug>` into the target, titled after the task, with
the body below. Wait for every check run GitHub reports on the pull request to
finish. A combined commit status that reads `pending` with no statuses behind
it means nothing posted one, not that something is still running.

**The pull request body.** The session merges its own pull request, so the body
is the review record: the one place a later reader sees what changed and why
it was safe to merge. Write three parts, briefly, in the words the repository
already uses. When the repository has a pull request template, fill it and
carry the three parts inside it.

- **Summary.** The task slug and what changed, shown as the smallest picture
  that makes it clear: a short file tree for files added or moved, a `diff`
  sketch of the shape that changed, pseudocode or a call tree for logic, or a
  Mermaid diagram for a flow between parts. Usually one, rarely two, and plain
  prose when none of them helps.
- **Evidence.** Before and after, from what this session ran: each check with
  its result, the red command failing and then passing when a diagnosis ran,
  and for a visible change a screenshot when the container has a browser, or
  the Task preview address when it is set. Claim only evidence the session
  produced, and say so when there is none.
- **Merge danger.** Whether the change is a two-way door, walked back by a
  revert, or a one-way door, such as deleted data, an address that is already
  published and now changes, a migration, or anything sent outside the
  repository. Then its blast radius in a word or two, such as layout, copy,
  redirects or build, with one line on what could break if it is wrong.

Checks can run for many minutes. Stay with the pull request until they
finish, reading them again about once a minute. When the session can schedule
a message back to itself, wait by a check-in a minute or two out, which ends
the turn, and carry on from here when it arrives. Never read the checks back
to back, and never set the check-in far out, which leaves the merge idle long
after the checks finish. Tell the owner nothing between readings unless a
check fails.

When the Task preview address is set, the host usually posts the branch's
preview address on the pull request once the branch builds. If it is not the
Task preview address with this slug in it, report the address the host gives and
record the difference under Flagged As Unverified.

- Every check passes: merge it with a merge commit, never a squash, so each step
  of the task stays in the history.
- GitHub reports it cannot be merged because the target moved: bring the base in
  again from the top of this step.
- A check fails: find its cause by `.claude/afk/practices/diagnosing.md`, fix
  it on the task branch, widen the Session Log row's commit range, update the
  body's evidence, and push, and the pull request re-runs. When the fix shows
  a guard the repository lacks, add the retrospective's proposal for it under
  Open Questions in `HANDOFF.md` in the same push. If it cannot be fixed in
  this session, close the pull request unmerged and park the task, with the
  diagnosis's stopping point in its block.

Never leave a pull request into the integration branch open at the end of a
session. GitHub retargets an open pull request at the default branch when it
deletes the branch that pull request was aimed at, which is what happens to the
integration branch after every merge into the default branch.

**Confirm the branch is gone.** GitHub deletes the task branch when its pull
request merges, when its Automatically delete head branches setting is on:

```
git fetch origin --prune
git ls-remote --heads origin task/<slug>
```

The second command prints nothing when the branch is gone. If it is still there,
report it for the owner to delete, and say on the `Branch:` line that
Automatically delete head branches is off and needs turning on.

When it is gone, leave the local branch, whose upstream no longer exists:

```
git checkout --detach origin/<target>
```

A cloud end-of-turn hook reads a branch with no upstream as unpushed work.
Never push it to answer the hook, which would recreate a merged branch.

**To park a task instead,** set a `DONE` or `DISMISSED` task back to `ACTIVE` and move its
block back to Open Tasks, or leave a `BLOCKED` task as it is. Write in the block
why the merge did not happen, naming the conflicting files or the failing check.
Commit, push, and report it as parked.

## 9. Merge into the default branch only when the owner asks

Merging the integration branch into the default branch is a separate decision,
and it is the owner's, not this skill's. With `Integration branch: none` there
is nothing to do here.

Do nothing here unless the owner asked for the merge in this session. A
promotion with no task to close needs no close: the owner asks for it in a
temporary session, which follows this step by the Temporary Session section
of `session-open`. Do not
infer it from the queue being empty, from the work looking finished, or from
time passing.

When they have asked, check all four before touching anything:

1. Every check passed on the code the integration branch holds. With no
   checks to wait for, that is already true when all three of these hold:
   - The integration branch's head is the merge commit of a task pull request
     this session merged in step 8, after all its checks passed.
   - That commit's first parent is the hash step 8 noted, so nothing else
     merged into the integration branch in between:
     `git rev-parse origin/<integration branch>^1`
   - The default branch holds nothing the integration branch lacks:
     `git merge-base --is-ancestor origin/<default branch> origin/<integration branch>`

   The pull request into the default branch then holds exactly the code those
   checks passed on, and running them again tests nothing new. Otherwise, wait
   for every check GitHub reports on the integration branch's head, as step 8
   waits.
2. The integration branch merges into the default branch with no conflict.
3. No task is `ACTIVE` in `TASKS.md` on the integration branch. A task branch
   merges only when its task is `DONE`, `DISMISSED` or `BLOCKED`, so this
   always holds unless
   something merged that should not have.
4. No pull request into the integration branch is open, through the
   session's GitHub access. Another developer's close may have one open and
   waiting on its checks, and GitHub retargets it at the default branch when
   the merge below deletes the integration branch.

If any check fails, name which one and stop. For check 4, name the open pull
request and its branch, so the owner can wait for it to merge. Do not merge to tidy the branch.

When all four pass:

1. Open the pull request from the integration branch into the default branch,
   titled after what it carries, with a body in the three parts step 8 gives:
   the summary lists each task closed since the last merge with its pull
   request, the evidence is the checks on the integration branch's head, and
   the merge danger is the riskiest door among those tasks, with the blast
   radius they share on the default branch.
2. Merge it with a merge commit: at once when check 1 held with no checks to
   wait for, otherwise once every check on the pull request passes, waiting as
   step 8 waits.
3. GitHub deletes the integration branch. That is expected. The default branch
   now holds everything it did, and the next task to merge creates it again.

Parked task branches are untouched by this merge and need nothing done to them.
Never push to the default branch directly, and never merge a pull request
someone else opened.

## 10. Check for strays

```
git fetch origin --prune
git branch -r
```

Anything besides `origin/HEAD`, the default branch, the integration branch, the
Other branches, and `origin/task/<slug>` for a task in `TASKS.md` is a stray.
Report each with the count of commits it holds that the default branch does
not. A session cannot delete a branch, so leave strays for the owner.

Another session's task branch whose task is `DONE`, `DISMISSED` or `BLOCKED`
on that branch but not on the integration branch is reported as
`session-open` step 3 reports it, never as parked or abandoned, and is not
offered for merging.

## 11. Report

Do not summarize the handoff. Reply with exactly these lines and nothing else,
as one fenced code block with no backticks inside it, giving one `Task:`,
`Branch:` and `Preview:` line to each task branch the session closed:

```
Task:    <task slug>, <DONE | DISMISSED | BLOCKED | ACTIVE>
Branch:  <merged into <target> by <pull request URL>, deleted by GitHub | merged into <target> by <pull request URL>, not deleted: turn on Automatically delete head branches | parked at <hash>>
Preview: <the Task preview address when parked | the Integration preview address when merged | none>
Commit:  <handoff commit hash>
Secrets: <none | where each value was placed | N in this report for the owner to place>
Reference: <the session reference's path>
Retro:   <none | N proposals under Open Questions in HANDOFF.md>
Parked:  <none | every parked task slug, which is what /session-open takes to resume>
Strays:  <none | branch names>
Merged:  <integration branch into default branch pull request URL, or not requested>
```

A value that could not be committed, by step 2, follows these lines under its
own heading, in a fenced code block of its own when it spans more than one
line. Each value given in plaintext in the conversation follows them too, by
its label, with the warning that the conversation still holds it and should
be erased once the value is placed. Both are the exceptions to "nothing
else".

A parked task's preview address serves the newest build of its branch. A
merged task's work is on the integration preview once the host has built the
merge, a few minutes after it.

---

## Format

`TASKS.md` and `HANDOFF.md` keep the format they already have. The State file
format setting names it: `kit templates` for the files in
`.claude/afk/templates/`, or a rule in the authority file, such as frontmatter
the repository requires. Either way the headings are these, named and never
numbered.

`HANDOFF.md`:

```markdown
# Session Handoff

## Purpose
## Session Log
## Blocked On
## Decisions Made
## Open Questions
## Flagged As Unverified
```

`TASKS.md`:

```markdown
# <Title>

## Purpose
## How Tasks Are Worked
## Open Tasks
### <Task Title>
## Closed Tasks
### <Task Title>
```

Each task heading is its title. Directly under it, the holder lines, newest
first, one per session that took or dropped the task, as Developers in
`.claude/afk/HOUSE.md` gives them, then:

```markdown
**Slug:** `<task-slug>`
**Status:** TODO | ACTIVE | BLOCKED | DONE | DISMISSED
**Opened:** <YYYY-MM-DD>
**Blocked:** <what would unblock it, only when BLOCKED>
**Closed:** <YYYY-MM-DD, only when DONE or DISMISSED>
**Dismissed:** <why the work will not be done, only when DISMISSED>
```

Then the detail block as prose. Task slugs are unique and permanent, and a task
is never renumbered because it carries no number. The slug is also the task's
branch name, `task/<task-slug>`.

Where a task stopped is written in its own block, never in `HANDOFF.md`.

Never use an em dash.
