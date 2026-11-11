# Session Handoff

## Purpose

The state above any one task that a fresh session needs. `session-close` edits
this file in place at the end of every session and `session-open` reads it at
the start of the next, so a session with no memory of the last one picks up
from committed files alone. Where each task stopped is in its own block in
`TASKS.md`, not here, because sessions on different tasks can close into this
file at the same time.

## Session Log

| Date | Developer | Tasks touched | Work commits |
|---|---|---|---|
| 2026-11-11 | GRM / MRFIELDTECH | `skill-incorporation`, DONE, merged into `preview`: release 2.1.0 adds `.claude/afk/standards/` with the site standard (static and full featured parts, the hosting line), a content policy template and twenty design rules, named in `HOUSE.md`; `house-instructions` and `vendored-skills` opened for later | `4995d34..003517b` |
| 2026-11-11 | GRM / MRFIELDTECH | `unique-name`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 2.0.0 renames the kit Artificial Field Kit and moves it from `.claude/kit/` to `.claude/afk/`, with a forwarder that moves a 1.x repository on its next update; `private-terms` opened for later | `70399cf..2b0503b` |
| 2026-11-10 | GRM / MRFIELDTECH | `backfill-problems`, DONE, merged into `preview`: release 1.16.0 has the BACKFILL RECOVERY PROMPT check and read the kit on the base rather than the default branch, and backfill only the repository the session worked in | `6d6212a..333e4c2` |
| 2026-10-19 | GRM / MRFIELDTECH | `backfill-questions`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.15.0 lets backfills of their own sessions run side by side, has the BACKFILL RECOVERY PROMPT approve the self-close's merge, rebuilds interleaved task blocks whole, detaches after a merged branch is deleted, and reports a finished but unmerged branch as a close perhaps still running | `049569e..51edf26` |
| 2026-10-17 | GRM / MRFIELDTECH | `backfill-no-close`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.14.0 has a backfill cover everything its session did that no reference covers, names backfill references `<yymmddhhmmss>-<slug>-bf.md`, and adds the BACKFILL RECOVERY PROMPT to `README.md` | `054e960..d99a0e6` |
| 2026-10-17 | GRM / MRFIELDTECH | `import-file-process`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.13.0 keeps a bit for bit copy of each imported reference and its companion, and of every file uploaded to a session, under `.claude/imported/` | `94754b0..90bd2f0` |
| 2026-10-17 | GRM / MRFIELDTECH | `import-update-match`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.12.0 lets `REFERENCES.md` set where the kit default import puts a subject's file, how it is written, and whether a new one waits for the owner | `ce39f97..0ce6163` |
| 2026-10-16 | GRM / MRFIELDTECH | `backfill-intent`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.11.0 has `/session-open backfill` write only the reference its own session is missing, and ask which past closes to write when run first in a new session | `3184930..11fd4f0` |
| 2026-10-16 | GRM / MRFIELDTECH | `task-name-changes`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.10.0 renames holder lines to `HOLDING` and `DROPPED` and adds a `DISMISSED` status | `c386626..3ff816d` |
| 2026-10-16 | GRM / MRFIELDTECH | `check-block-fields`, DONE, merged into `preview`: release 1.9.0 has `check.sh` hold every fenced task field block and holder line to the `TASKS.md` template, and swaps `HOUSE.md`'s holder pair to the template's order | `85e0cb5..68b60a4` |
| 2026-10-16 | GRM / MRFIELDTECH | `check-block-fields`, ACTIVE, parked: opened for later from `grill-position-diff`'s retrospective, with its two open decisions in its block; then MrFieldTech's answer that every close writes a reference | `4a2f938..9b49558` |
| 2026-10-16 | GRM / MRFIELDTECH | `grill-position-diff`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.8.0 claims a new task's branch before grilling it, and writes each round into its block | `df78d4f..6580c0f` |
| 2026-10-15 | GRM / MRFIELDTECH | `session-references`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.7.0 adds session references, `/session-open import` and `/session-open backfill`, after taking in 1.6.0 | `6233007..7e0bf1f` |
| 2026-10-15 | GRM / MRFIELDTECH | `multi-dev-setup`, DONE, merged into `preview`: release 1.6.0 lets several developers share a repository, every one an owner, with holder lines on each task | `824ed6f..fe201c3` |
| 2026-10-12 | not recorded | `secrets-self-sufficient`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.5.0 adds `secrets.py decrypt` and `keys`, a Node decrypter, the Secrets checks setting, and the setup a repository runs to take the secrets standard, and makes Credentials default to `none` | `7f3de9e..a96379a` |
| 2026-10-12 | not recorded | `secrets-self-sufficient`, ACTIVE, parked: opened from a private repository taking 1.4.0, with the owner's four decisions and the first round of open decisions in its block | `e3c86fe..083f57b` |
| 2026-10-12 | not recorded | `age-secrets`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.4.0 makes age encrypted `<slug>.secrets.md` files the kit standard for credentials | `471e2b4..c5c5162` |
| 2026-10-11 | not recorded | `workflow-practices`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.3.0 folds five practices and a pull request body into the session protocol | `c5394a9..f342a7b` |
| 2026-10-01 | not recorded | `preview-promotion`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.2.0 lets a temporary session promote the integration branch | `c5d170a..19e297c` |
| 2026-09-30 | not recorded | `readme-version-update`, DONE, merged into `preview`: the README's update block names the current release, and `check.sh` holds it to `VERSION` | `b7e7ae1..067e760` |
| 2026-09-30 | not recorded | `add-session-temp`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.1.0 adds `/session-open temp` | `db3756b..d48c4d3` |
| 2026-09-28 | not recorded | `multi-line-secrets`, DONE, merged into `preview` and then `main` at MrFieldTech's request: release 1.0.5 never commits a credential in plaintext | `3e8aa5b..a1a2427` |
| 2026-09-27 | not recorded | `go-public`, DONE, merged into `preview`: the repository is public | none, the handoff alone |
| 2026-09-27 | not recorded | `go-public`, BLOCKED, merged into `preview`: the pre-public review's fixes, with release 1.0.4 | `d5ef770..ef64e39` |

