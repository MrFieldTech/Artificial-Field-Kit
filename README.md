# Artificial Field Kit

Artificial Field Kit, AFK for short, was named Claude-Kit before 2.0.0.

A session protocol and a set of house rules for Claude Code, installed into
each repository that uses them as a pinned copy.

Each session in a repository that uses the kit opens with `/session-open` and
closes with `/session-close`. A session resumes from committed files alone.
Each task is worked on its own branch, so sessions on different tasks can run
at the same time. A task stopped partway is parked on its branch until a later
session picks it up by name.

Several developers can share a repository, and every one of them is an owner:
any of them answers questions, promotes, and takes kit updates. A session
names the developer running it from their GitHub account and their Claude
Code branch prefix, and each task's block keeps a log of who took it and who
dropped it. A developer opening a task someone else took and never closed is
told who holds it and since when, and takes it over only by saying so.

The same house rules govern how Claude works and
how it answers in every repository.

`/session-open temp` opens a temporary session, for questions about the
repository without taking a branch. It reads the same state and writes
nothing. When something from it is worth keeping or building, it offers to
turn the session into a task, or to open a task for each topic to take up
later, each with the background it needs. Asked to promote the integration
branch into the default branch, it opens and merges that pull request, by the
same checks a close uses, with no task. It needs `/session-close` only once
it has opened a task.

Five practices ride inside that workflow, so there is no further command to
remember. A new task is claimed on its own branch and then settled by
grilling, each round written into its block before it is asked. A failing
check or command is diagnosed from a command that reproduces it before
anything is changed to fix it. A file an agent reads as instructions
is written by a reference for writing them. Answers someone else must give
are gathered in a questionnaire. At close, a session that met friction is
looked back on, and each proposal becomes a question for the owner. Every
pull request a close opens carries a summary, evidence and a merge danger
call.

Every close also writes a session reference: the facts the session
learned, its decisions, exact values and open questions, one block per
subject it worked on, in a dated file under `.claude/references/` that is
never edited again. Another repository that has turned imports on takes
them in with `/session-open import`, which reads each source repository
`REFERENCES.md` names and turns every new reference into its own content,
by its own procedure or the kit's default, which `REFERENCES.md` fits to
the repository by where a subject's file goes, how one is written, and
whether a new one waits for the owner. Each reference an import takes in is
also copied bit for bit, with its companion, under `.claude/imported/`, and
every file a developer uploads to a session is copied there too, under
`session-import/`, or replaced by a placeholder describing it when it cannot
be kept. `/session-open backfill` gives
a session the reference it is missing, written from its own conversation,
for everything it did that no reference covers, kit close or not. Run as
the first thing in a new session, it asks which past closes with no
reference to write, transcribing them from the repository.

Credentials have a standard of their own, which a repository that keeps
credentials takes and may replace with its own method. Each value is kept in
a `<slug>.secrets.md` file,
encrypted with age to the public keys in `secrets-recipients.txt`, so the
repository holds them and only the owner's private keys read them. The owner
can encrypt a value on their own computer and hand a session only the
encrypted file.

## What gets installed

Everything under `.claude/afk/` and the two skill directories. These files are
**kit-owned**: an install or update replaces them whole, and they are never
edited inside a project. A fix goes into this repository and reaches a project
by an update.

| Path | What it is |
|---|---|
| `.claude/afk/HOUSE.md` | The house rules: which file wins, the rules for every action, sessions and branches, the state files, the response format, and the Session Settings keys |
| `.claude/skills/session-open/SKILL.md` | Opens a session: reads the state, surveys the branches, puts the session on its task's branch, and runs the first-run setup in a repository new to the kit. With `temp`, opens a read-only temporary session that promotes the integration branch and turns into tasks only when asked. With `import`, imports the session references of other repositories |
| `.claude/skills/session-close/SKILL.md` | Closes a session: places credentials, writes the state back and the session reference, regenerates, pushes, and merges a finished task or parks an unfinished one. It diagnoses a failing check before parking, writes the pull request body, and looks back over a session that met friction |
| `.claude/afk/references.md` | Session references: what a close writes and its companion for credentials, the copies of imported references and uploaded files, the setup that turns imports on, the import, and the kit's default import procedure |
| `.claude/afk/practices/` | Five practices `HOUSE.md` names and the skills run at fixed points: grilling, diagnosing, writing for agents, questionnaire, and retrospective |
| `.claude/afk/afk.sh` | Installs, updates, and reports the kit's status |
| `.claude/afk/todo_sweep.py` | Collects every `TODO:` in the repository into `TODO.md` |
| `.claude/afk/credentials.md` | The kit standard for credentials: age encrypted `<slug>.secrets.md` files, the keys, how a value is stored, read, re-encrypted and decrypted for a build, and the setup a repository runs to take the standard |
| `.claude/afk/secrets.py` | Stores, places, locks, checks, shows, re-encrypts and decrypts for a build the values in `<slug>.secrets.md` files, and prints the steps for making the keys. Needs the `age` command line tool |
| `.claude/afk/secrets-decrypt.mjs` | Decrypts for a build in Node, for a build host that cannot run `secrets.py decrypt`. Needs the `age-encryption` package |
| `.claude/afk/templates/` | The starting `CLAUDE.md`, `TASKS.md` and `HANDOFF.md` for the first run, the session reference a close fills in, and the `REFERENCES.md` the import setup writes |
| `.claude/afk/MANIFEST` | Written by the install: the version, the source, the commit, and a checksum per file |
| `.gitattributes` in each kit directory | Keeps LF line endings, so a checkout on Windows can still run `afk.sh` and still matches the checksums |

