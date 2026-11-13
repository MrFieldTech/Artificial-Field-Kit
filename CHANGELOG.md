# Changelog

Every change to a kit-owned file is a release, recorded here with the version
`VERSION` carries. A project's `/session-open` reports when a newer release
exists, and the project takes it by `afk.sh update` when its owner asks.

## 2.4.0

Any AI coding tool can run the kit, not only Claude Code, through an
`AGENTS.md` pointer. Claude Code loads the kit as before.

- `.claude/afk/templates/AGENTS.md` is the kit's pointer: it tells any
  tool to read `CLAUDE.md` and `HOUSE.md` first and again after its
  context is summarized, that `/session-open <words>` and `/session-close`
  mean reading and following the skill files, that both run only when the
  owner asks, and what the few Claude Code terms in the kit mean.
- `afk.sh install` and `update` write `AGENTS.md` from it when the
  repository has none, add it above the text of one that has no pointer,
  and rewrite only the block between its markers after that. `AGENTS.md`
  stays project-owned. One that is a link, often to `CLAUDE.md`, is left
  alone and reported.
- `HOUSE.md` ranks a repository's own text in `AGENTS.md`, below the
  pointer, with `CLAUDE.md` in Which file wins, `CLAUDE.md` first. It says
  how a tool without slash commands runs the two skills, gives the
  commands that find the developer's handle and prefix, and words the
  branch the session started on, the owner and the mirrored agents
  without assuming Claude Code.
- Both skills' descriptions, `session-open`'s import step,
  `session-close`'s note on unpushed work, `references.md` and the site
  standard no longer assume Claude Code. First run reads an existing
  `AGENTS.md` and treats its own text as it treats `CLAUDE.md`.
- `README.md`'s install, update and backfill prompts work in any tool, and
  the notes on Claude Code's auto mode have a section of their own.
- A cold read of the protocol from `AGENTS.md`, by a fresh session told to
  use nothing else, found steps that leaned on what a session already
  knew. `session-open` now stops on uncommitted changes before it checks
  out anything, skips First Run and the stray stop for `temp` where they
  come up rather than only at step 4, has First Run read `HOUSE.md`
  first, since `CLAUDE.md` does not import it yet, and points a new task's
  block at Format. `session-close` gives a `gh` command for the
  repository's visibility, for recreating the integration branch and for
  waiting on checks. `HOUSE.md` and the pointer say to read the rules and
  the skill being followed again after the context is summarized, and
  `references.md` defines an upload.

A repository that updates commits the `AGENTS.md` the update writes or
changes. A session that opens on a working copy with uncommitted
changes now stops until they are committed, stashed or discarded. When the update reports `AGENTS.md` is a link, replace the link
with a file holding the repository's own text, if any, and run the update
again. When an `AGENTS.md` it topped with the pointer holds text that only
repeats `HOUSE.md`, remove that text.

## 2.3.0

The kit installs skills and agents written outside it, mirrored in its own
repository.

- `vendor/` in the kit's repository mirrors four sources bit for bit:
  emilkowalski/skills, cloudflare/security-audit-skill, the
  `code-simplifier` agent from anthropics/claude-plugins-official, and
  mukul975/Anthropic-Cybersecurity-Skills. `vendor/SOURCES` says what each
  installs, and `refresh.sh`, which is never installed, refreshes a mirror
  from upstream as its own release.
- Every repository takes the emilkowalski skills, the security audit skill
  and the agent. The cybersecurity skills install only by name, under a new
  Session Settings key, Security skills, `none` by default.
- `afk.sh` installs each mirrored skill to `.claude/skills/<name>/` and each
  agent to `.claude/agents/`, lists them under `vendored` in `MANIFEST`,
  and treats them as kit-owned. One in place that no install wrote stops
  the install, which changes nothing. Their licenses go to
  `.claude/afk/licenses/`.
- `afk.sh status`, `install` and `update` fetch the kit by a blobless
  sparse clone, holding only the kit-owned files and the mirrors the
  repository installs, so the mirrors are never downloaded whole.
- `HOUSE.md` gains a Mirrored skills section: how a Security skill is
  read and added, and what to do on a clash.

A repository that updates adds `- **Security skills:** none` as the last
line of its Session Settings. When the update stops on a clash, it follows
Mirrored skills in `HOUSE.md`. Its own skills under `.claude/skills/` and
agents under `.claude/agents/` are untouched otherwise. On Windows, a
checkout that turns LF into CRLF can make `afk.sh status` report the
installed copies as edited, because they carry no `.gitattributes` of
their own.