## Blocked On

None.

## Decisions Made

- **The kit is vendored, not a plugin and not account-level skills.** MrFieldTech,
  2026-09-24. Each repository holds a pinned copy, so it resumes from
  committed files alone, a kit change reaches it as a reviewable diff, and the
  command names stay `/session-open` and `/session-close`. A plugin cannot
  carry `CLAUDE.md` and would put the protocol governing a repository outside
  it. Skills held on an account sit outside git and go stale unseen.
- **The house rules are imported by `CLAUDE.md`, not carried in a skill.** A
  skill's text loads only when invoked and can be compacted away, and the
  response rules govern every turn. The import was confirmed to load in a
  headless session on 2026-09-24.
- **The integration branch is a per-repository setting, `preview` by
  default.** MrFieldTech, 2026-09-24. The rule that the default branch moves only
  when the owner asks then holds everywhere unless a repository opts out.
- **1.0.0 reached `main` before the pilot.** MrFieldTech, 2026-09-24, so the pilot
  installs by the command in `README.md` rather than from a task branch.
- **No permission rule for a headless `claude` session.** MrFieldTech, 2026-09-24.
  The pilot and the owner's own sessions in real repositories are the fresh-session
  tests.
- **The first run settles the Owner and the integration branch without
  asking.** MrFieldTech, 2026-09-25. The Owner is a placeholder for whoever answers,
  so it is the account that owns the repository, and the integration branch
  is `preview`. Either is changed in `CLAUDE.md` afterwards.
- **A `CLAUDE.md` section that only repeats `HOUSE.md` is removed.** MrFieldTech,
  2026-09-25: there should be no duplicate, because two copies drift apart.