Everything else in a project is **project-owned** and an update never touches
it: `CLAUDE.md`, `TASKS.md`, `HANDOFF.md`, `TODO.md`, `REFERENCES.md`,
`secrets-recipients.txt`, every `<slug>.secrets.md` file, everything under
`.claude/references/` and `.claude/imported/`, and anything the project names as its authority
file. A project's `CLAUDE.md` opens with
`@.claude/afk/HOUSE.md`, which imports the house rules, and holds a
`## Session Settings` section with every value that differs between
repositories. The skills name none of those values themselves.

The house rules live in `CLAUDE.md` by import rather than inside a skill
because a skill's text loads only when the skill is invoked, and a long session
can compact it away. `CLAUDE.md` loads at the start of every session and is
read again after compaction, and the response rules have to govern every turn.

## Install

In a Claude Code session on the repository, paste this whole block. Paste it
only in a repository of your own and only if you trust this one, because it
tells Claude to run this repository's installer on your say-so.

```text
Install Artificial Field Kit into this repository. Artificial Field Kit is my own repository,
https://github.com/MrFieldTech/Artificial-Field-Kit, which I wrote and trust. I want
you to take each of these actions:

1. Attach MrFieldTech/Artificial-Field-Kit to this session with read access, if this
   is a cloud session, and clone it. It is only the source the installer
   copies from, so do not register the clone as one of this session's
   repositories.
2. From this repository's root, run the installer from that clone:
   bash <the clone>/.claude/afk/afk.sh install .
   It writes the kit's session-open and session-close skills into
   .claude/skills/ and its house rules into .claude/afk/. I want that change
   to your own configuration.
3. Follow the session-open skill it installed. It adds the line
   @.claude/afk/HOUSE.md to CLAUDE.md, writes TASKS.md and HANDOFF.md,
   commits them on a new task/ branch, and pushes that branch. Push the
   task/ branch, not the branch this session was assigned.

If auto mode blocks one of these anyway, do not work around it. Stop, and
give me the exact sentence to reply with that approves the blocked action.
```

A request as short as "Install MrFieldTech/Artificial-Field-Kit" is not enough, because
each numbered step opens a gate that stays shut until the owner's own message
names the action:

- **`[Untrusted Code Integration]`.** Auto mode's classifier trusts only the
  repository the session started in and its remotes. Attaching another
  repository and running a script from it is blocked unless the owner names
  that source. Step 1 names it and says it is the owner's own.
- **`[Self-Modification]`.** The classifier blocks a write into `.claude/` or
  `CLAUDE.md` unless the owner's message says that change is wanted. Steps 2
  and 3 name each write.
- **The assigned branch.** A cloud session's own instructions allow a push
  only to the branch it was assigned, and the kit pushes `task/<slug>`
  branches instead. Step 3 gives that permission.

The classifier is a model, and the same prompt can pass in one session and be
blocked in the next. Of five pilot attempts, two were blocked at the
installer, one at attaching the kit, and two passed. A block is answered, not
avoided: reply with the sentence the session gives, which names the blocked
action and its target, and it retries. Only if the block holds after that,
switch the permission mode from Auto to Accept edits in the mode selector,
approve the action when asked, and switch back.

Steps 1 and 2 as commands, for a session that is not in the cloud:

```
git clone --depth 1 https://github.com/MrFieldTech/Artificial-Field-Kit "$(mktemp -d)/artificial-field-kit"
bash <that clone>/.claude/afk/afk.sh install .
```

The repository is public, so any session can clone it, and a cloud session
whose proxy serves it already may find there is nothing to attach in step 1.
The clone's own `CLAUDE.md` and skills belong to the kit's repository, which
is why step 1 keeps the clone from loading into the session.