## 2.2.0

The house rules carry the owner's general instructions and a permission to
fail.

- Rules for every action: never invent or assume a name, figure, price,
  version, source, feature or which tool is in use, and say "I don't know"
  in a reply; label a guess as one; point out an error, contradiction or
  flawed premise at once, including in the session's own earlier work, and
  ask which is current when the owner and the files disagree; say so when
  a recommendation reverses a recorded decision; prefer automating
  repeatable work. The dash rule now bans the en dash too.
- A new section, Permission to fail: make a real attempt, and when the goal
  is out of reach, give a failure report instead of a workaround that only
  looks right. The report is kept in full under What brevity never
  suppresses.
- Response format: part 1 leads with the answer, Yes or No first, a verdict
  and its deciding factors first; no affirmation or filler. New: Writing
  for the owner, for a capable non-specialist unless `CLAUDE.md` says
  otherwise, acronyms spelled out, American English; and Commands for the
  owner, complete commands, and only the confirming ones first when a step
  depends on what the owner must check.
- `check.sh` fails on an en dash as on an em dash.

A repository that updates should look for en dashes in its own files, which
the house rules now forbid.

## 2.1.0

The kit carries standards: how a website is built and how any interface
looks, read when their case comes up, as the practices are.

- `.claude/afk/standards/site.md`, the site standard. It was written
  outside the kit and reached version 1.2 there; the kit takes it over from
  that version, generic, and it now follows the kit's version. Part 1 is
  the static site it covered. Its typefaces are now always served from the
  site's own origin: FONT-1 is a MUST, and FONT-2 forbids a font host such
  as Google Fonts. New: which part applies, SITE-1 to SITE-3; the hosting
  line, HOST-1 to HOST-4, which warns before a site needs more than
  Cloudflare's free plan; and Part 2, the full featured site, with rules
  for its stack, analytics that never capture keys or inputs, a 13 or
  older age check that stores no birth date, email to a list with one-click
  unsubscribe and a mailing address, and uploads with a consent checkbox, a
  content policy and a Report Infringement link.
- `.claude/afk/standards/content-policy.md`, the template a full featured
  site fills to publish its content policy.
- `.claude/afk/standards/design.md`, twenty design rules, DESIGN-1 to
  DESIGN-20, each with its reason and check, and which design skills to
  reach for when they are installed.
- `HOUSE.md` gains a Standards section, and the standards rank between the
  skills and the practices in Which file wins.

A repository that already has a site built to the standard's version 1.2
checks it against FONT-1 and FONT-2, and records in its `CLAUDE.md` which
part it is built to, per SITE-1, the next time its site is worked on.
Nothing else needs doing after updating.

## 2.0.0

The kit is renamed Artificial Field Kit, AFK for short, and moves from
`.claude/kit/` to `.claude/afk/`. It was Claude-Kit, a name anyone could
use for their own project.

- The kit's repository is
  `https://github.com/MrFieldTech/Artificial-Field-Kit`. The old address
  still reaches it, and the update records the new one in the `MANIFEST`.
- `.claude/kit/` is now `.claude/afk/`, `kit.sh` is `afk.sh`, `KIT_SOURCE`
  is `AFK_SOURCE`, and an update's task slug is `afk-update-<version>`.
  The skills keep their directories and commands, and "the kit" stays the
  kit in prose.
- An update from a release before 2.0.0 runs the old `kit.sh update`, which
  runs a forwarder the kit's repository keeps at `.claude/kit/kit.sh`. The
  install it hands over to refuses, as always, when a kit-owned file was
  edited in place. Otherwise it removes `.claude/kit/`, installs
  `.claude/afk/`, points the `CLAUDE.md` import at `.claude/afk/HOUSE.md`,
  and lists every other file that still names the old paths or the old
  name.
- `todo_sweep.py` still overwrites a `TODO.md` that its release before
  2.0.0 wrote.
- `README.md`'s update prompt reads the `MANIFEST` and runs the update
  from either place, and its BACKFILL RECOVERY PROMPT reads the kit from
  either.

After updating, a repository does this on the update's task branch:

1. Commit the update on its own, with `git add -A`, so the removal of
   `.claude/kit/` is in it.