- **An install session stays in Auto mode, and a block is answered when it
  happens.** MrFieldTech, 2026-09-25. Accept edits mode never blocks but makes every
  command that is not read-only wait for approval. The session stops and
  gives the sentence that approves the blocked action.
- **The install prompt may be as long as it needs.** MrFieldTech, 2026-09-25. It is
  pasted whole from `README.md`, and a short one does not clear auto mode.
- **`session-close` rechecks a pull request about once a minute and skips a
  second run of checks that already passed on the same code.** MrFieldTech,
  2026-09-26. Each recheck is a short turn on cached context, and the second
  run on the pull request into the default branch tested nothing new.
- **A repository never updates the kit itself.** An update changes the rules
  a session runs on, so it is the owner's call, taken by the update prompt in
  `README.md` as its own task.
- **Files here are written as if the repository were public.** It was asked
  for as public and created private. Nothing the kit installs names a
  project, so making it public later needs no cleanup first.
- **The repository is public.** MrFieldTech, 2026-09-26, so any session can check
  and take updates without attaching it. The list of project terms moved out
  of `check.sh` into the `KIT_PRIVATE_TERMS` secret, because MrFieldTech
  would rather the repository name none of their other projects. The history
  stays as it is, by MrFieldTech's choice.
- **The history stays as it is, including the company address on the merge
  commits.** MrFieldTech, 2026-09-27. The kit is not advertised, and that
  address is not hidden, though the public one is a different address.
- **A credential is committed only encrypted, and only in a repository
  confirmed private.** MrFieldTech, 2026-09-28. Secrets are encrypted in
  transit, by the method each repository's Credentials setting names, and
  encryption does not make a public repository a place for them.
- **A temporary session, `/session-open temp`, answers questions without a
  branch and turns what is worth keeping into tasks.** MrFieldTech,
  2026-09-30. A question-only session should not claim a task. It offers to
  become a task or to open one per topic, the slug comes from the owner or is
  proposed and asked, and a branch for later is a parked task whose block
  carries its background, so it is never a stray.
- **The README's update block names the current release, and every release
  sets it.** MrFieldTech, 2026-09-30. A release already changes the
  repository, so the prompt is pasted as is. The rule is in `CLAUDE.md` and
  `check.sh` enforces it.

- **A temporary session promotes the integration branch when asked, in any
  words, with no keyword.** MrFieldTech, 2026-10-01. Main only takes merges
  from preview, so a promotion cannot conflict and has no resolution to
  record. It leaves no session log line, the pull request is the record, and
  `session-close` step 9 still promotes when asked during a close.
- **Recurring kinds of work are plain files the protocol reaches, not
  skills.** MrFieldTech, 2026-10-11, adopted six skills from a public
  collection and asked that none need a command to remember. Five are
  practices in `.claude/kit/practices/`, named in `HOUSE.md` and run by the
  session skills at fixed points, and the pull request body is written into
  `session-close`. Plain files sit in an existing kit directory, so the
  install is unchanged and no name can collide with a skill a repository or
  harness has. The collection's skills that bring a second work queue, a
  second handoff or a second branch model were declined.
- **The source collection's license notice is not installed.** MrFieldTech,
  2026-10-11. It names the collection's author, so it stays in `NOTICE.md`
  at the root, and each practice credits the collection without a name.
- **Age encrypted `<slug>.secrets.md` files are the kit standard for
  credentials.** MrFieldTech, 2026-10-11. The setting `kit standard` is the
  default (superseded 2026-10-12: the default is now `none`, below), and a repository keeps its own method by naming it, because one
  of the owner's private repositories already ran the process and it should
  be the same everywhere. A public repository still commits no credential.
- **Every repository uses the kit for whatever the kit supports, unless it
  has a use case that needs otherwise.** MrFieldTech, 2026-10-12. The
  private repository whose process became the standard keeps its own script
  until the owner updates its kit and switches it by hand.