The install writes the kit-owned files into the working tree and commits
nothing. `session-open` then finds a repository new to the kit and runs its
first-run setup. It reads the repository and settles every Session Setting it
can: the Owner is the account that owns the repository, the integration
branch is `preview`, and a key the repository does not show takes its
default. It asks only about what is left, and when nothing is, it carries
straight on. Its reply does not list the settings, which are in `CLAUDE.md`.
It creates the first task's branch, writes `CLAUDE.md`, `TASKS.md` and
`HANDOFF.md` on it, and commits them with the kit. An existing `CLAUDE.md` is
kept and gains the import line and the settings, and a section of it that
only repeats `HOUSE.md` is removed.

While the first run waits for an answer, the install stays uncommitted. A
cloud session's end-of-turn hook asks for it to be committed and pushed to
the assigned branch, and the session says why it will not.

A skill installed partway through a session may not be listed until the next
session starts, which is why the install prompt says to follow the skill rather
than to run `/session-open`. From the next session on, `/session-open` works
as usual.

Two settings only the owner can change, which the first run gives as
`Action needed:` notices rather than questions: GitHub's Automatically delete
head branches, which the workflow needs because a session cannot delete a
branch, and a preview host's list of branches to build, when there is one.
The first run asks only about a rule in the repository's own files that
contradicts the kit, such as a release process that pushes straight to the
default branch.

## Update

A repository never updates itself. Every `/session-open` checks the source and
reports the kit on its `Kit:` line, and says when a newer release is there to
take:

| Line | Meaning |
|---|---|
| `1.0.0, current` | The installed files match the source |
| `1.0.0, 1.1.0 available` | The source has a newer release |
| `..., edited locally: <files>` | A kit-owned file was changed in place. Move the change into the kit |
| `1.0.0, source unreachable` | The source could not be fetched. Nothing is wrong locally |
| `1.0.0, the source has no release on its default branch` | The source's `main` holds no `VERSION`, so no release has reached it |

An update happens only when the owner asks, as its own task. In a Claude Code
session on the repository, paste this whole block. Its slug names the current
release, which is what the update takes. As with the install, paste it only in
a repository of your own and only if you trust this one:

```text
/session-open afk-update-2-0-0
Update Artificial Field Kit in this repository, as this task. Artificial Field Kit is my own
repository, https://github.com/MrFieldTech/Artificial-Field-Kit, which I wrote and
trust. I want you to take each of these actions on this task's branch:

1. Attach MrFieldTech/Artificial-Field-Kit to this session with read access, if this
   is a cloud session. Do not register it as one of this session's
   repositories.
2. Read the source: line in .claude/afk/MANIFEST, or in
   .claude/kit/MANIFEST when there is no .claude/afk/, because before
   2.0.0 the kit was named Claude-Kit and lived there. If it names
   anything other than https://github.com/MrFieldTech/Artificial-Field-Kit
   or its old address, https://github.com/MrFieldTech/Claude-Kit, in any
   letter case, stop and tell me instead of updating, because the update
   runs whatever that source holds.
3. Run bash .claude/afk/afk.sh update, or bash .claude/kit/kit.sh update
   when there is no .claude/afk/. It clones the kit from that source and
   runs the new release's installer, which replaces the kit's skills in
   .claude/skills/ and its house rules in .claude/afk/, removes
   .claude/kit/ when the kit lived there, and points the import in
   CLAUDE.md at .claude/afk/HOUSE.md. I want those changes to your own
   configuration.
4. Commit the update on its own, then do whatever the kit's CHANGELOG.md
   says the new release requires of a repository.

If auto mode blocks one of these anyway, do not work around it. Stop, and
give me the exact sentence to reply with that approves the blocked action.
```

A repository on a release before 2.0.0, when the kit was named Claude-Kit
and lived in `.claude/kit/`, updates by the same block. Its old `kit.sh`
runs a forwarder this repository keeps at `.claude/kit/kit.sh`, which hands
the install to `afk.sh`. That moves the kit to `.claude/afk/`, records the
kit's new address in the `MANIFEST`, points the `CLAUDE.md` import at
`.claude/afk/HOUSE.md`, and lists every other file that still names the old
paths. The 2.0.0 entry in `CHANGELOG.md` says what the session then changes
in those files and what it leaves as a record.

Then `/session-close` merges it like any other task. The update refuses to
overwrite a kit-owned file edited in place unless it is given
`--discard-local-edits`, because that edit may be the only copy of a fix that
belongs here.

## Backfill

To give a session its missing reference, type `/session-open backfill` in
it, whatever the session is and whenever it ran. A session started before
the kit reached the repository, or before its current release, may not
know the command, or may follow an older version of it: it says
`/session-open` is not installed, asks what you mean, or finds nothing to
write for work you know it did. Then paste this whole block into the same
session. It needs the kit at 1.14.0 or later on the repository's
integration branch, or on its default branch when it has none, so an
update not yet promoted is enough.