2. In each file the update listed, change every live instruction:
   `.claude/kit/` to `.claude/afk/`, `kit.sh` to `afk.sh`, `KIT_SOURCE` to
   `AFK_SOURCE`, and Claude-Kit to Artificial Field Kit. These are usually
   the Regenerate, Checks before merge and Secrets checks settings in
   `CLAUDE.md`, the authority file, a CI workflow or build script that
   runs `secrets.py` or `secrets-decrypt.mjs`, a list of the repository's
   files in its `README.md`, and the text above the first task in
   `TASKS.md` and above the session log in `HANDOFF.md`. A build host that
   decrypts by the old path fails once the update reaches the branch it
   builds, so its command changes in the same task.
3. Leave records as they are: closed task blocks, the session log,
   decisions, everything under `.claude/references/` and
   `.claude/imported/`, and earlier `kit-update-<version>` task names.
4. Run the Regenerate commands and the Checks before merge, and commit.

A task branch parked from before the update takes the move when its next
`session-open` merges the base in.

## 1.16.0

The BACKFILL RECOVERY PROMPT runs in a repository whose kit update has not
been promoted, and backfills the right repository.

- The prompt checks for the kit, checks its release and reads the kit
  files on the base, the integration branch when it exists, as
  `session-open` does. Before this it read the default branch, so a
  repository that had merged a kit update into its integration branch was
  told it needed an update until the owner promoted it.
- The prompt starts by choosing the repository: the one the session
  committed to or ran a kit open in, never one it only read from, and it
  asks when work landed in more than one. `references.md` says a backfill
  covers only what its session did in its own repository.

A repository needs to do nothing after updating.

## 1.15.0

What the first 1.14.0 backfills, four run at once, ran into.

- A backfill of its own session's work no longer waits for another
  backfill: only one run first in a new session, which lists past closes,
  keeps one at a time. It recognises a backfill branch as `backfill-` and
  twelve digits, so a task slug that starts `backfill-` is not one.
- The BACKFILL RECOVERY PROMPT approves recreating the integration branch
  and merging the backfill's own pull request into it, the two actions
  auto mode stopped.
- The conflict rule rebuilds two task blocks that git interleaved, each
  whole from its own side, in `HOUSE.md` and both skills.
- `session-close` step 8 detaches at the target once the task branch is
  gone, so a cloud end-of-turn hook does not call the merged branch
  unpushed.
- `session-open` step 3 and `session-close` step 10 report a task branch
  that is finished on its branch but not merged as a close perhaps still
  running, and never offer to merge another session's branch.

A repository needs to do nothing after updating.

## 1.14.0

`/session-open backfill` covers everything its session did, and a session
too old to run it can be brought back on track.

- Run in a session that has done work, a backfill writes one reference for
  everything that session did that no reference covers: work before the
  kit was installed, work outside any task, each close that wrote no
  reference, and a temporary session. Work a reference already covers is
  never written again, and with nothing uncovered it writes nothing. Before
  this, it covered only kit closes with no reference and a temporary
  session.
- A backfill reference is named `<yymmddhhmmss>-<slug>-bf.md`: the task's
  slug when the work has exactly one, otherwise one the session chooses
  from what it covers, cut at its end when `<slug>-bf` passes the Task slug
  limit. The time is the `handoff:` commit's for a past close, otherwise
  the last commit of the work that reached the default branch, or the time
  it is written. A past close counts as having a reference when a file
  under `.claude/references/` starts with its `handoff:` commit's time.
  The slug `unknown` and the reference named `temp` are gone.
- `session-open` step 2 follows the skill on disk when it differs from the
  one the session loaded, as it does in a session whose checkout was older
  than the base.
- `README.md` gains a Backfill section with the BACKFILL RECOVERY PROMPT,
  pasted into a session where `/session-open backfill` did not run as
  intended.

A repository needs to do nothing after updating. References already
written keep their names.

## 1.13.0

A repository keeps a bit for bit copy of what it is given, under
`.claude/imported/`.

- An import copies each reference it imports to
  `.claude/imported/<owner>/<repository>/<reference name>`, in the same
  commit, and its companion whole beside it, whatever the recipients. Its
  blocks are still placed only when the recipients `match`. Where
  Credentials is `none` or the repository is not confirmed private, the
  companion is not copied unless the developer explicitly says to, the one
  exception `HOUSE.md`'s credential rule now makes.