- **The kit's secrets standard is self-sufficient, and opt-in.**
  MrFieldTech, 2026-10-12. Whatever the kit encrypts it decrypts, makes keys
  for and checks, so a repository keeps only what is particular to it.
  Credentials defaults to `none`, because some repositories never need the
  feature. A repository whose build neither kit decrypter serves names its
  own method, because finding another way is not the kit's job. The full
  decisions are in the `secrets-self-sufficient` block in `TASKS.md`.

- **Every developer is an owner, and a session records who it is.**
  GRM / MRFIELDTECH, 2026-10-15. The organization is flat, so the kit
  builds in no hierarchy or employee list. A session names its developer
  from the GitHub account and the Claude Code branch prefix, and each task
  keeps ACTIVE and INACTIVE holder lines (superseded 2026-10-16: `HOLDING`
  and `DROPPED`, below). The full decisions are in the
  `multi-dev-setup` block in `TASKS.md`.
- **Developers sharing one GitHub account are their own responsibility.**
  GRM / MRFIELDTECH, 2026-10-15. They look like one developer and neither
  is warned, but adding a collaborator is easy.
- **`multi-dev-setup` went before `session-references`.** GRM /
  MRFIELDTECH, 2026-10-15, so references carry the developer from their
  first release, which moves `session-references` to 1.7.0.

- **Every close writes a session reference, and other repositories import
  them.** GRM / MRFIELDTECH, 2026-10-14 and 2026-10-15. Facts a session
  learns should reach another repository without a person carrying them.
  Credentials In Transit gave way to each session's companion. The full
  decisions are in the `session-references` block in `TASKS.md`.
- **The kit default import follows, unnamed, a private repository's
  handoff promotion.** GRM / MRFIELDTECH, 2026-10-15, approved publishing it
  generically, so it works first of all as that repository works today and
  asks only what it cannot record.
- **This repository's references are redacted against `KIT_PRIVATE_TERMS`
  before commit.** GRM / MRFIELDTECH, 2026-10-15. Moved to `CLAUDE.md` as a
  project rule.

- **A new task is claimed before it is grilled.** GRM / MRFIELDTECH,
  2026-10-16. The order was never decided, it followed from the block being
  written in the claim's commit, and it left every answer only in the
  conversation. The full decisions are in the `grill-position-diff` block in
  `TASKS.md`.

- **Every close writes a session reference, even one that learned
  nothing.** GRM / MRFIELDTECH, 2026-10-16, so the record has no gaps. A
  reference already covers only its own task branch since that branch's
  last close.

- **Holder lines read `HOLDING` and `DROPPED`, and a task that will not be
  done is `DISMISSED`.** GRM / MRFIELDTECH, 2026-10-16, so a holder word is
  never read as a status. Existing lines are renamed rather than read two
  ways, and a `DISMISSED` task closes like `DONE`. The full decisions are
  in the `task-name-changes` block in `TASKS.md`.

- **`/session-open backfill` covers only the session it runs in.**
  GRM / MRFIELDTECH, 2026-10-16. It fills a close that wrote no
  reference, never duplicates one that did, and only a brand new session
  asks which past closes to write. The full decisions are in the
  `backfill-intent` block in `TASKS.md`.

- **A repository keeps a bit for bit copy of what it is given, under
  `.claude/imported/`.** GRM / MRFIELDTECH, 2026-10-17. An imported
  reference and its companion are copied whole, and every upload too, so the
  record survives the source; a file that cannot be kept gets a placeholder
  describing it. The full decisions are in the `import-file-process` block
  in `TASKS.md`.
- **This repository never imports from other repositories.** GRM /
  MRFIELDTECH, 2026-10-17. Moved to `CLAUDE.md` as a project rule.

- **`/session-open backfill` covers everything its session did that no
  reference covers, kit close or not.** GRM / MRFIELDTECH, 2026-10-17,
  superseding `backfill-intent`'s rule that it covers only kit closes with
  no reference: work from before the kit was being lost. A session too old
  to run it is brought back by the BACKFILL RECOVERY PROMPT in `README.md`.
  The full decisions are in the `backfill-no-close` block in `TASKS.md`.