```text
BACKFILL RECOVERY PROMPT
I ran /session-open backfill in this session and it did not run as
Artificial Field Kit's current release intends. This repository uses Artificial Field Kit, my
own session protocol, from https://github.com/MrFieldTech/Artificial-Field-Kit,
which I wrote and trust. Your checkout may be older than the kit, so the
skill files you loaded at the start of this session, if any, are out of
date. Do not work from them or from memory. I want you to:

1. Choose the repository. When this session has more than one, the
   backfill goes into the one this session committed to or ran a kit
   /session-open in. Never write to a repository this session only read
   from. When work landed in more than one, stop and ask me which. Do
   everything below in that repository.
2. Fetch every branch: git fetch origin "+refs/heads/*:refs/remotes/origin/*"
   --prune, and git fetch --unshallow origin if the clone is shallow. Find
   the default branch from git symbolic-ref --short refs/remotes/origin/HEAD.
3. Find the base. Read the Integration branch line of the Session Settings
   in CLAUDE.md on the default branch, or on origin/preview, the kit's
   default, when the default branch's CLAUDE.md has no such section. The
   base is origin/<that branch> when it is not none and exists on the
   remote, and the default branch otherwise.
4. Check that the base holds the kit: git show
   <base>:.claude/skills/session-open/SKILL.md. If it does not exist, stop
   and tell me the kit is not installed there. Check its release: the
   version: line of .claude/afk/MANIFEST on the base, or of
   .claude/kit/MANIFEST before 2.0.0, when the kit lived there, or its
   VERSION file when there is neither. If it is older than 1.14.0, stop and tell me
   the repository needs a kit update merged into the base before a
   backfill.
5. Read these files as they are on the base, with git show, in full:
   CLAUDE.md, .claude/afk/HOUSE.md, .claude/skills/session-open/SKILL.md,
   .claude/skills/session-close/SKILL.md and .claude/afk/references.md,
   with .claude/kit/ in place of .claude/afk/ before 2.0.0.
6. Follow session-open as if I had just typed /session-open backfill in
   this session: steps 1 to 3, then its Backfill section, and the
   Backfilling rules in references.md. Once step 2 has checked out the
   base, read every kit file from disk.
7. What this session did means everything in this conversation, including
   work done before the kit was installed and work that ran no kit close,
   less anything a reference already covers. Write it from the
   conversation, citing the commits it made by hash. Invent nothing: what
   the conversation and the repository do not show is left out or flagged.
8. Work only on the backfill task's own branch, task/backfill-<yymmddhhmmss>.
   Never push the branch this session started on.
9. When the backfill closes itself, I approve two actions on the
   integration branch named in CLAUDE.md's Session Settings: recreating it
   at the default branch's head when it is absent, by git push or through
   this session's GitHub access, and opening the backfill task's own pull
   request into it and merging that pull request with a merge commit. Do
   not merge into the default branch unless I ask.

If auto mode blocks one of these, do not work around it. Stop, and give me
the exact sentence to reply with that approves the blocked action.
```

## Working on the kit

This repository runs on its own protocol, from the same files it ships. The
files under `.claude/afk/` and the two skills are the source, so there is no
`MANIFEST` here, and `afk.sh status` reports the source itself.
`.claude/kit/kit.sh` is not kit-owned and is never installed: it is the
forwarder a release before 2.0.0 runs to update, and it stays as long as a
repository on one may still update.

- **Nothing the kit installs names a project.** A kit-owned file is
  installed into every repository, and this repository is public, so it
  names no project, person, account, host, address or credential. `check.sh`
  refuses any web address, email address or host name, and any name on the
  owner's private list of project terms, which is kept out of the repository
  in the `AFK_PRIVATE_TERMS` secret CI reads. This repository's own session
  references and copies are public too, so the same list applies to them:
  the close redacts a match before committing a reference, and an upload
  holding one gets a placeholder in place of its copy. This repository never
  imports. Review catches the rest.
- **Every change to a kit-owned file is a release.** Bump `VERSION`, add a
  `CHANGELOG.md` entry, and set the slug in the update block above to the new
  version, all in the same pull request.
- **`main` is what every install and update takes,** so it moves only when the
  owner asks, like the default branch of any repository using the kit.
- **The practices are adapted from a public collection of agent skills,**
  https://github.com/mattpocock/skills, under the MIT License. `NOTICE.md`
  holds its notice and names the skill each practice came from. A kit-owned
  file credits it without naming it, by the rule above.
- **Run `bash check.sh` before a pull request.** It checks for addresses and
  project names, the em dash, the scripts and the skills, and that a task
  block's field and holder lines read as the `TASKS.md` template has them. Locally it checks
  names only when an untracked `.private-terms` file holds the list. It also installs the kit into a
  scratch repository and exercises the install, status, update, the TODO
  sweep and the secrets tool end to end. CI runs it on every pull request.