- Every file a developer uploads to a session working a task is copied to
  `.claude/imported/session-import/<name>-<yymmddhhmmss>.<ext>`, then used
  as any file a developer presents. A file of 100 MB or more, one holding a
  credential in plaintext, a companion the rule above would not copy, and
  one omitted or barred gets a placeholder of the same name ending `.md`,
  describing what it was and what it was for, with no credential value.
- A public or unconfirmed repository asks, for each reference from a source
  that is not public and each upload, whether to continue or omit it.
- `secrets.py rekey`, `decrypt` and `secrets-decrypt.mjs` skip
  `.claude/imported/`, and `secrets.py check` reads it without checking a
  copy's frontmatter against its name.

A repository needs to do nothing after updating.

## 1.12.0

The kit's default import fits the repository it imports into.

- `REFERENCES.md`'s Procedure section gains three lines the default reads.
  Subject home is a path pattern for a subject's file, where `*` stands for
  any one directory, default `imported/<subject-slug>.md`. New home format
  names a file and heading in the repository's own rules that say how a
  subject's file is written and where an added fact goes, default `kit
  default`. Confirm new homes, default `no`, makes the import ask where
  each new subject file goes, in one round before it imports anything.
- Turning imports on proposes the three values from the repository's own
  rules when they show how it keeps a file per subject. The Default warning
  shows only while all three are at their defaults, and its second option
  now asks for them.
- `/session-open import` waits only on a `task/import-<yymmddhhmmss>`
  branch, so a task whose slug merely starts with `import-` does not stop
  an import.

A repository needs to do nothing after updating: a `REFERENCES.md` without
the new lines reads them as their defaults.

## 1.11.0

`/session-open backfill` writes the reference the session it runs in is
missing, not one for every past close.

- Run in a session that has already done something, it writes a
  reference only for that session: a close the conversation ran that wrote
  none, or a temporary session that opened no task. A close that wrote its
  reference is never written again, and a task not yet closed is left to
  its close.
- Run as the first thing in a new session, it lists the past closes with
  no reference and asks which to write: all, some by number, or none.

A repository needs to do nothing after updating.

## 1.10.0

The words in a holder line are no longer the same as a task's status
words, and a task that will not be done has its own status.

- Holder lines read `HOLDING` where they read `ACTIVE`, and `DROPPED` where
  they read `INACTIVE`. `session-open` adds a `HOLDING` line when it takes a
  task, and `session-close` adds a `DROPPED` line above it.
- `DISMISSED` is a new task status, for a task that will not be done. Its
  `Dismissed:` line says why, in place of the `Dropped:` line, and it closes
  like `DONE`: it gets a `Closed:` date, moves to Closed Tasks and merges at
  close.

After updating, a repository renames the holder lines in its own `TASKS.md`
in a commit of its own on the update's branch, including the line its
update session added: `ACTIVE | ` at the start of a line becomes
`HOLDING | `, and `INACTIVE | ` becomes `DROPPED | `. It changes any
`Dropped:` line to `Dismissed:` and that task's `DONE` status to
`DISMISSED`. It also replaces the example lines above Open Tasks with the
template's. Until it does, `session-open` does not recognize an old
`ACTIVE` line as a task someone holds.

## 1.9.0

A task block's format reads the same in every file that writes it out.

- `HOUSE.md`'s holder line example lists `INACTIVE` above `ACTIVE`, newest
  first, as the `TASKS.md` template does.
- In the kit's own repository, `check.sh` fails when a fenced example of a
  task's field lines or holder lines in a kit-owned file, or in that
  repository's `TASKS.md`, differs from the template's.

A repository needs to do nothing after updating.

## 1.8.0

A new task is claimed before it is grilled, so no answer lives only in the
conversation.

- `session-open` step 5 claims a new task's branch and writes its block with
  what was asked, and step 6 grills it there before any other work. A slug
  that breaks the slug rule is still settled before the claim.
- Each grilling round is written into the task's block and pushed before it
  is asked. An answer replaces its question with a decision: who, the date,
  what was decided, what it changes and why. The block keeps no transcript.
- With no slug named but work described, `session-open` first offers any
  open task that already covers it, then claims a new one under a slug it
  chooses.
- A task grilling drops, or finds duplicating another, closes `DONE` with a
  `Dropped:` line and merges like any finished task. `TASKS.md` gains the
  line in its format.
- A task that closes `DONE` with questions still open in its block moves
  them to Open Questions in `HANDOFF.md`.

A repository needs to do nothing after updating. Its own `TASKS.md` may add
the `Dropped:` line to its format section by hand.

## 1.7.0

Session references: each session leaves its facts where another repository
can import them.

- `session-close` writes a session reference at every close, one per task
  branch, at `.claude/references/<yymmddhhmmss>-<task-slug>.md`, the time
  in UTC, from `.claude/kit/templates/reference.md`: the task and its
  commit range, the developer who ran the session as `<PREFIX> /
  <HANDLE>`, current state, decisions and who made them, verified facts
  with their sources, exact values, artifacts, gotchas, what is
  unverified, open questions, credentials by label, and one block per
  subject. It is
  never edited once committed. `HANDOFF.md` is written as before.
- The credentials a session handled go, each as a dated copy, into the
  reference's companion, `<yymmddhhmmss>-<task-slug>.secrets.md` beside it,
  by the Credentials setting's method. With `none`, or in a public
  repository, no companion is written, and the close says the repository
  has no method and offers to set one up. A value given in plaintext in
  the conversation draws a warning at close that the conversation still
  holds it.
- Credentials In Transit leaves the `HANDOFF.md` template and
  `session-close`: a value with no home yet lives in its session's
  companion. `secrets.py` still reads, checks and re-encrypts the heading
  where an older `HANDOFF.md` or an authority file keeps it.
- `secrets.py decrypt` and the Node decrypter skip `.claude/references/`,
  so a build never holds a second plaintext copy.
- `/session-open import` imports the references of the repositories
  `REFERENCES.md` names, on a task of its own, `import-<yymmddhhmmss>`.
  `import` is never a task slug, like `temp`. A repository turns imports
  on by the setup in `.claude/kit/references.md`, which writes
  `REFERENCES.md` from `.claude/kit/templates/REFERENCES.md`. Each import
  takes every reference a source's default branch added since the last
  one, one commit per reference, by the procedure the authority file or
  `CLAUDE.md` gives, or by the kit's default procedure, which says so until
  the owner dismisses the warning or writes their own. Credentials copy as
  they stand only when the source encrypts to the same keys; otherwise
  each arrives as a `TODO:`.
- `/session-open backfill` writes a reference for every past close that
  has none, found by its `handoff:` commit even after its branch is gone,
  on a task `backfill-<yymmddhhmmss>` that closes itself. A close the
  conversation ran is written from the conversation. Any other is
  transcribed from what committed files say about it, marked
  `Reconstructed:`, with every unsourced fact under Flagged As Unverified.
  `backfill` is never a task slug.
- One import runs at a time, and an imported question names the source's
  developer and repository.
- In a public repository a reference holds nothing the repository's rules
  keep private, and the first run asks the owner to turn on secret
  scanning with push protection.
- `check.sh` tests a companion, the decrypt skip and the sweep skipping a
  reference.

After updating: references start at the next close, with nothing to set.
Delete the Credentials In Transit heading from `HANDOFF.md` when it holds
`None.`. When it holds values and the Credentials setting is `kit
standard`, move each into a companion with `secrets.py place`, or into its
home, and delete the heading after. Keep the heading when the authority
file requires it. A public repository turns on secret scanning with push
protection. Imports stay off until the owner asks for them. Run
`/session-open backfill` once to give past sessions references, if an
importing repository should see them.

## 1.6.0

Several developers can work one repository, each in their own sessions, with
no hierarchy between them.

- Every developer is an owner: anyone with push access who works the
  repository with Claude Code and the kit may answer any question, promote
  the integration branch, take a kit update and answer for a stray. The
  Owner setting now only names the account that owns the repository.
- A session names the developer running it, `<PREFIX> / <HANDLE>`, under
  Developers in `HOUSE.md`: the handle from the session's GitHub account,
  asked for only when the access names none, and the prefix from the Claude
  Code Branch prefix as it shows in the branch the session started on. The
  prefix is never added to a branch name.
- Each task's block opens with holder lines, newest first: `session-open`
  adds `ACTIVE | <PREFIX> / <HANDLE> | <YYMMDD HHMMSS>` when it takes the
  task, and `session-close` adds an `INACTIVE` line above it, whatever the
  task's status. Times are UTC.
- `session-open` stops before taking a task whose top holder line is
  `ACTIVE` for another developer, says who holds it and since when, and takes
  it over only when the developer says so.
- The `session-open` report gains a `Holder:` line, and a `Questions:` line
  with the open questions that concern the task and a count of the rest.
  Every open question is shown to any developer who asks.
- `HANDOFF.md`: the Session Log gains a Developer column and keeps every row,
  so two closes that each add one merge cleanly. Decisions and open
  questions name the developer who made or raised them. The heading `Open
  Questions For <Owner>` becomes `Open Questions`.
- `session-close` step 9 refuses to promote while a pull request into the
  integration branch is open, which the deleted integration branch would
  otherwise retarget at the default branch.

After updating: in `HANDOFF.md`, rename `## Open Questions For <Owner>` to
`## Open Questions`, and add a Developer column to the Session Log, second,
writing `not recorded` in each existing row. In `CLAUDE.md`, nothing changes.
Existing tasks gain holder lines the next time a session takes them.