- **Backfills of their own sessions run side by side, and the recovery
  prompt approves the self-close's merge.** GRM / MRFIELDTECH, 2026-10-19,
  after four backfills run at once in another repository each stopped on
  auto mode and rebuilt interleaved task blocks by hand. The full decisions
  are in the `backfill-questions` block in `TASKS.md`.

- **The BACKFILL RECOVERY PROMPT works from the base, in the repository
  the session worked in.** MrFieldTech, 2026-11-10, after a session refused
  to backfill a repository whose kit update was on its integration branch
  only, and offered a second repository it had only read. The full
  decisions are in the `backfill-problems` block in `TASKS.md`.
- **The kit is Artificial Field Kit, AFK, in `.claude/afk/`.** MrFieldTech,
  2026-11-11: Claude-Kit was a name anyone could use. Release 2.0.0, at
  `MrFieldTech/Artificial-Field-Kit`. The full decisions are in the
  `unique-name` block in `TASKS.md`.
- **The 1.x forwarder stays at `.claude/kit/kit.sh`.** GRM / MRFIELDTECH,
  2026-11-11, in `unique-name`: every 1.x repository updates by running it.
  Moved to `CLAUDE.md` as a project rule.

## Open Questions

- **Should the private repository the default import follows name its
  import procedure?** Raised by GRM / MRFIELDTECH, 2026-10-15, in
  `session-references`. Its authority file governs it and names none, so
  an import there would stop or run the kit default. From 1.12.0 it can
  fit the kit default to itself by the three values in `REFERENCES.md`
  instead (GRM / MRFIELDTECH, 2026-10-17, `import-update-match`). Open a
  task there, after it updates to 1.12.0, setting those values or writing
  its own?

- **Should the kit offer a review step for task pull requests?** Raised by
  GRM / MRFIELDTECH, 2026-10-15, in `multi-dev-setup`. Sessions merge their
  own pull requests, and a repository whose branch protection requires an
  approval would park every task at close. Not wanted now; open a task when
  it is?
- **Should CI fail when `AFK_PRIVATE_TERMS` is empty?** Raised by GRM /
  MRFIELDTECH, 2026-11-11, in `unique-name`, for `private-terms`. The
  secret never existed and CI skipped the names check with only a log
  line, so no session noticed, and this one told MrFieldTech to copy a
  secret that was not there. Settle it in `private-terms`?

- **Should the kit make every remote branch tracked from the start?** A
  session working from a single-branch clone pushed its task branch, but git
  recorded no `origin/task/<slug>`, so the cloud end-of-turn hook reported
  the branch as unpushed and `session-close` step 7's check that
  `origin/task/<slug>` matches `HEAD` had nothing to compare. Setting
  `remote.origin.fetch` to every branch in `session-open` step 1 would
  prevent it. This is a change to a kit-owned file. Open a task for it?
- **Should `check.sh` refuse to run on uncommitted kit-owned changes?**
  Section 5 installs from a clone of `HEAD`, so run before committing it
  failed with "status after install reads '1.2.0, current', not '1.3.0,
  current'", which reads as a broken installer rather than "commit first".
  It happened again in `session-references` on 2026-10-14, and in
  `check-block-fields`, `task-name-changes` and `backfill-intent` on
2026-10-16, and in `backfill-no-close` on 2026-10-17, and in
  `backfill-problems` on 2026-11-10. Open a task for it?