## 1.5.0

The secrets standard is self-sufficient: whatever the kit encrypts, the kit
decrypts, makes keys for, and checks.

- `secrets.py decrypt --out <dir>` decrypts for a build. It copies every
  `<slug>.secrets.md` to the same path under a directory git ignores, with
  each value in plaintext, reading the key from `SECRETS_AGE_KEY`. It fails,
  writing nothing, on a missing key or a value that will not decrypt, naming
  the file and label and never the value. With `SECRETS_CHECK_BUILD=1` it
  needs no key and no `age` tool and writes a placeholder for every value.
- `.claude/kit/secrets-decrypt.mjs` does the same in Node, with the
  `age-encryption` package, offered only when `secrets.py decrypt` cannot
  run on the build host. No other way of decrypting is documented: a
  repository neither serves names its own method in Credentials, with the
  reason.
- `secrets.py keys` prints the steps for making the keys on the owner's
  computer, three by default, the owner's, the build's and a recovery key,
  or the holders named after it. A repository that names another set
  overrules the default.
- A new Session Settings key, Secrets checks, holds the repository's own
  checks on its handling of credentials. `session-close` runs them with
  `secrets.py check`.
- Credentials defaults to `none`. The first run sets `kit standard` only
  when the repository already holds credentials or the owner says it will.
  Switching runs the setup in `.claude/kit/credentials.md`: privacy, the
  keys, the repository's own checks, CI, and the build.
- When anyone asks how to encrypt a value, the session gives
  `secrets.py steps` from that repository, never a fixed set of keys.
- `check.sh` tests `decrypt`, the check build, its refusals and `keys`, and
  the Node decrypter when `node` is installed.

After updating: add `- **Secrets checks:** none` after the Credentials line
in Session Settings. A repository whose Credentials is `kit standard` runs
steps 3 to 5 of Setting it up in `.claude/kit/credentials.md`, writing its
Secrets checks, adding them and `secrets.py check` to its CI, and wiring
`secrets.py decrypt` into its build when one reads the values. A repository
with Credentials `kit standard` that holds no credentials and will hold none
may change it to `none`, and says so in the update's commit. One whose
Credentials names its own method keeps it.

## 1.4.0

Credentials have a standard: age encrypted `<slug>.secrets.md` files.

- `.claude/kit/credentials.md` describes it. Each credential sits in a
  `<slug>.secrets.md` file under a bold label, its value encrypted on its own
  with age to every public key in `secrets-recipients.txt` at the repository
  root, as an armored block fenced and tagged `age`. A value whose home is not
  settled waits under Credentials In Transit in `HANDOFF.md` in the same form.
  Private keys stay with the owner and never pass through a session.
- `.claude/kit/secrets.py` does every operation: `set`, `place` for a block
  the owner encrypted on their own computer, `lock`, `encrypt`, `show`,
  `rekey`, `check`, and `steps`, which prints the owner's encryption steps
  with the repository's keys written in. It needs `python3` and the `age`
  command line tool, and `check` needs `python3` alone.
- The Credentials setting takes `kit standard`, and the `CLAUDE.md` template
  defaults to it. A repository keeps its own place or rule, or `none`, by
  naming it instead. `HOUSE.md` points `kit standard` at the new document,
  and still commits no credential in a repository not confirmed private.
- The first run settles Credentials as `kit standard` unless the repository
  already keeps credentials another way, and asks the owner for keys when a
  private repository has none. `session-close` stores each value by the
  tool and commits nothing while `secrets.py check` fails.
- `check.sh` tests the tool end to end, and CI installs `age` to run it.