- **Should `grilling.md` have a question carried from an earlier session
  rewritten before it is asked?** Raised by GRM / MRFIELDTECH, 2026-10-16,
  in `check-block-fields`. Its open questions were written in shorthand when
  the task was opened for later ("Which copies does the check hold to the
  template?"), asked as written, and MrFieldTech could not tell what they
  applied to; a rewrite naming the files and quoting the lines in question
  would have saved a round. This is a change to a kit-owned file. Open a
  task for it?

- **Should `grilling.md` have each option show, by a concrete example,
  what the kit would then do?** Raised by GRM / MRFIELDTECH, 2026-10-17, in
  `backfill-no-close`. MrFieldTech chose an option on what a backfill
  covers, saw in the next round what it meant, and replaced it, which cost
  a round and a rewrite of the decisions. This is a change to a kit-owned
  file. Open a task for it?

## Flagged As Unverified

**Cloudflare's free plan and the site standard's hosting line.** The
session believed, from memory, that the free plan includes Pages Functions,
Workers, KV and D1 within daily limits; HOST-1 has every site read the
pricing pages instead. Verified by: the first site that runs HOST-1,
recording what the pages say.

**The legal grounds the full featured rules cite.** AGE-1's under 13 line,
UPLOAD-5's copyright agent registration and MAIL-2's provider handling of
one-click unsubscribe headers were written from general knowledge and not
checked against a source this session. Verified by: the owner confirming
each where a site operates, as Part 2 of `site.md` asks.

**No repository has moved from 1.x to 2.0.0 through GitHub.** A real
1.16.0 install updated through its own `kit.sh update` to `.claude/afk/`
in a scratch repository on 2026-11-11, from a local source, and `check.sh`
tests the forwarder's mapping of the old address. Verified by: the first
repository to take 2.0.0 by the update prompt, which should end with
`.claude/afk/`, the new address in its `MANIFEST`, and the files the
update listed changed by the 2.0.0 entry.

**Whether the old address keeps redirecting.** On 2026-11-11 both
addresses returned the same `HEAD`. GitHub ends a redirect if a repository
is ever created at the old name. Verified by: never creating
`MrFieldTech/Claude-Kit` again.

**No session has made a copy under `.claude/imported/`.** `backfill-no-close`
wrote four placeholders under `session-import/`, by this repository's rule
for uploads it cannot check, but copied nothing. Verified by: an upload
copied whole, and an import, which should copy each reference and its
companion in that reference's commit.

**How a session sees an uploaded file's original name.** In one cloud
session, `backfill-no-close`, uploads sat under `/root/.claude/uploads/`
with eight hex digits and a hyphen in front of each original name, and the
session took the rest as the name. Verified by: an upload in a local
session, and one whose original name itself starts with eight hex digits.

**No import has run 1.12.0's three values.** Imports are not on in any
repository known here. Verified by: a `/session-open import` in a
repository whose `REFERENCES.md` sets Subject home to a pattern with `*`
and Confirm new homes to `yes`, which should ask every new home's path in
one round before importing.

**1.14.0's backfill is verified only in sessions that did work.** Four
sessions in another repository, which had done work with no kit close, ran
it through the BACKFILL RECOVERY PROMPT on 2026-10-17, one after loading
1.13.0, and each wrote one `-bf` reference. Verified by: a backfill run
first in a new session, which should list past closes and ask, and the
prompt pasted into a session whose checkout predates the kit.

**No session has run 1.16.0's recovery prompt.** Verified by: the prompt
pasted into a session with two repositories, one only read, whose kit
update sits on the integration branch unpromoted; it should choose the
repository it worked in and backfill from the integration branch.

**No session has run 1.15.0.** Verified by: a backfill whose recovery
prompt carries the item approving the self-close's merge, which should recreate the integration branch and
merge its pull request with no auto mode block; a close whose end-of-turn
hook stays quiet after step 8 detaches; and a merge that rebuilds two
interleaved task blocks whole.

**No session has written a reference at close, imported, or backfilled.**
1.7.0 was checked by `check.sh` only, which tests the companion and the
decrypt skip, not the skills. This close writes the first reference; the
first `/session-open import` and `/session-open backfill` verify the rest,
including `git diff --diff-filter=A` across a source's history.

**Whether GitHub custom secret scanning patterns are available on this
account.** Push protection on a public repository is believed free; custom
patterns, which could catch project names, were not checked.

**No reference or kit-owned file here has been checked against private
terms.** The `KIT_PRIVATE_TERMS` secret never existed, found 2026-11-11, so
CI skipped the check on every run. Verified by: `private-terms` setting
`AFK_PRIVATE_TERMS` and a CI run passing with it.

**No session has run 1.6.0's open or close from start to finish.** This
session opened under 1.5.0 and wrote its own holder lines by hand. The next
`/session-open` verifies the prefix read from the harness branch, the
`Holder:` and `Questions:` lines, and the held-task warning; the next close
verifies the INACTIVE line and step 9's check 4.

**How a local session shows the branch prefix.** The prefix was read only
from a cloud session's harness branch, `grm/elegant-hypatia-o6xu3r`. Whether
a local session starts on a prefixed branch, or shows the prefix at all, has
not been tried; without one its holder line carries the handle alone.

**The Node decrypter has been checked against one version of
`age-encryption`.** Locally, `check.sh` matched its output to `secrets.py
decrypt` with the package at 0.3.1, given by `CHECK_NODE_MODULES`. CI has no
package, so it tests only the check build and the refusals. A repository
that pins another version and decrypts with it verifies that version.

**No repository has run the 1.5.0 setup or `secrets.py keys`.** The keys
steps have not been run on Windows or macOS, and no session has written a
repository's Secrets checks or wired `decrypt` into a build. The private
repository whose build was the model, switching to `kit standard`, verifies
them.

**No repository has kept a credential by `kit standard` yet.** `check.sh`
section 6 tests `secrets.py` in a scratch repository. The steps `secrets.py
steps` prints for Windows Command Prompt and for macOS or Linux have not been
run on either. The first repository to take 1.4.0 and store a value verifies
them.

**No session has run 1.8.0's `session-open` from the skill.**
`grill-position-diff` claimed first and wrote its rounds into its block by
hand, under 1.7.0's text. The next new task verifies the claim before
grilling, the search for a matching task when no slug is named, and, when
one is dismissed, the `Dismissed:` close.

**No session has written a `HOLDING` line from the skill, and no repository
has renamed its holder lines after updating to 1.10.0.** `task-name-changes`
opened under 1.9.0 and its line was renamed by hand; its close wrote the
first `DROPPED` line from 1.10.0's text. The next `/session-open` verifies
the `HOLDING` line and the held-task warning on it; the first repository to
take 1.10.0 verifies the changelog's rename steps.

**No session has diagnosed a failure under 1.3.0.** The first failing check
or Regenerate command tries the diagnosis.

**No temporary session has promoted the integration branch.** 1.2.0 was
checked by `check.sh` only. The first promotion asked for in a
`/session-open temp` session verifies that it waits for the checks on the
integration branch's head and commits nothing.

**No session has run 1.0.3's close.** The sixth pilot attempt ran a full
round on 1.0.2 on 2026-09-26. The once-a-minute recheck and the skipped second
run of checks are untested.

**Whether the update prompt works as one message.** It starts with
`/session-open` and carries the instructions on the lines after it. Whether
Claude Code passes those lines to the skill has not been tried.

**How often the rebuilt install prompt passes auto mode without a block.**
It passed in the sixth attempt, its first use. The fifth attempt was blocked
by the server-side classifier with no reason given, on a prompt that named
the source, so one pass does not show it always holds.

**Whether Accept edits mode lets a cloud session's owner approve the install.**
The permission-modes documentation says a cloud session's Accept edits mode is
`default` mode, where a shell command outside the read-only set prompts.
Nobody has tried it. A pilot that falls back to it verifies it.

**Whether a skill installed partway through a session is listed before the
next session starts.** The install prompt in `README.md` says to follow the
skill rather than run `/session-open`, so the first run works either way.

**The house rules load by import.** Confirmed in a headless session on
2026-09-24, with no approval prompt. Not yet seen in an interactive session.

**The repository the skills came from has not yet opened a session on the
kit.** Its next `/session-open` should print a `Kit:` line. That report is
item 3 of `release-1-0`.