After updating: a repository whose Credentials setting is `none` changes it
to `kit standard`, unless it keeps credentials another way or is public, and
says so in the update's commit. A private repository taking the standard with
no `secrets-recipients.txt` puts `Action needed:` in the reply for the owner to
make keys, as `.claude/kit/credentials.md` says under Setting it up. A
repository whose Credentials setting names its own method keeps it.

## 1.3.0

Five practices, and a pull request body, run inside the existing workflow.

- `.claude/kit/practices/` holds five practices, each read when its case
  comes up rather than by a command of its own: grilling, diagnosing,
  writing for agents, questionnaire, and retrospective. `HOUSE.md` names
  each one and when it applies, and ranks them last under Which file wins.
- `session-open` settles a new task by grilling before it writes the task's
  block, and settles a decision a block leaves open before the step that
  needs it. A task blocked on answers someone other than the owner must give
  gets a questionnaire.
- `session-close` diagnoses a failing Regenerate command or check before it
  parks a task, and writes each pull request body as a summary, evidence and
  a merge danger call, the promotion into the default branch included. It
  looks back over a session that met friction, turns each proposal into an
  open question offering a task, and reports the count on a new `Retro:`
  line.
- The practices are plain files inside `.claude/kit/`, so `kit.sh` and the
  install are unchanged, and no name can collide with a skill a repository
  or a harness already has. They are adapted under the MIT License from a
  public collection of agent skills, whose notice is in `NOTICE.md`.
- `check.sh` fails when a practice is named by nothing, or a pointer names a
  practice that does not exist.

After updating: nothing is required.

## 1.2.0

A temporary session promotes the integration branch.

- Asked in any words, a temporary session merges the integration branch into
  the default branch by `session-close` step 9's checks, with no task and no
  close. It waits for the checks GitHub reports on the integration branch's
  head, and stops on an open pull request into the integration branch, which
  GitHub would retarget at the default branch.
- A conflict stops it, and it offers a task to resolve it on a branch from
  the integration branch. A conflict means a commit reached the default
  branch outside the protocol.
- A promotion from a temporary session records nothing in the repository. The
  pull request is the record. `session-close` step 9 still promotes when the
  owner asks during a close.

After updating: nothing is required.

## 1.1.0

A temporary session, for questions without a branch.

- `/session-open temp` runs the fetch, the state reads, the kit check and the
  branch survey, then stays detached on the base and answers questions. It
  writes, commits and pushes nothing, a stray does not stop it, and in a
  repository new to the kit it does not run the first run.
- When a decision, a confirmed fact or a request for work comes up, it offers
  to keep it: to turn the session into a task, or to open a task for each
  topic to take up later. Each task's slug comes from the owner, or is
  proposed and asked. Its block records why it was made, what it is for, and
  the background, decisions and open questions from the session.
- From its first task on, it is an ordinary session that ends with
  `/session-close`. `session-close` says there is nothing to close for a
  temporary session that opened no task.
- `temp` is never a task slug, whatever the Reserved slugs setting says.

After updating: nothing is required. A repository with a task whose slug is
`temp` renames it, since `/session-open temp` no longer resumes it.

## 1.0.5

A credential is never committed in plaintext.

- `HOUSE.md` and `session-close` commit a credential only encrypted, by the
  method the Credentials setting names: the tool, and the public key or
  recipient it encrypts to. `session-close` no longer holds a value under
  Credentials In Transit "in full plaintext", which contradicted an authority
  file that requires encryption. A value bound for a committed file with no
  method named, or one the container cannot run, goes in the close report as
  the only copy, as a value does in a public repository.
- A value that spans more than one line, such as a private key or an
  encrypted block, is recorded whole in a fenced code block of its own, in
  `HANDOFF.md` and in the close report, never joined, wrapped, re-indented or
  put in a table.

After updating: a repository whose Credentials setting sends a value into a
committed file, `HANDOFF.md` included, adds the encryption method to that
setting in `CLAUDE.md`, or its sessions put every such value in the close
report instead. A value already committed in plaintext stays in the history
after it is replaced, so it is rotated, not only re-encrypted.

## 1.0.4

Hardening from the review before the repository went public.

- `kit.sh update` prints the source it is about to fetch and run, as
  `.claude/kit/MANIFEST` names it, so whoever reads the output can confirm
  it. The update prompt in `README.md` has the session check that source
  before updating, which works with every earlier `kit.sh`.
- `kit.sh` passes the source to `git clone` after `--`, so a source that
  begins with a dash cannot be read as an option.
- `session-close` creates the integration branch through its GitHub access
  when GitHub declines the push that would create it, which it does when the
  owner keeps their email address private and the default branch's head is a
  merge made under it.

After updating, nothing is required.

## 1.0.3

Fixes from the pilot's first full run, from install to a close that merged
into the default branch.

- `session-close` stays with a pull request until its checks finish, reading
  them about once a minute by a check-in a minute or two out, rather than one
  far out that leaves the merge idle after the checks pass.
- `session-close` merges the integration branch into the default branch
  without waiting for the checks to run again when they already passed on
  exactly that code: the integration branch's head is the task merge this
  session made after its checks passed, nothing else merged in between, and
  the default branch holds nothing the integration branch lacks. `HOUSE.md` says the checks must have
  passed on the code, not on the pull request itself.
- The session log row says a task reached the default branch when the owner
  asked for that merge in the session.
- The status blocks `session-open` and `session-close` report are one fenced
  code block with no backticks inside, which kept breaking apart.
- `session-open` says, when a newer release exists, that the update prompt is
  in the kit's README.

After updating, nothing is required.

## 1.0.2

Fixes from the third pilot attempt, which ran the first run to the end.

- The first run's reply no longer lists the Session Settings. They are in
  `CLAUDE.md`, and a value the owner is asked about carries its context in
  its question.
- Automatically delete head branches, and a preview host's branch list, are
  `Action needed:` notices at the top of the reply rather than questions,
  because the workflow needs them. `HOUSE.md` defines the notice.
- The first run asks about a rule in the repository's own files that
  contradicts `HOUSE.md`, such as a release process that pushes straight to
  the default branch, and leaves the file as it is until answered.
- `session-close` says on its `Branch:` line when a merged branch was not
  deleted, so the setting is turned on.

After updating, nothing is required.

## 1.0.1

Fixes from the first pilot, the first install outside the kit's own
repository.

- The first run settles more and asks less. The Owner is the account that
  owns the repository, read from its remote. The integration branch is
  `preview`, asked about only when a `preview` branch already exists. Checks
  before merge holds only commands the session's container can run, and
  leaves the rest to CI. A key the repository does not show takes its
  default. With nothing left to ask, the first run carries straight on.
- The first run removes a section of an existing `CLAUDE.md` that only
  repeats `HOUSE.md`, and asks only about one that says more. It adds the
  kit's paths to any file list a `README.md` or contributing guide keeps.
- While the first run waits for an answer, it leaves the install uncommitted
  and does not follow an instruction, such as an end-of-turn hook, to commit
  it to the branch the session was assigned.
- Each kit directory carries a `.gitattributes` keeping LF line endings. A
  checkout on Windows otherwise turns them into CRLF, which bash cannot run
  and which `kit.sh status` reports as a local edit.

After updating, nothing is required of a repository. A Windows checkout made
before the update keeps CRLF copies of the kit files the update did not
change, until they are checked out again: delete `.claude/kit/` and the two
skill directories and run `git checkout -- .claude`.

## 1.0.0

The first release, drawn from session skills that one repository had already
run for several weeks, with every value specific to that repository moved into
Session Settings.

- `HOUSE.md` holds the rules every repository shares: which file wins, the
  rules for every action, sessions and branches, the state files, the response
  format, and the definition of each Session Settings key.
- `session-open` and `session-close` read every repository-specific value from
  the `## Session Settings` section of `CLAUDE.md` and name none of their own.
- `session-open` has a first-run path for a repository new to the kit. It
  proposes the settings from what the repository shows, asks about the rest,
  and writes `CLAUDE.md`, `TASKS.md` and `HANDOFF.md` on the first task's
  branch.
- `session-open` reports the kit's version, and whether a newer one exists, on
  a `Kit:` line.
- A stray branch holding no commit the default branch lacks is reported without
  stopping the session, because nothing on it can be lost.
- An integration branch is a setting. With none, a finished task merges into
  the default branch and a blocked one parks.
- A credential goes where the Credentials setting sends it. With no rule, or in
  a repository not confirmed private, it is committed nowhere and handed to the
  owner in the report.
- `kit.sh` installs, updates and reports the kit, and will not overwrite a
  kit-owned file edited in place.
- `todo_sweep.py` collects every `TODO:` into `TODO.md` and refuses to
  overwrite a `TODO.md` it did not write.
