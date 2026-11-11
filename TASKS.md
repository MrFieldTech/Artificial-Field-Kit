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

### Carry The Site And Design Standards In The Kit

HOLDING | GRM / MRFIELDTECH | 261111 162605

**Slug:** `skill-incorporation`
**Status:** ACTIVE
**Opened:** 2026-11-11

**Why.** MrFieldTech, 2026-11-11, in a temporary session that found the
static site standard lives outside the kit: the kit should carry every
skill and standard MrFieldTech wants, so installing it into a new app or
site repository installs all of them. The request was split into three
tasks (decision 11): this one carries the site standard and the design
standard; `house-instructions` carries the general instructions and
Permission to Fail; `vendored-skills` mirrors the outside skills. What
this task was asked for, in MrFieldTech's words condensed:

1. **The site standard,** now held in another of MrFieldTech's
   repositories, carried by the kit so any site built where the kit is
   installed follows it, with these rules added:
   - every site font served locally, never fetched from Google Fonts;
   - session analytics never record keystrokes;
   - every user signup form verifies age, admitting no one under 13,
     with the birth date or age saved to the profile only if advised,
     since it adds personal information to the user database;
   - every email blast to subscribers carries a one-click unsubscribe and
     the company's official mailing address;
   - every user upload requires a checkbox stating the user owns or may
     use the file and agrees to the content policy, a content policy to
     be written, and a "Report Infringement" link to a form or email
     address for reporting uploaded content.
2. **Design rules,** in their own section: delete filler badges; drop
   redundant labels; unitalicize random header words; mono only where
   needed; use a design system; show the actual product; enlarge the main
   feature; group with spacing; make headlines specific; emphasize the
   call to action; add an accent color; keep icons consistent; remove
   embellishments; inner corner radius equals outer radius minus padding;
   improve text contrast; wrap headlines properly; align by eye, not
   pixels; use tabular numbers; add loading states; animate useful
   feedback.

**Facts, 2026-11-11.**

- The standard is 1,276 lines, version 1.2, updated 2026-10-03, written
  for static sites (HTML, one CSS file, one vanilla JS file, built by
  Vite with pnpm, served by Cloudflare Pages) with no backend, database,
  authentication or analytics. Its sections: Purpose, Owner, Access,
  Dependencies, Restart/Recovery (repository, layout, build, content and
  assets, configuration files, deployment, environments, secrets, the New
  site checklist, the Pre-launch verification checklist, known failure
  modes), Escalation, and a Modification Map holding a `CLAUDE.md`
  template for new site repositories. It names the owner's projects and
  accounts 8 times, so the kit's copy drops them by the project rules.
- Its FONT-2 allows a font host such as Google Fonts; request 1 removes
  that, leaving FONT-1, self-hosted WOFF2, as the rule.
- Its source repository's records make it the source of truth there; no
  session here writes to that repository.
- Signup forms, uploads and email subscriptions need a backend, which the
  static standard excludes.

**Decisions Made.**

- **The kit is the standard's source.** MrFieldTech, 2026-11-11. The kit
  holds it, generic, and the other repository's entry becomes a pointer
  to the kit, by a task in that repository once this releases.
- **One site standard, in sections.** MrFieldTech, 2026-11-11. A single
  source of truth covers creating any site. Its static section is the
  default target: a static site Cloudflare can host free. A site that
  needs more becomes a full featured site, its own section, which needs
  local hosting or paid Cloudflare hosting, and the standard warns when a
  site crosses that line.
- **Design is its own section.** MrFieldTech, 2026-11-11. The kit's
  standards are sections: design, the site standard (static and full
  featured subsections), and others as they come. MrFieldTech asked
  whether the design section would include the emilkowalski skills; it
  names them, below.
- **Age is saved as a confirmation only.** MrFieldTech, 2026-11-11. A
  signup saves that the user confirmed 13 or older, and when, through a
  neutral screen that does not hint at the answer. No birth date or age
  is stored, keeping personal information out of the user database.
- **The content policy is a kit template.** MrFieldTech, 2026-11-11, with
  a TODO for each site-specific fact.
- **Report Infringement links to a form or email address,** plus a
  checklist TODO for the copyright agent's details where the site
  operates in the United States. MrFieldTech, 2026-11-11.
- **The user rules apply only past static.** MrFieldTech, 2026-11-11. The
  age check, uploads, content policy, Report Infringement and email
  rules, and the questions that fill them, are asked about or applied
  only when a site grows past a static site into users and automated
  emails. A static site is never asked them.

- **The free plan sets the line.** MrFieldTech, 2026-11-11. The
  standard warns when a site needs a feature or a load outside
  Cloudflare's free plan, read from Cloudflare's pricing pages when the
  site is built, never from memory. A backend that fits the free plan,
  such as Pages Functions with a KV namespace, stays free and warns
  nothing.
- **Standards are a folder of sections.** MrFieldTech, 2026-11-11.
  `.claude/afk/standards/`, one file per section, `site.md` holding the
  static and full featured parts and `design.md`, read when their case
  comes up, as the practices are. Everything under `.claude/afk/` is
  kit-owned, so `afk.sh` installs the folder unchanged.
- **The design rules are expanded.** MrFieldTech, 2026-11-11. The session
  writes each of the twenty as a rule with its reason and how to check it,
  for MrFieldTech to review.
- **Analytics never capture keys or inputs.** MrFieldTech, 2026-11-11.
  Session analytics and replay tools never capture key events and mask
  every input field.
- **The design section names the emilkowalski skills** to use for which
  work, when they are installed. MrFieldTech, 2026-11-11.
- **Email carries both unsubscribe forms.** MrFieldTech, 2026-11-11. Each
  blast carries a visible unsubscribe link, the one-click unsubscribe
  headers mail providers read, and the mailing address, which is asked as
  a TODO once the site sends email.
- **The standard follows the kit's version.** MrFieldTech, 2026-11-11. Its
  separate number, 1.2, is dropped; changes go in the kit's
  `CHANGELOG.md`.

**Done so far.** `.claude/afk/standards/design.md` drafted: the twenty
rules as DESIGN-1 to DESIGN-20 in six groups, each with its reason and
check, and a table of the emilkowalski skills by work.

**Open questions, round 3.** Asked 2026-11-11; recommended answer first.

1. What does the full featured section fix beyond the user rules and the
   hosting warning? a. Nothing: each site chooses its backend, database
   and authentication and records them in its `CLAUDE.md`, and the
   section holds only rules that hold for any stack. b. One stack now,
   named by MrFieldTech.
2. Review of `design.md`: a. It holds as drafted. b. Changes, named by
   MrFieldTech.

**Stopping point.** Round 3 asked. Next: record the answers, then write
`.claude/afk/standards/site.md` from the source standard, generic, in
pieces: common rules, the static part, then the full featured part. Then
`HOUSE.md` gains a Standards section beside Practices, the `CLAUDE.md`
template names the standards, and the release: `VERSION` 2.1.0,
`CHANGELOG.md`, `README.md` and its `afk-update-2-1-0` slug.

### Add The Owner's General Instructions And Permission To Fail To The House Rules

**Slug:** `house-instructions`
**Status:** TODO
**Opened:** 2026-11-11

**Why.** MrFieldTech, 2026-11-11, split from `skill-incorporation`: the
kit should carry the general instructions MrFieldTech usually sets for
Claude, and a Permission to Fail section, so every repository that
installs it has them.

**Background.** `HOUSE.md` already forbids em dashes, sets a short
two-part reply with numbered questions, and says never invent a detail
and never assume a path, command, hostname or setting. MrFieldTech's
umbrella repository's `CLAUDE.md` carries response rules from their chat
projects that the kit lacks: lead with the answer, Yes or No first, no
affirmations or filler, no en dashes, complete commands, American
English, expand an acronym on first use.

**Decisions Made.**

- **Add both, rebuilt as the session advises.** MrFieldTech, 2026-11-11.
  Add Permission to Fail to `HOUSE.md`, and the general instructions
  MrFieldTech exported, uploaded as `Generic_Instructions.txt` (its
  placeholder is under `.claude/imported/session-import/`), rebuilt for
  the kit: merged with what `HOUSE.md` already says, generic, nothing
  said twice, and fitted to the response format.

**Permission to Fail, as MrFieldTech gave it.**

```
## Permission to Fail

You are allowed to fail. Accuracy and honesty matter more than completing the task.

1. Never invent facts, sources, citations, numbers, file contents, commands, settings, or features to make an answer look complete. If you don't know something, say "I don't know" or "I could not verify this."
2. Never present a guess as fact. Label anything uncertain as an assumption, estimate, or unverified, and say what would confirm it.
3. If you notice a factual error, a contradiction, or a flawed premise, in my request or in your own earlier work, point it out right away. Don't work around it quietly.
4. Make a real attempt first. Try other approaches, check your work, and use the tools you have before deciding something can't be done.
5. If you still can't reach the goal, stop and give me a short failure report instead of a workaround that only looks right:
   - What I asked for
   - What you tried
   - Where it broke down (the exact blocker: missing access, missing info, a tool limit, conflicting requirements, or a gap in your knowledge)
   - What would unblock it (something I can provide, a different approach, or a tool or connector to enable)
   - Any partial results you trust, clearly labeled as partial
6. A partial answer that is honestly labeled is better than a complete answer that is wrong. "This can't be done the way you described, and here's why" counts as a successful response.
```

**The exported general instructions, as uploaded.**

```
Generic Instructions

Purpose
These instructions guide Claude across any project or repository. Project-specific context, such as goals, people, platforms, tooling, figures, and current status, lives in the project's own documentation, not here.

Source of truth
- Read the project's documentation before answering instead of assuming or relying on earlier conversations.
- Never state names, figures, prices, versions, addresses, credentials, contact details, or tool choices from memory. If they are not documented, ask.
- Tooling and environments change over time. If a platform, service, or workflow is not documented, ask which one is in use rather than defaulting to one.
- If something I say conflicts with the documentation, point out the conflict and ask which is current.
- When a new fact is confirmed during a session, such as a file location, version, or decision, tell me so it can be recorded in the documentation.

Audience
- Do not assume formal training or familiarity with jargon. Explain technical concepts at a level a capable non-specialist can act on, unless the documentation or I indicate a higher level.

Instructions and commands
- When altering files or configurations, verify the file location if it is not already documented instead of depending on default locations.
- Verify versions before giving version-specific steps.
- Provide complete commands, including elevated privileges, the editor, and the full path. Example: sudo nano /etc/example/config.conf
- If a step depends on something that must be confirmed first, such as a version, a folder, or command output, give only the first few commands needed to verify it. Continue after I confirm. Provide all steps in a single message only when I specifically ask for it.
- Never write credentials into regular files or into content meant for documentation. Credentials belong only in whatever secure storage the project designates.

Decisions and evaluations
- When asked whether something is worth pursuing, give a clear verdict first, then the deciding factors, such as effort, cost, existing alternatives, risk, and fit with the people doing the work.
- Respect documented past decisions. If a recommendation reverses one, such as returning to a tool that was previously dropped, say so and address why it was dropped.
- Prefer approaches that automate repeatable work and reduce manual steps.

Response rules
- Lead with the answer.
- If the answer is yes or no, the first word is yes or no, then any necessary detail.
- Provide extra detail only if requested.
- Do not narrate your reasoning or restate my question back to me.
- Do not preface answers with affirmations (for example "Great question" or "You're right").
- No filler, and no summary of what you just said.
- If you are uncertain or the answer is conditional, say so in one line rather than hedging across a paragraph.
- Surface only what I need to act on or decide. Cut background I did not ask for.
- Never use an em dash, ever.
```

**Decisions left open.**

1. Where each part lands in `HOUSE.md`: its own sections, or merged into
   Rules for every action and Response format.
2. How the failure report fits the two-part reply: likely under What
   brevity never suppresses, as errors are.
3. Whether `HOUSE.md`'s "never use an em dash" also bans en dashes.

**Stopping point.** Not started. First step: draft the merged text into
`HOUSE.md` on this task's branch and grill the open decisions.

### Mirror Outside Skills And Agents Into The Kit

**Slug:** `vendored-skills`
**Status:** TODO
**Opened:** 2026-11-11

**Why.** MrFieldTech, 2026-11-11, split from `skill-incorporation`: these
skills should be mirrored into this repository, installed with the kit,
so they work in the IDE or Claude Code without reaching their own
repositories: `code-simplifier` from anthropics/claude-plugins-official,
cloudflare/security-audit-skill, mukul975/Anthropic-Cybersecurity-Skills
and emilkowalski/skills.

**Facts, 2026-11-11.**

- `code-simplifier` is a Claude Code agent
  (`plugins/code-simplifier/agents/code-simplifier.md`), not a skill.
  Apache License 2.0. Upstream at `43fd1f9`. A copy also sits in that
  repository's `pr-review-toolkit` plugin.
- cloudflare/security-audit-skill: one skill, `skills/security-audit`,
  MIT, 372 KB, upstream at `c1c8a8c`.
- mukul975/Anthropic-Cybersecurity-Skills: 818 skills, 49 MB, Apache
  License 2.0, upstream at `54a7988`. Claude Code lists every installed
  skill's name and description in each session's context, so 818 in
  every repository would cost context in every session.
- emilkowalski/skills: 18 skills, MIT, 496 KB, upstream at `715c180`.
- Both licenses allow mirroring into a public repository with the
  license and any notice kept.

**Decisions Made.**

- **`code-simplifier` is mirrored as an agent** under `.claude/agents/`.
  MrFieldTech, 2026-11-11. A Claude Code agent is used when the session
  hands it work by the Agent tool, which it does on its own when the
  work matches the agent's description, or when the owner asks for it by
  name, such as "run the code-simplifier agent on this change".
- **The cybersecurity skills are mirrored whole and installed only by
  name.** MrFieldTech, 2026-11-11. All 818 are kept in this repository;
  a repository installs the ones its Session Settings list.
- **All 18 emilkowalski skills install everywhere.** MrFieldTech,
  2026-11-11. The mobile and Swift ones were first recommended left out
  only because no mobile work was seen, not for quality or size, and
  MrFieldTech will build mobile apps, so they install now.

**Decisions left open.**

1. Where the mirrors live in this repository, and how each upstream's
   license, notice and pinned commit are recorded.
2. How a mirror is refreshed from upstream: a script recording the
   commit, run as its own release.
3. The Session Settings key that lists the cybersecurity skills a
   repository installs, its name and default, defined in `HOUSE.md` and
   given a default in the `CLAUDE.md` template.
4. Whether `afk.sh install` and `update` treat mirrored files as
   kit-owned, recorded in `MANIFEST`.
5. Whether the cybersecurity skills need a review before mirroring, since
   some hold offensive security procedures.

**Stopping point.** Not started. First step: grill the open decisions,
then mirror one source at a time, one commit each.

### Build The Private Terms List

**Slug:** `private-terms`
**Status:** TODO
**Opened:** 2026-11-11

**Why.** MrFieldTech, 2026-11-11, at the close of `unique-name`: the
`AFK_PRIVATE_TERMS` repository secret should be built out. Not urgent.

**Background.** `check.sh` section 1 reads the secret in CI, or an
untracked `.private-terms` file locally, as one extended regular
expression matched case-sensitively by `grep -E`, and fails when it
matches anything in the kit-owned files, `.claude/references/` or
`.claude/imported/`. Without it the names part is skipped with a line in
the log. MrFieldTech found on 2026-11-11 that the secret, then named
`KIT_PRIVATE_TERMS`, never existed, so CI has never checked names. A
session reads the same list from its environment to redact a reference at
close, which needs it set as an environment variable as well, where it is
stored in plain text.

**Decisions left open.**

1. Which terms go in: the names of MrFieldTech's other projects and
   repositories, their domains and hosts, the names of clients and other
   people. Not `MrFieldTech`, which this repository's references name as
   the developer.
2. Whether the list is also set in the cloud environment, so closes here
   can redact.
3. Whether CI should fail, rather than skip, when the secret is empty, so
   a missing list is never silent again.

The first CI run with the list may fail on a name already in the
repository; fixing that is part of the task.

**Stopping point.** Not started. First step: MrFieldTech writes the list;
the session tests it against `bash check.sh` before it is saved.

## Closed Tasks

### Give The Kit A Distinctive Name

DROPPED | GRM / MRFIELDTECH | 261111 042752
HOLDING | GRM / MRFIELDTECH | 261110 225422

**Slug:** `unique-name`
**Status:** DONE
**Opened:** 2026-11-10
**Closed:** 2026-11-11

**Why.** MrFieldTech, 2026-11-10, ran `/session-open unique-name`: the
name Claude-Kit is too generic, anyone could use it for their own project,
and once other developers join the owner's projects the kit should have its
own name that identifies it. It may relate to MrFieldTech or MFT, or be
unrelated; it need not represent MrFieldTech. This answers the open
question in `HANDOFF.md`, "Should the kit take a more distinctive name?",
raised 2026-10-15.

**Facts, 2026-11-10.**

- The name appears in five places in kit-owned files: the first line of
  `HOUSE.md`, the `description` of both skills, and `kit.sh`'s header
  comment and its install message. It appears in `README.md` throughout,
  including the repository URL in the install, update and backfill
  recovery prompts, and in this repository's `CLAUDE.md`.
- The project rule says nothing the kit installs names a person or
  account. A name carrying MrFieldTech or MFT would sit in those five
  kit-owned places in every repository.
- Elsewhere the kit calls itself "the kit", and its paths are
  `.claude/kit/`, `kit.sh`, `KIT_PRIVATE_TERMS` and `kit-update-<version>`
  slugs, none of which carry the name.
- Each installed repository's `.claude/kit/MANIFEST` records the source
  URL, and the README's update prompt, item 2, stops unless that URL is
  `https://github.com/MrFieldTech/Claude-Kit` in any letter case. Renaming
  the GitHub repository therefore needs the update prompt to accept the
  old URL as well. GitHub is believed to redirect clones of a renamed
  repository's old URL; not verified here.
- A GitHub repository search on 2026-11-11 found no repository named
  Artificial Field Kit; the seven matches for the words are unrelated. "AFK"
  alone is crowded among agent tools, such as `afk-code` with 90 stars and
  `agent-afk` with 63.
- `.claude/kit` appears 242 times across 20 tracked files, and each
  installed repository's `CLAUDE.md` imports `@.claude/kit/HOUSE.md`.

**Decisions.**

- **The kit is named Artificial Field Kit, AFK for short.** MrFieldTech,
  2026-11-11. Field nods to MrFieldTech without naming the account, so the
  project rule holds, and AFK is what a developer is while an agent codes.
  Kit is in the name, so "the kit" and "kit" stay as they are in prose.
  The full name is the distinctive part; AFK alone is not.
- **The rename reaches everything it can.** MrFieldTech, 2026-11-11. Every
  current mention of Claude-Kit changes, including the GitHub repository,
  which MrFieldTech renames. History keeps the old name where it records
  what happened: `CHANGELOG.md` entries before this release, session
  references and closed task blocks. No skill or kit-owned file says
  Claude-Kit afterwards. The release says how an installed repository
  makes the change so that nothing is lost and everything works after it.

- **The names in paths change with it.** MrFieldTech, 2026-11-11.
  `.claude/kit/` becomes `.claude/afk/`, `kit.sh` becomes `afk.sh`,
  `KIT_SOURCE` becomes `AFK_SOURCE`, `KIT_PRIVATE_TERMS` becomes
  `AFK_PRIVATE_TERMS`, and the update slug `kit-update-<version>` becomes
  `afk-update-<version>`. The update moves an installed repository's files
  and the import in its `CLAUDE.md`. The skill directories carry no name and
  stay. "The kit" stays in prose.
- **The repository is `MrFieldTech/Artificial-Field-Kit`.** MrFieldTech
  renamed it on 2026-11-11. The old URL still answers: `git ls-remote` and a
  clone of `https://github.com/MrFieldTech/Claude-Kit` returned the same
  `HEAD` as the new URL that day.
- **The release is 2.0.0.** MrFieldTech, 2026-11-11. An installed
  repository must do more than run the update.
- **The update moves a repository onto the new URL.** MrFieldTech,
  2026-11-11. The update prompt accepts the old or the new URL in the
  `source:` line, and the update records the new URL in the `MANIFEST`.

**Plan.**

- A 1.x `kit.sh update` looks for `.claude/kit/kit.sh` in the source and
  runs it as the installer. The source keeps a small forwarder there, which
  is not kit-owned and is never installed: it maps the old URL to the new
  and runs `.claude/afk/afk.sh install`. A kit-owned file never holds the
  URL, by the project rule.
- `afk.sh install`, finding a 1.x install in the target, checks the old
  `MANIFEST` for local edits, removes `.claude/kit/`, installs
  `.claude/afk/`, rewrites the `@.claude/kit/HOUSE.md` import in
  `CLAUDE.md`, and lists every other file that still mentions
  `.claude/kit/` or `kit.sh`, for the updating session to fix by the
  `CHANGELOG.md` entry.
- `check.sh` tests that path: a 1.16.0 install updated through the
  forwarder ends with `.claude/afk/`, the new URL, the import moved, and
  nothing lost.

**Done.** Release 2.0.0. `.claude/kit/` moved to `.claude/afk/` and
`kit.sh` to `afk.sh`, with every live mention of Claude-Kit, the old paths
and `KIT_` names changed; `CHANGELOG.md` entries before 2.0.0, session
references, closed task blocks and `HANDOFF.md`'s records keep the old
name. `afk.sh install` moves a 1.x install, and `.claude/kit/kit.sh` stays
in this repository, not kit-owned, as the forwarder a 1.x `kit.sh update`
runs. `todo_sweep.py` accepts a `TODO.md` its 1.x self wrote. `check.sh`
tests the move, and a real 1.16.0 install updated through its own
`kit.sh update` to 2.0.0 in a scratch repository on 2026-11-11, reporting
`2.0.0, current` after. `bash check.sh` passed on `f2754e8`. CI reads
`AFK_PRIVATE_TERMS`. MrFieldTech found on 2026-11-11 that no
`KIT_PRIVATE_TERMS` secret ever existed, so CI has never checked names;
`private-terms` builds the list. `CLAUDE.md` gained a project rule keeping
the forwarder.

### Point The Backfill Recovery Prompt At The Right Branch And Repository

DROPPED | GRM / MRFIELDTECH | 261110 210147
HOLDING | GRM / MRFIELDTECH | 261019 011740

**Slug:** `backfill-problems`
**Status:** DONE
**Opened:** 2026-10-19
**Closed:** 2026-11-10

**Why.** MrFieldTech, 2026-10-19, ran `/session-open backfill-problems`
with the reply of a session in another of the owner's repositories that
was given the BACKFILL RECOVERY PROMPT from `README.md`. That repository
had taken a kit update on a task branch merged into its integration
branch, not yet promoted to its default branch. The session had a second
repository attached, only to read a standard from it. It stopped, and its
reply offered the second repository as a place the backfill could go,
which MrFieldTech did not expect.

**Facts, 2026-10-19.**

- The prompt's items 2 to 4 check for the kit, check its release and read
  the kit files on the default branch only. A kit update merges into the
  integration branch at close and reaches the default branch only when the
  owner promotes it, so a repository that has just updated fails item 3
  until the promotion. The session reported release 1.2.0 on the default
  branch of the repository it worked in.
- `session-open` itself works from the base, the integration branch when it
  exists, so the skill would have run the backfill had the prompt let it
  reach step 5.
- The prompt says "this repository" and never says which one when a
  session has more than one. The session found an update branch in the
  second repository, not merged into its default branch either, and so
  offered it as an option, and its second action line told the owner to
  merge it there.

**Decisions.**

- **The recovery prompt works from the base.** MrFieldTech, 2026-11-10. It
  checks for the kit, checks its release and reads the kit files on the
  integration branch named in `CLAUDE.md` when that branch exists on the
  remote, else on the default branch, as `session-open` step 2 does. An
  update merged into the integration branch and not yet promoted is enough
  to backfill, so the owner never has to promote just to run one.
- **A backfill goes into the repository this session worked in.**
  MrFieldTech, 2026-11-10. With more than one repository in the session,
  it is the one the session committed to or ran a kit open in. A
  repository it only read from is never written to, and when work landed
  in more than one, the session asks which. `references.md` says a backfill
  covers only what the session did in its own repository.

**Done.** Release 1.16.0: the recovery prompt's new item 1 chooses the
repository, item 3 finds the base, and items 4 and 5 check and read the kit
there. `references.md` gains Its own repository only under Backfilling.
`bash check.sh` passed on `333e4c2`.

### Answer What The First 1.14.0 Backfills Raised

DROPPED | GRM / MRFIELDTECH | 261019 005145
HOLDING | GRM / MRFIELDTECH | 261018 042553

**Slug:** `backfill-questions`
**Status:** DONE
**Opened:** 2026-10-18
**Closed:** 2026-10-19

**Why.** MrFieldTech, 2026-10-18, ran `/session-open backfill-questions`
with four uploads: the replies of four sessions in another of the owner's
repositories that ran 1.14.0's backfill, through the BACKFILL RECOVERY
PROMPT, at the same time. Each ended with questions for the owner. This
task settles what in them the kit should change.

**Facts from the uploads, 2026-10-18.** Four backfills ran in one
repository within a minute of each other, each in a different past session,
and each wrote its own `-bf` reference. None duplicated another. Each
placeholder under `.claude/imported/session-import/` ending `261018042553`
describes one upload.

1. **One at a time did not hold.** Each checked Backfill step 1 in
   `session-open` within seconds of the others, found no `task/backfill-`
   branch, and claimed. Nothing was lost, because a backfill run in a
   session that did work covers only that session, and two sessions cannot
   cover the same work. Only a backfill run first in a new session, which
   lists past closes, can write what another writes.
2. **Step 1 matches any `task/backfill-` branch.** It would also stop on
   this task's own branch, `task/backfill-questions`, which the slug rule
   allows. Import's check matches `import-` and twelve digits only.
3. **The integration branch was absent and could not be recreated.**
   Promotion had deleted it. `session-close` step 8's push and its GitHub
   API fallback were each denied by auto mode, as `[Production Deploy]` and
   as a shared-resource change. Three sessions stopped; one session's close
   got through and the others then found the branch there. The uploads do
   not show how that one created it.
4. **Merging a session's own pull request was denied once,** as `[Merge
   Without Review]`, and merged without a block in the three others. The
   BACKFILL RECOVERY PROMPT names neither action, so each block cost a
   round trip and an approval sentence.
5. **Every merge of the integration branch conflicted in `TASKS.md` and
   `HANDOFF.md`.** Each side had added a whole task block at the top of
   Closed Tasks, and git interleaved them around the lines they share,
   `**Status:** DONE`, `**Opened:**` and `**Closed:**`. Keeping both by
   deleting the markers gives malformed blocks, so each session rebuilt the
   blocks whole by hand. The conflict rule in `HOUSE.md` says only "keep
   both".
6. **The end-of-turn hook called a merged task branch unpushed.** After
   step 8, GitHub deleted the remote branch and the local branch had no
   upstream. Two sessions declined to push, correctly, since a push would
   recreate a merged branch, and detached at the integration branch.
7. **Sessions reported each other's branches as abandoned.** A backfill's
   branch is `DONE` with a `DROPPED` line from its own step 3 until its
   step 8 merges it, so a survey in that window cannot tell a running close
   from one that stopped. Two sessions offered to merge another session's
   branch.
8. **Each session asked about promotion,** by step 9, and one proposed
   waiting until all four had merged. Nothing in the kit is wrong there.
9. **1.14.0's backfill and recovery prompt worked** in sessions that did
   work with no close, verifying part of Flagged As Unverified.

**Decisions made.** MrFieldTech, 2026-10-19, round 1 of grilling.

- A backfill of its own session's work skips one at a time, because no
  other backfill can cover that session; only one run first in a new
  session, which lists past closes, keeps it.
- Backfill step 1 recognises a backfill branch as `backfill-` and twelve
  digits and nothing else, as Import does, so a task slug such as
  `backfill-questions` is not mistaken for one.
- The BACKFILL RECOVERY PROMPT approves by name recreating the integration
  branch at the default branch's head and merging the backfill's own pull
  request into it, so auto mode does not stop the self-close for an
  approval sentence.
- When both sides added whole task blocks and git interleaved them, the
  conflict rule rebuilds each block whole from its own side and checks it
  against the Format in `session-close`, in `HOUSE.md` and both skills.
  Round 1 offered `check.sh`'s block check for this, but `check.sh` is not
  installed in other repositories and checks only fenced examples, so the
  Format is the check.
- `session-close` step 8 detaches at `origin/<target>` once the task branch
  is confirmed gone, after MrFieldTech confirmed the backfill runs the
  close: Backfill step 5 runs `session-close` steps 1 to 11, so the hook
  fired inside the backfill.
- A task branch that is `DONE`, `DISMISSED` or `BLOCKED` on its own branch
  but not on the base is reported as not merged, its close perhaps still
  running, with its top holder line, and no session offers to merge another
  session's branch. `session-open` step 3 and `session-close` step 10.
- All of it is one release, 1.15.0.

The frontier is empty after round 1.

**Done, 2026-10-19.** Release 1.15.0, as decided: `session-open` step 3,
step 5's conflict rule and Backfill step 1; `session-close` step 8's
conflict rule and detach, and step 10; `HOUSE.md`'s conflict rule; item 8
of the BACKFILL RECOVERY PROMPT and the update block in `README.md`;
`CHANGELOG.md` and `VERSION`. `bash check.sh` passed on the release commit.

**Closed, 2026-10-19.** Merged into `preview` and then `main` at
MrFieldTech's request.

### Backfill Work That Ran No Kit Close

DROPPED | GRM / MRFIELDTECH | 261017 204755
HOLDING | GRM / MRFIELDTECH | 261017 064044

**Slug:** `backfill-no-close`
**Status:** DONE
**Opened:** 2026-10-17
**Closed:** 2026-10-17

**Why.** MrFieldTech, 2026-10-17: several old sessions in another of the
owner's repositories ran `/session-open backfill` expecting it to write a
reference from the conversation for what the session did, and none did.
MrFieldTech uploaded four of the replies; each is kept as a placeholder
under `.claude/imported/session-import/`.

**Facts looked up, 2026-10-17.**

- Three of the four sessions had no `/session-open` at all. Their checkout
  predated the kit, and Claude Code registers skills from the checkout when
  a session starts, so the command did not exist there. One found the skill
  on the default branch and said a fresh session was the only way to run it.
- The fourth ran the skill at 1.13.0 and reported nothing to cover. By
  Backfilling, What a backfill covers, in `.claude/kit/references.md`, a
  session that has done work covers only kit closes it ran with no
  reference, and a `temp` session. Its work predated the kit and ran no
  close, so nothing qualified. That rule is from `backfill-intent`, 1.11.0.
- A kit close made before references existed, 1.0.0 to 1.6.0, already
  qualifies: it made a `handoff:` commit and added no reference, so Past
  closes lists it in a new session, and a session that ran it covers it
  from the conversation. What stops the second case is only that such a
  session's checkout holds no skill that can run a backfill.

**Decisions.**

- **The slug is `backfill-no-close`.** MrFieldTech, 2026-10-17, since
  `backfill-troubleshooting` is 24 characters and the limit is 23.
- **A backfill writes a reference for everything its session did, unless
  that session already has one.** MrFieldTech, 2026-10-17, replacing an
  earlier answer that covered only pre-kit work. Run in a session that has
  done work, the backfill writes from the conversation for all of it,
  whether or not it closed under the kit, and a kit close that wrote no
  reference gets one. There is no cutoff at the kit's arrival: what was
  done before the kit counts like what was done after. It writes nothing
  when a reference for that session already exists. This changes What a
  backfill covers, which since `backfill-intent` covered only kit closes
  with no reference and a `temp` session.
- **A backfill reference is named `<yymmddhhmmss>-<slug>-bf.md`.**
  MrFieldTech, 2026-10-17. The time is the UTC commit time of the session's
  last commit that reached the default branch, so it sorts where the work
  ran, or the time it is written when there is none. The slug is the task's
  slug when the work has one, a past close's included, and otherwise one the
  session chooses from what the reference covers, with no question to the
  developer. `-bf` marks it a backfill. When the slug and `-bf` together
  pass the Task slug limit, the end of the slug's last word is cut to fit,
  as `sonarr-update-emails` becoming `sonarr-update-ema-bf`.
- **A backfill in a session that already has a reference writes one for
  only the work no reference covers.** MrFieldTech, 2026-10-17, so nothing
  is lost and nothing is written twice. It writes nothing when every piece
  of the session's work is already covered.
- **A backfill writes one reference for its whole session,** however many
  kit closes and other pieces of work it holds. MrFieldTech, 2026-10-17.
- **The developer types only `/session-open backfill`.** MrFieldTech,
  2026-10-17. A session that cannot run the skill finds the instructions
  in `README.md`, of whatever length the job needs, and is never handed a
  pasted prompt.

**Facts looked up after round 2, 2026-10-17.**

- Claude Code loads skills and `CLAUDE.md` from the checkout when a
  session starts. A session whose checkout predates the kit holds nothing
  that names the kit, the README or the skill, so no file the kit writes
  reaches it until the session reads it of its own accord. In the uploads,
  two such sessions searched only their own checkout and stopped; one
  fetched the default branch and found the skill.
- A session whose checkout holds an older kit does run `session-open`,
  and step 2 then checks out the base, which puts the current skill on
  disk. It follows the older text it loaded at start.
- `sonarr-update-emails-bf` is 23 characters, which the limit of 23 allows.

- **A session that cannot run the backfill gets the BACKFILL RECOVERY
  PROMPT from the kit's README.** MrFieldTech, 2026-10-17. The developer
  always types `/session-open backfill` first, and when the session plainly
  does not know what to do, pastes the prompt, of whatever length the job
  needs, which has it read the current kit from the default branch and
  follow Backfill. It replaces the decision that the developer never pastes
  a prompt.
- **A session that loaded an older `session-open` follows the one on
  disk.** GRM / MRFIELDTECH, 2026-10-17, chosen by the session as part of
  the recovery: once step 2 checks out the base, a skill on disk that
  differs from the loaded one is read and followed, so a session with an
  older kit needs no prompt.
- **The slug is cut only when `<slug>-bf` passes the Task slug limit.**
  MrFieldTech, 2026-10-17. `sonarr-update-emails-bf` is 23 characters and
  stays whole under a limit of 23.

The frontier is empty after round 3.

**Done, 2026-10-17.** Release 1.14.0 in `.claude/kit/references.md`,
Backfilling; `session-open` step 2 and Backfill; `HOUSE.md`; a Backfill
section in `README.md` with the recovery prompt; `CHANGELOG.md` and
`VERSION`. `bash check.sh` passed on the release commit.


### Keep A Verbatim Copy Of Each Imported Reference

DROPPED | GRM / MRFIELDTECH | 261017 032428
HOLDING | GRM / MRFIELDTECH | 261017 023701

**Slug:** `import-file-process`
**Status:** DONE
**Opened:** 2026-10-17
**Closed:** 2026-10-17

**Why.** MrFieldTech, 2026-10-17: an import parses each new session
reference and places its facts in the importing repository's own files,
and handles the companion's credentials. MrFieldTech proposes that it also
copy the reference itself bit for bit, perhaps into `.claude/imported/`
beside `.claude/references/`, and asked for the pros and cons.

**Facts looked up, 2026-10-17.**

- The kit is at 1.12.0. `.claude/kit/references.md`, The kit default
  procedure, step 7: "Nothing is deleted. The reference stays in its
  source." No copy of the reference is kept in the importing repository.
  A new home records the references it came from by name and repository.
- The companion is not copied as a file. Under `kit standard`, private,
  with recipients `match`, each label's block is copied as it stands into
  the subject home's `.secrets.md` by `secrets.py place`. Otherwise a
  `TODO:` stands in for the value.
- What is new is found by `git diff --diff-filter=A` under the source's
  `.claude/references/`. A copy kept outside `.claude/references/` is never
  read as one of the importer's own references, so two repositories
  importing each other would not send copies back.
- `.claude/references/` is project-owned and skipped by the TODO sweep and
  both decrypters. A new directory would need the same exclusions in
  kit-owned files, and this repository's `check.sh` private-terms check
  would need to cover it.
- Reference names are `<yymmddhhmmss>-<task-slug>.md` per repository, so
  two sources can hold the same name.
- Imports are not on in any repository known here, so no repository holds
  an import done without a copy.
- A change to kit-owned files is a release: 1.13.0.

**Pros and cons, as given to MrFieldTech.**

- For: provenance, since a reader can check what the source said against
  what the import wrote, conflicts included; it survives the source being
  deleted, made private or access lost; a later change of procedure or of
  the three values can re-import from the copies without attaching the
  sources; a home's `Sources:` line resolves inside the repository; small,
  immutable files.
- Against: every imported fact is in the repository twice, and a session
  searching it may take a copy's stale or conflicting fact as current; the
  sweep, both decrypters and `check.sh` need the new directory excluded or
  covered; a copy into a public repository from a private source publishes
  the whole reference at once; names collide across sources without a
  directory per source; a copy is more source text in the repository that
  a session must treat as data, never instructions.

**Decisions made.** MrFieldTech, 2026-10-17, round 1 of grilling.

- Every import keeps a verbatim copy of each reference it imports,
  committed with that reference's import and never edited afterwards. It
  is the record of what the source said, kept even if the source is lost.
- The copy goes at `.claude/imported/<owner>/<repository>/<reference
  name>`, `<owner>/<repository>` being the source as GitHub names it, such
  as `MrFieldTech/Claude-Kit`. `.claude/references/` keeps no such
  directories; only the copies need them, so names cannot collide across
  sources.
- The companion is copied whole too, always, beside the reference copy.
  Its blocks are then placed into the subject's home only when the keys
  `match`, as before.
- When the importing repository is public or not confirmed private and
  the source is not public, the session warns of it and the developer
  chooses to continue or to omit what may be private.
- The copy belongs to every import procedure, as part of The import, not
  only the kit default.
- Files uploaded directly to the Claude Code session are imported too: each
  copied bit for bit into `.claude/imported/session-import/`, then parsed and
  placed like any reference.

**Facts looked up after round 1, 2026-10-17.**

- `HOUSE.md`: a credential is committed nowhere "in a repository not
  confirmed private" or with no method named, even encrypted. A companion
  copy is encrypted credentials, so round 1's "always" meets that rule.
- `secrets.py rekey` re-encrypts every tracked `*.secrets.md`, references'
  companions included, and refuses when a block will not decrypt with the
  key given. A companion copy encrypted to another repository's keys would
  make every rekey fail. `secrets.py decrypt` and `secrets-decrypt.mjs`
  skip only `.claude/references/`.
- The TODO sweep already skips everything under `.claude/`, so copies need
  no change there.
- A reference's own `**Repository:**` line names its source, but an
  uploaded file carries no proof of it, and the session has no
  `secrets-recipients.txt` for it to compare keys with.

**Decisions made.** MrFieldTech, 2026-10-17, round 2 of grilling.

- Where Credentials is `none` or the repository is not confirmed private,
  the companion copy is not made and the developer is told why. The
  reference copy still is, subject to the warning below. A developer's
  explicit instruction overrides it, which needs an exception in
  `HOUSE.md`'s credential rule.
- `secrets.py rekey`, `decrypt` and `secrets-decrypt.mjs` skip
  `.claude/imported/` entirely, so copies stay as the source encrypted them.
- The public-repository warning is per reference, asked in one round
  before anything is imported, with the homes questions. Continue copies
  it and places its facts; omit does neither, and marks it `omitted` in
  the task's block. A source whose visibility cannot be read, and every
  upload, counts as not public.
- An import reads only a source's `.claude/references/`, the references
  and their companions, never its `.claude/imported/`. `.claude/imported/`
  is the repository's own record, not for other repositories.
- Every file uploaded to a session is copied bit for bit to
  `.claude/imported/session-import/<original file name>-<yymmddhhmmss>.<ext>`.
  Uploads belong to this repository alone, so there is no
  `<owner>/<repository>` level, and the time keeps names from colliding.
- An uploaded companion's keys are treated as `differ`, unless the
  developer says where it came from and gives that source's
  `secrets-recipients.txt`; the session asks when they have not said.
- No table of uploads in `REFERENCES.md`: with the copy per session upload,
  round 2's question 7 no longer applies.

**Decisions made.** MrFieldTech, 2026-10-17, round 3 of grilling.

- Every session working a task copies its uploads. A temporary session
  copies nothing, says the uploads are kept only if it opens a task, and
  copies them onto that task's branch when it does.
- An upload holding a credential in plaintext is not copied. The session
  says so and handles each value by the Credentials setting and the
  credential rule.
- An upload, a session reference or its companion included, is used as
  Claude Code uses any file a developer presents: reviewed, read,
  understood, and its data put where it belongs. It is not run through
  the Import procedure; `/session-open import` stays for sources. The
  copy is the record that it was given.
- `<ext>` is the last extension, except `.secrets.md`, kept whole:
  `x.secrets.md` becomes `x-<yymmddhhmmss>.secrets.md`, `a.tar.gz` becomes
  `a.tar-<yymmddhhmmss>.gz`, and a name with no extension takes the time at
  its end.
- The time is the UTC time the session copies them, one time for the files
  of one message, so files uploaded together keep matching names.
- A file of 100 MB or more, which GitHub refuses, is not copied. The
  session still reads it, and writes in its place a file
  `<original file name>-<yymmddhhmmss>.md` saying why it was not copied.

**Decisions made.** MrFieldTech, 2026-10-17, round 4 of grilling.

- The placeholder for an upload not copied says more than why. It names
  the original file, its name, type and size, what it held, what it was
  meant for or tried to provide, and where the session put its data,
  without any credential value. This supersedes round 3's placeholder that
  said only why.
- Every upload not copied gets that placeholder: one too large, one
  holding a plaintext credential, one omitted at the public-repository
  warning, and a companion not copied where Credentials is `none` or the
  repository is not confirmed private. An omitted one describes its
  purpose without the content omitted.
- `check.sh` scans `.claude/imported/` for `KIT_PRIVATE_TERMS` here as it
  scans `.claude/references/`. An upload holding a private term gets the
  placeholder instead of a copy, with no private term in it.
- This repository never imports from other repositories, so it never has a
  `REFERENCES.md`. Written into `CLAUDE.md` as a project rule.

The frontier is empty after round 4.

**Done, 2026-10-17.** Release 1.13.0, as decided: `HOUSE.md` points at
Copies and makes the encrypted companion copy the one exception to its
credential rule; `.claude/kit/references.md` gains Copies, and The import
copies in each reference's commit and asks the warning with its questions;
`session-open` Import step 7 and Temporary Session follow it; `secrets.py`
and `secrets-decrypt.mjs` skip `.claude/imported/`, and `secrets.py check`
reads it without the frontmatter name check; `check.sh` tests that and
scans `.claude/imported/` for private terms; `CLAUDE.md` holds the rule that
this repository never imports. `bash check.sh` passed.

**Closed, 2026-10-17.** Merged into `preview` and then `main` at
MrFieldTech's request.


### Let A Repository Set Where And How The Default Import Writes

DROPPED | GRM / MRFIELDTECH | 261017 000016
HOLDING | GRM / MRFIELDTECH | 261016 230745

**Slug:** `import-update-match`
**Status:** DONE
**Opened:** 2026-10-16
**Closed:** 2026-10-17

**Why.** MrFieldTech, 2026-10-16: update the way import works to best match
the repository it is intended for while staying generic. The kit default's
steps already fit any repository: match each subject to a home, add the
facts the home lacks, keep a conflicting fact beside the existing one with a
`TODO:` asking which holds, turn unverified facts into `TODO:`s, send
questions to `HANDOFF.md`, and handle credentials by comparing each
source's keys with this repository's. Three values it uses are hard-coded,
and they are what make it wrong for the repository it is meant for, a
private one whose subjects live one file per subject under a directory per
section, and whose rules file says how such a file is written:

1. Where a subject's home is. Fixed at `imported/<subject-slug>.md`; it
   could be a path pattern.
2. How a new home is written. A plain subject file; it could point to a
   file and heading in the repository's own rules.
3. Whether a new home waits for the owner to confirm where it goes. It does
   not; there it should.

The private repository's own file and path names are left out of this
block, by the project rule that nothing here names the owner's other
projects.

**Facts looked up, 2026-10-16.**

- The kit is at 1.11.0. The kit default is `.claude/kit/references.md`,
  The kit default procedure: subjects go to `imported/<subject-slug>.md`,
  credentials to `imported/<subject-slug>.secrets.md`, and a new file is
  written without asking.
- `REFERENCES.md`, from `.claude/kit/templates/REFERENCES.md`, holds the
  Procedure section: `Import procedure:` (`kit default`, or a file and
  heading giving the repository's own) and `Default warning:`.
- While the warning is `shown`, every import asks once whether to keep the
  default or write the repository's own procedure into `CLAUDE.md`.
- `session-open` Import step 2 stops when any `task/import-` branch exists,
  while `references.md` One at a time names `task/import-<yymmddhhmmss>`.
  The looser check matches this task's own branch.
- This repository has no `REFERENCES.md`, so imports are off here.

**Decisions made.** MrFieldTech, 2026-10-16, round 1 of grilling, every
answer the recommended one.

- The three values live in `REFERENCES.md`'s Procedure section, beside
  Import procedure, and are set when imports are turned on: only a
  repository that imports needs them. They apply only under `kit default`.
- Subject home is a path pattern holding `<subject-slug>`, with `*` for one
  directory level. The one matching file is the subject's home, none means
  a new home, and more than one is a question. Credentials go beside the
  home, ending `.secrets.md`. Default `imported/<subject-slug>.md`.
- New home format is `kit default` or a file and heading in the
  repository's own rules, followed both when writing a new home and when
  placing added facts in an existing one.
- Confirm new homes, when `yes`, is asked once, before anything is
  imported: every new reference is read, and each unmatched subject gets a
  proposed path as the recommended answer. The import waits for the
  answers. Default `no`.
- The Default warning's second option asks for the three values, proposing
  each from the repository's own rules. A full procedure of the
  repository's own stays possible. The warning shows only while all three
  are at their defaults.
- `session-open` Import step 2 matches only `task/import-<yymmddhhmmss>`,
  as One at a time says, in this release.
- The release is 1.12.0. A `REFERENCES.md` without the new lines reads them
  as their defaults, so an updating repository does nothing.

The frontier is empty after round 1.

- A Subject home holding `*` names no single path for a new home, so its
  new homes are confirmed even when Confirm new homes is `no`. Proposed by
  GRM / MRFIELDTECH while writing the release; MrFieldTech kept it,
  2026-10-17.

**Done, 2026-10-16.** Release 1.12.0, as decided: the `REFERENCES.md`
template gains Subject home, New home format and Confirm new homes.
`references.md` The kit default procedure holds Its three values, The
warning and The steps, whose first settles every subject's home before
anything is imported; Turning imports on proposes the values and the
import's Questions rule names an unsettled home. `session-open` Import step
2 matches only `task/import-<yymmddhhmmss>`, and step 7 runs the Homes step
first. `README.md` and `CHANGELOG.md` say the same. `bash check.sh` passed.

**Closed, 2026-10-17.** Merged into `preview` and then `main` at
MrFieldTech's request.

### Backfill Only The Session It Was Opened In

DROPPED | GRM / MRFIELDTECH | 261016 224318
HOLDING | GRM / MRFIELDTECH | 261016 222714

**Slug:** `backfill-intent`
**Status:** DONE
**Opened:** 2026-10-16
**Closed:** 2026-10-16

**Why.** MrFieldTech, 2026-10-16: "Using the backfill flag for session
open is supposed to create a session-reference for the missing session.
It's not supposed to create session-references for every missing
session-reference for every branch, it's only supposed to create one
session-reference for the session it was open in. If the session it was
opened in is a brand new session, only then should it ask if it's supposed
to create a session-reference for every missing one."

**Facts looked up, 2026-10-16.**

- Release 1.7.0 added `/session-open backfill`. Its Backfill section in
  `session-open` lists every past close with no reference, by
  `git log --grep='^handoff: '` on the base, opens
  `backfill-<yymmddhhmmss>`, writes one reference per close, and closes
  itself. `.claude/kit/references.md` Backfilling holds its rules, and
  already writes a close this conversation ran from the conversation and
  any other by transcription from the repository.
- The backfill is also described in `HOUSE.md` (Sessions and branches),
  the `session-open` description and step 4, `README.md` and the 1.7.0
  `CHANGELOG.md` entry.
- Since 1.7.0 every close writes a reference, so a session that closed
  under 1.7.0 or later lacks one only when its close failed partway. A
  temporary session that opened no task has no close and no reference.
- The kit is at 1.10.0.

**Decisions made.** MrFieldTech, 2026-10-16, round 1 of grilling.

- A backfill run in a session that has done something covers only that
  session: what it ran that has no reference, written from the
  conversation. It is for closes that wrote none, as under a release before
  1.7.0. A close that wrote its reference is never written again, because
  a second one duplicates it rather than filling a gap. A temporary session
  that opened no task counts as one with no reference, under the slug
  `temp`. A task it worked and has not closed is left to its close, which
  writes its reference, for the same reason.
- The reference is written on its own task, `backfill-<yymmddhhmmss>`,
  which closes itself as before.
- Run as the first thing in a brand new session, it lists the past closes
  with no reference, numbered with their count, and asks which to write:
  all, the numbers named, or none. None writes nothing.
- A session with nothing missing says so and stops, offering no wider
  backfill.
- The release is 1.11.0, and an updating repository does nothing after.

The frontier is empty after round 1.

**Done, 2026-10-16.** Release 1.11.0, as decided: `session-open` Backfill
step 2 chooses between the session's own missing reference and, in a brand
new session, the developer's pick of past closes. `references.md`
Backfilling gains What a backfill covers and names a temporary session's
reference. `HOUSE.md`, `README.md`, the skill's description and
`CHANGELOG.md` say the same.

**Closed, 2026-10-16.** Merged into `preview` and then `main` at
MrFieldTech's request.

### Rename The Holder Words And Add A DISMISSED Status

DROPPED | GRM / MRFIELDTECH | 261016 214943
HOLDING | GRM / MRFIELDTECH | 261016 213749

**Slug:** `task-name-changes`
**Status:** DONE
**Opened:** 2026-10-16
**Closed:** 2026-10-16

**Why.** MrFieldTech, 2026-10-16: "Within the task holder lines, change
ACTIVE to HOLDING and INACTIVE to DROPPED (as to not confuse these terms
with the Status options (TODO, ACTIVE, BLOCKED, DONE). Additionally, when a
task is no longer going to be developed, it is "Dropped:" with the
reasoning. This should be changed to DISMISSED so as not to confuse it with
the new holder status. DISMISSED should be a new status option for a task
(although redundant with the dismissed information in the task and the fact
that it was promoted, but still, it's an outline for future changes that
may come)."

**Facts looked up, 2026-10-16.**

- Holder words are written in `HOUSE.md` (Developers), the `TASKS.md`
  template, `session-open` steps 4 to 6, `session-close` step 3 and its
  Format, `check.sh` section 4 (`(IN)?ACTIVE \| `), `README.md` line 16
  ("dropped it"), and this repository's `TASKS.md`, where four closed
  tasks carry holder lines.
- The `Dropped:` field is in the `TASKS.md` template's marker table and
  field block, `session-close` step 3 and its Format, and `grilling.md`'s
  Done section. No task here has ever been dropped.
- Session references carry no holder lines. Their `Task:` line names the
  status at close, `<DONE | BLOCKED | ACTIVE>`.

**Decisions made.** MrFieldTech, 2026-10-16, round 1 of grilling.

- Holder lines already written are renamed, so only one pair of words ever
  exists. This release rewrites this repository's, and its changelog entry
  tells an updating repository to rename its own in the update's commit.
- A `DISMISSED` task goes wherever a `DONE` one goes: it gets a `Closed:`
  date and a `Dismissed:` line saying why, merges at close, moves to Closed
  Tasks, and counts as closed in every check that asks about `DONE`.
- The release is 1.10.0, a minor release as 1.6.0 was.

The frontier is empty after round 1.

**Done, 2026-10-16.** Release 1.10.0, as decided: holder lines read
`HOLDING` and `DROPPED` in `HOUSE.md`, both skills, the `TASKS.md`
template and this repository's `TASKS.md`, every holder line here renamed.
`DISMISSED` with a `Dismissed:` line replaces `DONE` with `Dropped:`, and
goes wherever `DONE` goes in `HOUSE.md`, both skills, `grilling.md` and the
reference template. `check.sh` section 4 also matches the old holder words,
so a copy left on them fails. The changelog entry says what an updating
repository renames.

**Closed, 2026-10-16.** Merged into `preview` and then `main` at
MrFieldTech's request.

### Hold The Task Block Fields To One Format In check.sh

DROPPED | GRM / MRFIELDTECH | 261016 213052
HOLDING | GRM / MRFIELDTECH | 261016 203427
DROPPED | GRM / MRFIELDTECH | 261016 201729
HOLDING | GRM / MRFIELDTECH | 261016 201442

**Slug:** `check-block-fields`
**Status:** DONE
**Opened:** 2026-10-16
**Closed:** 2026-10-16

**Why.** MrFieldTech, 2026-10-16, answering the retrospective of
`grill-position-diff`: open a task for it later. A task block's fields
(`Slug`, `Status`, `Opened`, `Blocked`, `Closed`, `Dropped`) are written out
in three places: `.claude/kit/templates/TASKS.md`, `session-close`'s Format
section, and this repository's own `TASKS.md`. Release 1.8.0's `Dropped:`
line reached the template first and `session-close` only on a second look
(`6580c0f`), and `bash check.sh` passed both ways. A check would make a field
added to one copy and missed in another fail.

**Background.** `check.sh` already fails on a missing practice file and on a
README update slug that does not match `VERSION`, so a cross-file
consistency check fits it. Find the copies with
`grep -rn 'Closed:\*\* <' .claude TASKS.md`.

**Facts looked up, 2026-10-16.** The fenced field block is identical, line
for line, in `.claude/kit/templates/TASKS.md`, `session-close`'s Format and
this repository's `TASKS.md`. The holder line is written out in five places
(`HOUSE.md`, the template, `session-open` step 5, `session-close`, and this
`TASKS.md`), each line in the same shape, two of them as an example pair in
opposite orders, both newest first.

**Decisions.**

- MrFieldTech, 2026-10-16: the check is strict. A fenced block of field
  lines must match the template's line for line, placeholders included, so
  a changed description fails as well as a missing field.
- MrFieldTech, 2026-10-16: the check covers the holder line as well as the
  field block, because both are format that one copy can gain and another
  miss.

- MrFieldTech, 2026-10-16: the check holds all three copies to the
  template, this repository's `TASKS.md` included. Only the fenced
  examples above its Open Tasks are compared, never a task's real lines,
  and a release changes all three in one pull request.
- MrFieldTech, 2026-10-16: a two-line holder example matches the template
  in order too, so `HOUSE.md`'s pair is swapped to the template's order
  (`INACTIVE` above `ACTIVE`, newest first) and this task is a release.
  Copies of a template's details never differ, even by order. A one-line
  holder example must equal one of the template's lines.

**Done, 2026-10-16.** Release 1.9.0, as decided: `check.sh` section 4
holds every fenced field block and holder line in a kit-owned file, and in
this repository's `TASKS.md` above its Open Tasks, to
`.claude/kit/templates/TASKS.md`, and `HOUSE.md`'s holder pair lists
`INACTIVE` above `ACTIVE`. A dropped field, a changed placeholder, a changed
holder line and the old `HOUSE.md` order each made it fail. The field
lines it compares are the template's labels, so other bold labels in
fenced examples, such as `**Purpose:**`, are left alone.

### Claim A New Task's Branch Before Grilling It

DROPPED | GRM / MRFIELDTECH | 261016 160327
HOLDING | GRM / MRFIELDTECH | 261016 145848

**Slug:** `grill-position-diff`
**Status:** DONE
**Opened:** 2026-10-16
**Closed:** 2026-10-16

**Why.** MrFieldTech, 2026-10-15: "It seems the grill skill is being required
prior to creating a named task branch. What is the reasoning for this? It
seems like a lot of information is gathered and decided before ever having a
branch dedicated to it, when it doesn't seem like a problem to have the
branch taken then start the grilling."

**Facts looked up, 2026-10-15.**

- The order was never decided. `workflow-practices` (1.3.0) was asked to run
  the interview "before a task's block is written", and `session-open` step
  5 writes the block in the commit that claims the branch, so grilling
  landed before the claim as well.
- What the order guards against: a slug and its branch are permanent and a
  session never deletes a branch, so a branch claimed for a slug that
  grilling renames, finds duplicated, or drops is left for the owner to
  delete.
- What it costs: every answer lives only in the conversation until grilling
  ends. `grilling.md` says so, and claims and parks only when the session
  has to stop. In `secrets-self-sufficient`, round 1 was asked only in the
  reply and reached the block after the owner asked where the questions
  lived, which is the open question in `HANDOFF.md` on writing each round
  into the block before asking it. A second session can also take the same
  slug while the first is still grilling, and finds out only at its push.

**Decisions made.** MrFieldTech, 2026-10-16, round 1 of grilling.

- This session claimed `task/grill-position-diff` before grilling further,
  as the first use of the new order.
- A new task is claimed first. Step 5 writes the block with what was asked
  and pushes, then each round is written into the block and pushed before it
  is asked, and each answer is committed as it comes. This settles the
  `HANDOFF.md` open question on writing rounds into the block. The change is
  release 1.8.0, in `session-open` step 4 and the temporary session's task
  path, `grilling.md`, and `HOUSE.md`'s Grilling pointer.
- The block does not keep a transcript of the grilling. A round is written as
  a list of unanswered questions, like Open Questions in `HANDOFF.md`, and an
  answer turns its question into a record of what was decided. How exactly is
  round 2, question 1.

**Decisions made.** MrFieldTech, 2026-10-16, round 2 of grilling.

- An answered question leaves the block's open questions and becomes a
  decision under Decisions made: who, the date, what was decided, what it
  changes and why, in the owner's sense rather than their words.
- The slug is checked against the slug rule before the claim, as now. A task
  grilling drops, or finds duplicating another, is marked `DONE` with a
  `Dropped:` line saying why and merges by pull request at close, so GitHub
  deletes its branch and the block keeps the reason. A slug that turns out
  misleading stays, because the slug is inconsequential to the work; the
  task is dropped and a new one opened only when the owner asks.
- With no slug named but work described (step 4 case d), the session first
  looks for an open task that already covers it, on a task branch or under
  Open Tasks, and offers each match as an option alongside a new task. With
  no match it chooses a slug and claims at once, naming the slug in the
  first round. With neither a slug nor work named (case e), the session
  lists the task branches and open tasks and asks, which is how case e
  already works.
- Unanswered grilling questions stay in the task's block, and `session-open`
  shows them through the stopping point. `HANDOFF.md` takes a question only
  when the task is `BLOCKED` on it, as now, or when the task closes `DONE`
  with questions it raised still unanswered, which then move from the block
  to Open Questions in `HANDOFF.md`.

The frontier is empty after round 2.

**Done, 2026-10-16.** Release 1.8.0, as decided: `session-open` step 4
cases c and d and step 6, `grilling.md`, `HOUSE.md`'s Grilling pointer,
`session-close` step 3 and its Format, the `TASKS.md` template's `Dropped:`
line, `VERSION`, `CHANGELOG.md` and `README.md`. `bash check.sh` passes.
This session grilled on its claimed branch by hand, before the skill said
to.

**Closed, 2026-10-16.** Merged into `preview` and then `main` at
MrFieldTech's request.

### Write Session References And Import Them Into Other Repositories

DROPPED | GRM / MRFIELDTECH | 261015 223345
HOLDING | GRM / MRFIELDTECH | 261015 220409

**Slug:** `session-references`
**Status:** DONE
**Opened:** 2026-10-14
**Closed:** 2026-10-15

**Why.** MrFieldTech, 2026-10-14. Facts a session learns in one repository
should reach another without a person carrying them, in any repository that
uses the kit, inside or outside the organization. The writer leaves a dated,
immutable record of each session's facts; the reader pulls those records
into a repository that asks for them and turns them into its own content.

**What was asked, as given.**

1. *Session references, the writer.* At every close, `session-close` writes
   one file to `.claude/references/<yymmddhhmmss>-<task-slug>.md`, time in
   UTC, in addition to `HANDOFF.md`, which stays unchanged. It is written
   once and never edited; a task spanning several sessions gets one per
   session. It records facts, not finished documentation, in a generic shape
   roughly molded on a chat handoff: the task and its commit range, current
   state, decisions with who made them, verified facts each with its source,
   exact values (paths, addresses, commands, versions), artifacts, gotchas,
   flagged as unverified, open questions, and one block of facts per subject
   (each system, account, service, process or project the session worked
   on). With nothing worth recording, its facts say None. It names no
   importer and copies no other repository's rules. `.claude/references/`
   sits outside `.claude/kit/` and the TODO sweep skips it. A reference names
   each credential by id, never a value. With Credentials `none`, the session
   says the repository has no credential method, offers to set one up, and
   commits no value. With a method, the values go encrypted, one labelled
   block each, in a companion `<yymmddhhmmss>-<task-slug>.secrets.md`. A
   value given in plaintext in the session draws a warning at close that the
   conversation holds it and should be erased.
2. *The import system, the reader.* A setup step a repository runs to turn
   it on, which builds `REFERENCES.md` at its root: each source repository in
   scope, those excluded with the reason, and the last reference imported
   from each. `/session-open import` (`import` becomes a reserved word, like
   `temp`) reads `REFERENCES.md`, attaches each source read-only, and lists
   the references newer than the last import. With none it stops and writes
   nothing. Otherwise it opens task `import-<yymmddhhmmss>` on its task
   branch and imports each reference by the procedure the repository's
   authority file or `CLAUDE.md` gives for turning facts into its own
   content, asking about anything it cannot settle, then records the last
   import per source. Under `kit standard`, it compares the source's
   `secrets-recipients.txt` with its own. On a match it copies each block as
   it stands. On a difference it copies none, writes a TODO asking for the
   value encrypted to its own keys, and the setup warns of this up front.
3. Both are a release: `VERSION`, `CHANGELOG.md` and `README.md`, with what
   an updating repository must do.

**Facts looked up, 2026-10-14.**

- `todo_sweep.py` already skips every path under `.claude/`, so
  `.claude/references/` needs no change to the sweep.
- `kit.sh` owns only `.claude/kit/` and the two skill directories, so an
  install or update never touches `.claude/references/` or `REFERENCES.md`.
- `secrets.py check` reads every tracked `*.secrets.md`, wherever it sits,
  and requires frontmatter of `slug` and `updated` alone, the slug matching
  the filename. A companion passes as `slug: <yymmddhhmmss>-<task-slug>`.
  `rekey` re-encrypts it in place, and `decrypt` (and the Node decrypter)
  would copy it into a build's output as it stands.
- `secrets.py place` refuses a block encrypted to a different number of keys
  than `secrets-recipients.txt` lists, and cannot tell the right keys from
  the wrong ones of the same count.
- `check.sh` checks addresses and the private terms only in kit-owned
  directories, so a reference committed in this public repository is not
  checked for the owner's other projects.
- The slug `import-<yymmddhhmmss>` is 19 characters, inside the default
  Task slug limit of 23.
- Version 1.5.0 was current when this opened, so this was 1.6.0, new
  features with no breaking change. It became 1.7.0 on 2026-10-15.

**Decisions made.** MrFieldTech, 2026-10-14, round 1 of grilling.

- The import reads each source's default branch, so only promoted work is
  imported.
- `REFERENCES.md` records, per source, the last reference imported and the
  source commit it was read at. Newer means every reference added to the
  source since that commit, so a late-merging reference is still caught.
- Every repository writes references at every close, with no setting:
  little cost in tokens or storage, and they may help later in ways not
  yet seen.
- A companion holds every value the session produced, was given or
  changed, as a dated copy beside its home.
- The first import from a new source imports every reference it holds.
- The import task's own reference records each source and reference it
  imported, by name, and only facts its session verified, never the
  imported facts, so two repositories importing each other cannot loop.
- When the importing repository is not `kit standard`, no value is copied.
  The import names each credential by id with a TODO and asks the owner
  what to do with it, recommending the kit's credentials setup.
- `secrets.py decrypt` and the Node decrypter skip `.claude/references/`,
  so a build never holds a second plaintext copy.
- `check.sh` extends its private-terms check to `.claude/references/` in
  this repository.

MrFieldTech, 2026-10-14 and 2026-10-15, rounds 2 and 3 of grilling.

- Credentials In Transit leaves the `HANDOFF.md` template and
  `session-close`. A value with no home yet lives only in its session's
  companion, and the task opened to place it names that companion.
  `secrets.py` still reads the heading where an older `HANDOFF.md` or an
  authority file keeps it, and an updating repository moves any value held
  there into a companion.
- When the repository gives no import procedure, the import runs the kit's
  default and says so, because the repository's own way probably differs.
  The owner either dismisses the warning for good, recorded in
  `REFERENCES.md` with who and when, or answers a few questions that write
  the repository's own procedure.
- The default is modelled, with the owner's approval of 2026-10-15 to
  publish it unnamed, on how one of the owner's private repositories
  already promotes chat handoffs. It must work for any repository but
  first of all as that repository works today, and must not turn every
  import into a long round of questions: it asks only what it cannot
  record. Each subject becomes `imported/<subject-slug>.md`, or reconciles
  into the file already there: the newer reference wins on facts, every
  unique fact carries over, and a conflict is written onto the file with a
  `TODO:` rather than settled by picking a side. A fact flagged as
  unverified becomes a `TODO:` quoting the reference. New files are listed
  in the report, not asked about. Questions and unverified facts above any
  one subject go to `HANDOFF.md`. Nothing is deleted.
- This repository: the owner adds `KIT_PRIVATE_TERMS` to the cloud
  environment's variables, a project rule in `CLAUDE.md` has the close
  replace each match in a reference with `[redacted]` before committing
  it, `check.sh` fails on any match left, and the owner turns on secret
  scanning with push protection.
- Every repository: a `HOUSE.md` rule that a reference in a public
  repository, or one whose visibility cannot be confirmed, holds no detail
  the repository's own rules keep private, and the first run gives an
  `Action needed:` to turn on secret scanning with push protection in a
  public repository.

Grilling is done: the frontier is empty.

**The build.**

- `.claude/kit/references.md`, new: the reference and its companion, the
  setup that turns imports on, `REFERENCES.md`, the import, and the kit's
  default import procedure.
- `.claude/kit/templates/reference.md` and `templates/REFERENCES.md`, new.
- `session-close`: write the reference and its companion, stage them in the
  handoff commit, the plaintext warning, a `Reference:` report line, and no
  Credentials In Transit.
- `session-open`: `/session-open import`, `import` never a task slug, and
  the first run's secret scanning notice.
- `HOUSE.md`, `credentials.md`, `templates/HANDOFF.md`: references,
  companions, no Credentials In Transit, the public repository rule.
- `secrets.py` and `secrets-decrypt.mjs`: decrypt skips `.claude/references/`.
- `check.sh`: private terms over `.claude/references/`, the decrypt skip,
  the new templates. `CLAUDE.md`: the redaction rule.
- Release 1.7.0: `VERSION`, `CHANGELOG.md`, `README.md`.

**Round 2, as asked** (answered above):

1. Credentials In Transit, now that companions hold every value: a) remove
   the heading from the `HANDOFF.md` template and `session-close`; a value
   with no home yet lives only in its session's companion, and the task
   opened to place it names that companion. `secrets.py` still reads the
   heading where an older `HANDOFF.md` has one, and an updating repository
   moves any value held there into a companion (recommended); b) keep it
   as it is.
2. An import must turn a reference's facts into the repository's own
   content, such as a page per subject or lines in a notes file, by a
   procedure written in the authority file or `CLAUDE.md`. When the
   repository has written none: a) the setup asks the owner how facts
   become content there and writes the answer into `CLAUDE.md` under a
   heading of its own, and the import refuses to run until it exists
   (recommended); b) the kit gives a default, such as adding each
   reference's facts to one `IMPORTED.md`.
3. Hashing out private text in this repository's references: a cloud
   session has no list of terms, which lives only in the CI secret, so it
   cannot check a reference before the push that publishes it on this
   public repository. a) the owner adds `KIT_PRIVATE_TERMS` to the cloud
   environment's variables; a project rule in `CLAUDE.md` has the close
   replace each match with `[redacted]` before committing the reference,
   and `check.sh` fails on any match left (recommended); b) the close
   writes references here naming no other project, and a match CI finds
   after the push is redacted by a new commit, the history keeping it;
   c) both.

**Round 1, as asked** (answered above):

1. Which branch of a source the import reads: a) its default branch, so
   only work the owner promoted is imported (recommended); b) its
   integration branch; c) both.
2. How "newer than the last import" is found: a) `REFERENCES.md` records,
   per source, the last reference imported and the source commit it was
   read at, and newer means every reference added since that commit, so a
   parked task's reference with an older timestamp that merges late is
   still caught (recommended); b) by filename timestamp alone.
3. Whether every repository writes references: a) always, no setting, as
   asked (recommended); b) a new Session Settings key that can turn it off.
4. Which credentials go in a companion: a) every value the session
   produced, was given or changed, a dated copy beside its home
   (recommended); b) only values with no other home in the repository.
5. When neither the authority file nor `CLAUDE.md` gives an import
   procedure: a) the setup asks the owner for it and writes it into
   `CLAUDE.md` under a heading of its own, and an import refuses to run
   without one (recommended); b) the kit supplies a default procedure.
6. The first import from a new source: a) imports every reference it holds
   (recommended); b) the setup marks the newest as imported, and only later
   ones import.
7. The import task's own reference: a) records what it imported, each
   source and reference by name, and only facts the session itself
   verified, never re-copying imported facts, so two repositories importing
   each other do not loop (recommended); b) records the imported facts too.
8. Credentials when the importing repository is not `kit standard`: a) copy
   no value; name each id with a TODO asking the owner to place it by the
   repository's own method, or to set one up (recommended); b) refuse to
   import a reference whose companion holds values.
9. `secrets.py decrypt` and the Node decrypter: a) skip
   `.claude/references/`, so a build never holds a second plaintext copy
   (recommended); b) decrypt companions like any secrets file.
10. This public repository's own references may name the owner's other
    projects: a) extend `check.sh`'s private-terms check to
    `.claude/references/` here (recommended); b) also its address check;
    c) neither.

**Decisions made.** MrFieldTech, `GRM / MRFIELDTECH`, 2026-10-15, folding
in release 1.6.0, `multi-dev-setup`, which merged into `preview` ahead of
this task by MrFieldTech's decision and was merged onto this branch.

- This release is 1.7.0, not 1.6.0, and its README update slug is
  `kit-update-1-7-0`.
- Each session reference records the developer who ran the session as
  `<PREFIX> / <HANDLE>`, as the holder lines do, and the decisions in it
  name the developer who made each.
- The writer goes into `session-close` as 1.6.0 left it: step 3 adds an
  `INACTIVE` holder line and step 4 adds a Developer column to the Session
  Log. The `HANDOFF.md` heading is `Open Questions`.
- Every developer is an owner, so the import's questions go to whichever
  developer runs the session.

**Decisions made.** MrFieldTech, `GRM / MRFIELDTECH`, 2026-10-15, after
folding in 1.6.0.

- An import refuses to start while another `import-` task branch exists,
  naming its holder, and offers to take that task over. Built.
- An imported question names the source's developer and repository, as
  `<PREFIX> / <HANDLE> in <owner>/<repository>`. Built.
- **New request: references for sessions that closed without one.** The
  developer needs a way, a prompt or a recovery part of a skill, to have a
  session write a reference for a session that already closed, even after
  `session-close` ran and its task branch was deleted.

**Facts looked up, 2026-10-15, for that request.**

- Every close makes one commit whose message begins `handoff: `, and no
  other commit may, so `git log --grep='^handoff: '` on the default branch
  lists every past close: 21 here.
- A merged task branch's commits survive its deletion, in the merge into
  the integration branch, as do the task's block in `TASKS.md`, its Session
  Log row with its commit range, and the pull request with its body.
- What a session said and decided in its conversation is in no file. Only
  a session running in that same conversation still holds it.
- Before 1.6.0 the Session Log kept ten rows, so older closes are found by
  their `handoff:` commits, not by the log.

**Decisions made.** MrFieldTech, `GRM / MRFIELDTECH`, 2026-10-15, backfill
round.

- `/session-open backfill`, with `backfill` reserved like `temp` and
  `import`, opens a task `backfill-<yymmddhhmmss>`. Run in a conversation
  that already ran a session, it writes that session's reference from the
  conversation. Run in a new session, it looks for every past close with
  no reference and writes one for each. The developer asked that it close
  itself when done; whether it does is question 2 below.
- It covers every `handoff:` commit with no reference, back to the first.
- A reference rebuilt from the repository carries a `Reconstructed:` line
  naming its sources, and every fact no commit or committed file shows
  goes under Flagged As Unverified.
- Its file name carries the original close's time, the UTC commit time of
  its `handoff:` commit, and the original task's slug.
- The developer asked whether a reference the session did not write itself
  is worth having. The reply of 2026-10-15 answered in full; question 1
  below puts the choice.

**Decisions made.** MrFieldTech, `GRM / MRFIELDTECH`, 2026-10-15, second
backfill round. Built.

- A backfill with no conversation to draw on still writes references, as
  transcription only: what the task's block, its Decisions Made and Session
  Log entries, its commit messages and its pull request body say, each
  fact citing its file, nothing inferred.
- A backfill task closes itself by `session-close`'s steps when its
  references are written, with no `/session-close`.

**Second backfill round, as asked** (answered below):

1. A reference rebuilt with no conversation holds nothing the repository
   does not, but an import reads only `.claude/references/`, so without
   one a past session's decisions and facts never reach an importing
   repository. a) Keep it as transcription only: copy what committed files
   state about that close (the task's block, its Decisions Made and Session
   Log entries, its commit messages, its pull request body), each with its
   file as source, and infer nothing (recommended); b) drop it, and
   backfill only from a conversation that still holds the session.
2. Closing: a) a backfill task runs `session-close`'s steps on itself when
   its references are written, with no `/session-close`, because it changes
   only `.claude/references/` and the state files (recommended); b) it
   waits for `/session-close` like any task.

**Backfill round, as asked** (answered below):

1. How a developer asks for it: a) `/session-open backfill`, with
   `backfill` reserved like `temp` and `import`, opening a task
   `backfill-<yymmddhhmmss>` that writes one reference per past close that
   has none. Run in the old session's own conversation, it writes that
   session's reference from the conversation; run anywhere else, it
   reconstructs from the repository (recommended); b) a prompt in the
   README alone, with no keyword; c) both.
2. Which past closes a backfill covers: a) every `handoff:` commit with no
   reference, back to the first (recommended); b) only the tasks the
   developer names; c) only those after a date the developer gives.
3. How a reconstructed reference is marked: a) a `Reconstructed:` line
   naming its sources, and every fact that no commit or committed file
   shows goes under Flagged As Unverified, so an import turns it into a
   `TODO:` (recommended); b) no mark.
4. The time in its file name: a) the original close's, the UTC commit time
   of its `handoff:` commit, so references sort in the order the sessions
   ran (recommended); b) the time of the backfill.

**After folding in 1.6.0, as asked** (answered below):

1. Two developers running `/session-open import` at once would import the
   same references and both edit the same `REFERENCES.md` rows, which
   conflicts at merge and parks the second task. a) An import refuses to
   start while another `import-` task branch exists, naming its holder from
   its holder lines, and the developer may take that task over instead
   (recommended); b) allow it and let the merge rule park the second.
2. Open questions in `HANDOFF.md` now name the developer who raised them.
   An imported question was raised in its source. a) It names the source's
   developer from the reference's Developer line and the source
   repository, as `<PREFIX> / <HANDLE> in <owner>/<repository>`
   (recommended); b) it names the developer who ran the import.

**Outcome.** Release 1.7.0, checked by `bash check.sh`: session references
written at every close with a companion for credentials, `/session-open
import` with its setup and the kit default procedure, `/session-open
backfill`, no Credentials In Transit in the template, both decrypters
skipping `.claude/references/`, and this repository's redaction rule.
Before the first real import, the private repository whose procedure the
default follows needs its authority file to name an import procedure, its
own or the kit default, and it copies no credential until it switches to
`kit standard`.

### Run The Session Protocol With Several Developers

DROPPED | GRM / MRFIELDTECH | 261015 214746
HOLDING | GRM / MRFIELDTECH | 261015 004741

**Slug:** `multi-dev-setup`
**Status:** DONE
**Opened:** 2026-10-15
**Closed:** 2026-10-15

**Why.** MrFieldTech, 2026-10-15: "Right now the session open/close mechanic
is mainly built around a single dev handling multiple tasks/branches. How can
we redevelop the process to handle multiple devs with multiple
tasks/branches?" The kit should let several people, each running their own
sessions, work one repository's queue without taking each other's tasks,
overwriting each other's state, or merging into each other's way.

**Facts looked up, 2026-10-15.** Where the protocol assumes one developer:

- **One person answers everything.** The Owner setting names whoever answers
  every question, alone asks for the default branch to move, and alone
  decides a kit update. `HANDOFF.md` has one `Open Questions For <Owner>`
  heading, and grilling puts every decision to the owner.
- **A task branch says it is taken, not by whom.** `session-open` step 4
  never takes a branch nobody named, because a parked branch and one another
  session is working look the same. With one developer, a branch they name is
  theirs. With several, a developer can name, and resume, a branch another
  developer parked or is working right now. No line in a task's block records
  who holds it.
- **The session never learns who is running it.** Nothing in either skill
  reads a GitHub account or `git config user.name`. Decisions are recorded
  with the owner's name, and the Session Log has no column for who worked.
- **Every close edits the top of shared tables.** Each close adds a row to the
  top of the Session Log and edits Open Questions, Decisions Made and Flagged
  As Unverified in `HANDOFF.md`. The conflict rule keeps both sides only where
  both only added lines, so a dropped row (the log keeps ten) or an edited
  question conflicts and parks the task. More developers means more of these.
- **A promotion can strand another developer's pull request.** `session-close`
  step 9 does not check for an open pull request into the integration branch;
  only the temporary session's promotion does. If one developer promotes while
  another's close has a pull request open into it, GitHub deletes the
  integration branch and retargets that pull request at the default branch.
  This is a fix the task makes whatever the decisions below.
- **The session merges its own pull request.** No one else reviews it. A
  repository whose branch protection requires an approval would park every
  task at close.
- **A stray stops every session.** `session-open` step 3 stops until the owner
  answers. A branch another developer made, or their tool made, stops every
  developer's session, and only the owner can answer for it.
- **Two new tasks under one slug collide safely.** The second push of
  `task/<slug>` is rejected and step 5 sends that session back to step 4.
  Blocks added to `TASKS.md` on two branches are added lines, which the
  conflict rule keeps.
- **`session-references` is parked and also changes `session-close`.** Its
  references would record who ran each session if this task adds identity.
  Whichever merges second merges the other in.

**Facts looked up, 2026-10-15, after round 1.**

- The GitHub connector's `get_me` returns the account behind the session,
  `MrFieldTech` here. `git config user.name` in a cloud container reads
  `Claude`, so it names no one and is no fallback.
- The Claude Code Branch prefix setting is not in the session's environment
  or in any settings file the container holds. A cloud session sees it only
  in the branch the harness assigned and checked out before any skill runs:
  this session started on `grm/elegant-hypatia-o6xu3r`, so the prefix is the
  part before the first `/`. `session-open` must read it before step 2
  detaches. A local session, or a prefix left empty, shows none.
- The Status line (`TODO | ACTIVE | BLOCKED | DONE`) and the new holder lines
  both use the word ACTIVE. They are different lines and stay so.

**Decisions made.** MrFieldTech (prefix `grm`), 2026-10-15, round 1 of
grilling.

- **The organization is flat.** Every developer is the owner: anyone may
  promote, take a kit update, answer any question and answer for a stray.
  The kit builds in no hierarchy and no list of employees.
- **A developer is anyone with push access** who works the repository with
  Claude Code and the kit. No setting lists them.
- **The session finds who runs it and never asks.** The handle is the GitHub
  account behind the session's GitHub access. Developers given one shared
  account are treated as that account. The Branch prefix from Claude Code
  settings is recorded beside the handle, never added to a branch name.
- **Any developer may resume any task,** with a warning when the task's
  newest holder line is ACTIVE for another developer, meaning they never
  dropped it by `session-close`. When `session-open` takes a task, it adds at
  the top of the task's block a line `ACTIVE | <PREFIX> / <HANDLE> | <MMDDYY
  HHMMSS>`, all in capitals. `session-close` adds above it, whatever the
  task's status, `INACTIVE | <PREFIX> / <HANDLE> | <MMDDYY>`. The lines are
  a running log of who touched the task, newest first.
- **Pull requests are not reviewed.** Sessions keep merging their own. A
  review option is a possible later feature of the kit, noted under Open
  Questions in `HANDOFF.md` when this task closes.
- **The kit may need a more distinctive name,** because Claude-Kit used
  publicly is too generic. Noted under Open Questions in `HANDOFF.md` when
  this task closes.
- **One `HANDOFF.md`.** The Session Log gains a column for who worked and
  stops dropping old rows inside a close, each open question names who
  raised it or who it is for, and a close edits only the lines it added or
  answered. No question is hidden from any developer: one looking into open
  questions, or working the task a question concerns, is shown it whoever it
  was for.
- **The owners answer for a stray,** meaning whichever developer runs the
  session, since every developer is an owner. Strays should still never
  happen.
- **Fix the promotion race** found above, whatever else is decided.

**Decisions made.** MrFieldTech (prefix `grm`), 2026-10-15, round 2 of
grilling. The frontier is empty after it.

- **This task goes before `session-references`,** so references carry the
  prefix and handle from their first release. This is 1.6.0, and
  `session-references` moves to the next version.
- **The prefix is the part before the first `/` of the branch checked out
  when `session-open` starts,** read before step 2 detaches, when that branch
  is not the default branch, the integration branch, an Other branch or a
  task branch. With no prefix, the line leaves it out:
  `ACTIVE | <HANDLE> | <date>`, never `NONE`.
- **When the GitHub access names no account,** the session asks the developer
  for their GitHub handle, the one case it asks. With no answer, the handle
  is `UNKNOWN` and the report says so.
- **Holder lines date in UTC as `YYMMDD HHMMSS` on both ACTIVE and
  INACTIVE,** in place of the formats first given. Within a block the newest
  line is the top one, so nothing sorts there; the format lets the lines of
  several tasks be compared or sorted as text, across years, and matches the
  `session-references` file names.
- **The warning stops the session.** It names who holds the task and since
  when, and waits for the developer to say take it over.
- **The `session-open` report gains a `Questions:` line** with the open
  questions that concern the task being worked and a count of the rest.
  Today `session-open` reads `HANDOFF.md` in full but no step shows its Open
  Questions, so a question surfaces only if a session happens to mention it.
- **The heading becomes `## Open Questions`,** which every updating
  repository applies.
- **The Owner setting stays as the account that owns the repository,** for
  First Run and the README. "The owner" in the rules means the developer
  running the session.

**Outcome.** Release 1.6.0, checked by `bash check.sh`: `HOUSE.md` gains
Developers and makes every developer an owner, both skills and both templates
carry the holder lines, the `Holder:` and `Questions:` report lines, the
Developer column and the `Open Questions` heading, and `session-close` step 9
gains check 4 against an open pull request into the integration branch. This
repository's own `HANDOFF.md` took the new heading and column.

**Decision at close.** MrFieldTech (prefix `grm`), 2026-10-15: two people
sharing one GitHub account with no branch prefix look like one developer, and
the kit does nothing about it. Adding a collaborator is easy, so sharing an
account is their own responsibility.

### Make The Kit's Secrets Standard Self-Sufficient

**Slug:** `secrets-self-sufficient`
**Status:** DONE
**Opened:** 2026-10-12
**Closed:** 2026-10-12

**Why.** MrFieldTech, 2026-10-12, while switching the private repository
whose process became the 1.4.0 standard over to `kit standard`. That
repository decrypts credentials in its own site build, and `secrets.py` has
no command for it, so it could not switch without keeping its own script.
The owner wants the kit to be self-sufficient: whatever the kit encrypts, the
kit can decrypt, so a repository takes the whole standard and keeps only what
is particular to it. One task, one release, covers all three parts below.

**Background.** What that repository's build does today, which the owner
wants the kit's default to resemble so its switch changes little:

- The build's first step decrypts every value in every `<slug>.secrets.md`
  into a gitignored directory, reading the private key from the environment
  variable `SECRETS_AGE_KEY`. Later steps read the decrypted copy in place of
  the encrypted one.
- It fails the build when the variable is missing or a value will not
  decrypt, naming the file and label and never the value, because a build
  without its credentials looks complete and is not.
- A check build, asked for with `SECRETS_CHECK_BUILD=1`, holds no key and
  writes a fixed placeholder for every value, so continuous integration can
  build without a key.
- Decryption drops `\r\n` line endings and one trailing line break, so a
  value typed into Windows Command Prompt reads as typed.
- It decrypts in Node with the `age-encryption` package, pinned in the
  lockfile, because its build host has Node and may not have the `age`
  command line tool. `secrets.py` calls the `age` tool.
- A separate output check fails the build when a decrypted value reaches the
  search index or an encrypted block reaches a page. That one is particular
  to a repository that publishes a site.

What 1.4.0 already provides toward the other two parts:

- `secrets.py steps` prints the Windows and macOS or Linux encryption steps
  with the repository's own keys from `secrets-recipients.txt` written in.
- `credentials.md`, Setting it up, and the first run have the session ask the
  owner for keys when a private repository taking `kit standard` has none.

**Decisions.**

- MrFieldTech, 2026-10-12: the kit carries decryption. The default resembles
  the build described above, with options to decrypt another way. The owner
  is not sure what the other ways are, so the session lists them.
- MrFieldTech, 2026-10-12: in every repository, when a person asks how to
  encrypt a value to hand to a session, the session gives the steps with
  that repository's keys, never a fixed set from the kit.
- MrFieldTech, 2026-10-12: when a repository has no keys yet, the kit
  provides the process to create them and give the public halves to the
  repository, and only for a repository that is going to keep credentials.
  Some repositories never need the feature.
- MrFieldTech, 2026-10-12: every secrets check comes from the kit. Because
  repositories differ, installing the secrets standard has the session review
  the repository and write a list of checks particular to it, which are then
  run alongside the kit's.

- MrFieldTech, 2026-10-12, first round: the kit ships both a
  `secrets.py decrypt` command, the default, matching the build described
  above, and a Node decrypter. A session offers the Node decrypter only when
  `secrets.py decrypt` cannot run in the repository's build environment.
- MrFieldTech, 2026-10-12, first round: the kit documents no other way of
  decrypting. A repository that neither decrypter serves implements its own
  encryption and decryption, and the kit's secrets standard is marked unused
  there for that reason. Finding it another way is not the kit's job.
- MrFieldTech, 2026-10-12, first round: the first run sets Credentials to
  `none` unless the repository already holds credentials or the owner says
  it will. Switching to `kit standard` later runs setup: first the keys, then
  the repository's own list of checks.
- MrFieldTech, 2026-10-12, first round: a `secrets.py` command prints the
  steps for making the keys on the owner's own computer, three by default,
  the owner's, the build's and a recovery key, and the session writes
  `secrets-recipients.txt` from the public halves the owner returns. A
  repository that says otherwise, in its authority file or `CLAUDE.md`,
  overrules the default set.
- MrFieldTech, 2026-10-12, first round: a repository's own secrets checks
  live in a new Session Settings key in `CLAUDE.md`, one command per check,
  run by `session-close` and CI beside `secrets.py check`.

- MrFieldTech, 2026-10-12, second round: a repository marks the kit's
  secrets standard unused by naming its own method in the Credentials
  setting in place of `kit standard`, with the reason the kit's decrypters
  do not serve. Every secrets command, check and setup step applies only
  under `kit standard`.
- MrFieldTech, 2026-10-12, second round: `secrets.py decrypt` writes a copy
  of each `<slug>.secrets.md` at the same path under a gitignored output
  directory, `--out <dir>`, with every value in plaintext, and the build
  reads the copy in place of the encrypted file.
- MrFieldTech, 2026-10-12, second round: setup adds `secrets.py check` and
  the repository's own secrets checks to its CI configuration on the task
  branch when it has one, and otherwise puts `Action needed:` at the top of
  part 1.

**Plan.** One release, 1.5.0.

1. `secrets.py decrypt --out <dir>`: every `<slug>.secrets.md`, never
   `HANDOFF.md`, copied to the same relative path under `<dir>` with each
   value written as `show` writes it. The key comes from `SECRETS_AGE_KEY`
   or `--identity`. It refuses a missing key, an output directory git does
   not ignore, and a value that will not decrypt, naming the file and label
   and never the value. With `SECRETS_CHECK_BUILD=1` it needs no key and no
   `age` tool and writes a fixed placeholder for every value. Windows line
   endings and one trailing line break are dropped, as `show` already does.
2. `.claude/kit/secrets-decrypt.mjs`: the same command for Node, with the
   same output, refusals and check build, using the `age-encryption`
   package the repository pins. `credentials.md` says a session offers it
   only when `secrets.py decrypt` cannot run in the build environment.
3. `secrets.py keys [<holder>...]`: prints the steps for making the keys on
   the owner's own computer, Windows and macOS or Linux, one per holder,
   `owner`, `build` and `recovery` by default, and what to send back. The
   session writes `secrets-recipients.txt` from the public lines returned.
   A repository that names another set in its authority file or `CLAUDE.md`
   overrules the default.
4. A new Session Settings key, **Secrets checks**, after Credentials: one
   command per check particular to the repository, or `none`. Defined at the
   end of `HOUSE.md`, given `none` in `templates/CLAUDE.md` and in this
   repository's `CLAUDE.md`. `session-close` runs `secrets.py check` and
   each of them when Credentials is `kit standard`.
5. Credentials: the template default becomes `none`. The first run sets
   `none` unless the repository already holds credentials or the owner says
   it will. `HOUSE.md` says a repository whose needs the kit's decrypters do
   not serve names its own method there, with the reason, and that every
   secrets command, check and setup step applies only under `kit standard`.
6. `credentials.md`, Setting it up, becomes the setup run when Credentials
   switches to `kit standard`: the keys by `secrets.py keys`; then a review
   of the repository that writes Secrets checks; then `secrets.py check`
   and those checks added to its CI configuration, or `Action needed:`;
   then, when a build reads the values, its first step `secrets.py decrypt`
   with the build's key as `SECRETS_AGE_KEY` on the host, a check build
   with `SECRETS_CHECK_BUILD=1`, and the output directory gitignored. When a
   person asks how to encrypt a value, the session gives `secrets.py steps`
   with that repository's keys.
7. `check.sh` fixtures for decrypt, the check build, the refusals, and
   `keys`, and for the Node decrypter when `node` and the package are
   present.
8. `VERSION` 1.5.0, a `CHANGELOG.md` entry saying what an updated
   repository must do (add the Secrets checks key; one keeping credentials
   runs setup's review), and `README.md`, its update slug `kit-update-1-5-0`.

**Outcome:** Every plan step is done and `bash check.sh` passes, with the
Node decrypter tested in full against a local `age-encryption` 0.3.1.
Release 1.5.0.

### Make Age-Encrypted Secrets Files The Kit's Standard For Credentials

**Slug:** `age-secrets`
**Status:** DONE
**Opened:** 2026-10-11
**Closed:** 2026-10-12

**Why.** MrFieldTech, 2026-10-11, in a temporary session, asked whether the
kit uses age-encrypted `<slug>.secrets.md` files for credentials. It does not:
`HOUSE.md` and `session-close` leave the method to each repository's
Credentials setting, and the kit only knows the filename, in that
`todo_sweep.py` skips `*.secrets.md`. The owner decided the process becomes
the standard way every repository installing the kit handles secrets,
tokens and credentials, and that a repository may replace it with its own.

**Background.** The owner pointed at one of their private repositories, which
already runs the process, as the model. It is not named here, because this
repository is public. What it does:

- Each credential sits beside what it belongs to in `<slug>.secrets.md`: two
  frontmatter fields, `slug` and `updated`, then one bold label per value,
  the value as an ASCII armored age block fenced and tagged `age`, and an
  optional plaintext note. The label and note never hold a value.
- Every value is encrypted on its own to every public key listed in
  `secrets-recipients.txt` at the repository root, one key per line under a
  comment naming who holds the private half. Encrypting needs only the public
  keys. Any one private key reads every value. A private key is never
  committed, never written into a state file, and never passed through a
  session.
- One script does every operation: `set` (value on standard input, never on
  the command line), `place` (store a block the owner encrypted on their own
  computer, refusing one that is not armored age, is passphrase-locked, or
  has a different number of recipients), `lock` (encrypt plaintext values in
  place), `encrypt` (print a block for Credentials In Transit in
  `HANDOFF.md`), `show` (decrypt with a key), and `rekey` (re-encrypt every
  value, `HANDOFF.md` included, after a recipient changes).
- An audit fails on a value outside an encrypted block, in a table, or in a
  fence not tagged `age`, and on an `age` block that is not armored age.
- A value with no home yet goes under Credentials In Transit in `HANDOFF.md`
  as a label and an encrypted block.
- The owner can encrypt a value on their own computer with the `age` command
  line tool and hand the session only the armored file, so the plaintext never
  enters the conversation.

**Decisions.**

- MrFieldTech, 2026-10-11: the age process is the kit's default for every
  repository, and a repository overrides it through its Credentials setting.
- MrFieldTech, 2026-10-11: the earlier rule stands that nothing is committed
  in a repository not confirmed private, encrypted or not.

**Plan.** A release of the kit: a stdlib Python tool in `.claude/kit/` that
calls the `age` command line tool, the format and the steps in a kit
document, the default in `HOUSE.md`, `session-close` and the `CLAUDE.md`
template, tests in `check.sh` with CI installing `age`, and `VERSION`,
`CHANGELOG.md` and `README.md` to match.

**Done.** Release 1.4.0: `.claude/kit/credentials.md`, `.claude/kit/secrets.py`,
`HOUSE.md`, both skills, the `CLAUDE.md` template (`Credentials: kit
standard`), `check.sh` section 6, CI installing `age`, `VERSION`,
`CHANGELOG.md` and `README.md`. This repository's own Credentials setting
stays `none`, because it is public. MrFieldTech, 2026-10-12, asked for it to
be merged and promoted to `main`.

### Fold Six Workflow Practices Into The Session Protocol

**Slug:** `workflow-practices`
**Status:** DONE
**Opened:** 2026-10-11
**Closed:** 2026-10-11

**Why.** MrFieldTech, 2026-10-11, in a session outside any repository using
the kit, had a public collection of agent skills reviewed against the kit,
a documentation repository and a static site, and accepted six of them as
worth adopting: an interview that settles a plan before it is built, a
disciplined loop for diagnosing failures, a pull request body with evidence
and a merge danger call, a reference for writing documents agents read, a
retrospective on the session's environment, and a questionnaire for
knowledge someone else holds. The rest were declined because they bring a
second work queue, a second handoff, or a second branch model.

**What MrFieldTech asked for, 2026-10-11.**
1. Integrate the six into the kit, so every repository using it has them.
2. Run the interview in the new task flow, before a task's block is
   written.
3. Have the diagnosis loop run on its own from the checks the protocol
   already runs, when one fails.
4. Copy the useful parts of the pull request body into `session-close`.
5. The aim: no new command to remember. Each practice runs at a point the
   existing workflow already reaches, or when the situation it covers
   comes up.

**Decided by MrFieldTech, 2026-10-11.** The practices live in the kit, as
part of its pinned copy, rather than as a self-updating plugin or as files
copied into each repository by hand.

**Plan.** A kit release, 1.3.0:
1. Plain reference files under `.claude/kit/practices/`, one per practice
   except the pull request body, which goes into `session-close` itself.
   They sit inside an existing kit directory, so `kit.sh` and the install
   are unchanged, and they are not skills, so no name can collide with a
   skill a repository or a harness already has.
2. `HOUSE.md` gains a short section of pointers naming when each practice
   applies, because it is the one file every turn has loaded.
3. `session-open` runs the interview before writing a new task's block;
   `session-close` diagnoses a failing Regenerate command or check before
   parking, writes the pull request body, and looks back over the session
   before writing `HANDOFF.md`.
4. `check.sh` fails when a practice file is missing, or is pointed at by
   nothing.
5. `VERSION`, `CHANGELOG.md` and `README.md`, including its update slug.
6. The source collection's license notice travels with the practices.

**Done, 2026-10-11, on the branch.** Release 1.3.0, as planned. The
practices are `grilling.md`, `diagnosing.md`, `writing-for-agents.md`,
`questionnaire.md` and `retro.md`. `session-open` grills in step 4 case c,
which cases d and the temporary session's tasks reach too, and in step 6 for
a decision a block leaves open. A blocked task gets a questionnaire while
working. `session-close` runs the retrospective at step 4, diagnoses at step
5 and at both failure points of step 8, writes the pull request body in
step 8 and the promotion's in step 9, and reports a `Retro:` line.
`bash check.sh` passes, each new guard was made to fail on purpose, and a
scratch repository on 1.2.0 updated to 1.3.0 and reported current.

A retrospective's proposals go under Open Questions in `HANDOFF.md`,
because its headings are fixed and a proposal is a decision for the owner,
not a task the session opens on its own.

**Decided by MrFieldTech, 2026-10-11.**
- The license notice, which names the source collection's author, stays
  only in `NOTICE.md` at the root and is not installed. Each practice
  credits the collection without naming it, by the project rule that a
  kit-owned file names no person.
- 1.3.0 goes to `main` at this close.
- MrFieldTech updates the repositories using the kit by the README's update
  prompt, in a session on each, rather than this session doing it.

**Closed, 2026-10-11.** Closed by 1.3.0's own `session-close`, whose pull
request bodies and retrospective ran for the first time here. Merged into
`preview` and then `main` at MrFieldTech's request.

### Promote Preview Into Main Without A Task

**Slug:** `preview-promotion`
**Status:** DONE
**Opened:** 2026-10-01
**Closed:** 2026-10-01

**Why.** MrFieldTech, 2026-10-01, in a temporary session, asked how preview
is merged into main: whether to ask a random session after `/session-close`
or to start a whole session just for the merge. Today the merge is step 9 of
`session-close`, and it runs only when the owner asked for it in that same
session. So it rides on a session that closes a task. Asking after a close has
finished does nothing, because step 9 is part of the close. A merge on its own
has no clean path: a temporary session writes nothing, `session-close` stops
at once for a temporary session that opened no task, and an ordinary session
must open a task, which adds a task block to `TASKS.md` just to carry the
merge.

**What the session found about conflicts.** Main moves only by pull requests
from preview, and when GitHub deletes preview after a promotion,
`session-close` step 8 recreates it at main's head. So main is normally an
ancestor of preview, and the promotion cannot conflict. On 2026-10-01 main
(`b114510`) was an ancestor of preview (`9c6062a`), which was 4 commits ahead
with `readme-version-update`. A merge commit on main that preview lacks, when
preview was not deleted, carries no change of its own and does not conflict
either. A real conflict needs a commit that reached main outside the protocol:
a direct push, an edit on GitHub's website, or a pull request from another
branch. Resolving one cannot happen on preview or main, since neither takes a
direct commit. It needs a task branch cut from preview that merges main in,
with the owner's answers on the conflicting files, and a pull request back
into preview. That path is already the ordinary task flow.

**What a promotion records.** Every past promotion added a line to the
`HANDOFF.md` session log, such as "merged into preview and then main at
MrFieldTech's request". A temporary session commits nothing, and it cannot
commit to preview or main either, so a promotion run from one records nothing
in the repository. The pull request into main and its merge commit are the
record on GitHub.

**Direction from MrFieldTech, 2026-10-01.** If a promotion never needs a
conflict resolution recorded, it can run as part of a temporary session,
something like `/session-open temp promote preview`, rather than on its own
branch.

**To do.** A kit release (bump `VERSION`, add a `CHANGELOG.md` entry, set the
README's update slug, keep `README.md` true):
1. Settle the open questions below with MrFieldTech.
2. Give `session-open`'s temporary session a promotion form that runs
   `session-close` step 9's three checks and, when all pass, opens and merges
   the pull request from preview into main. When a check fails, it names the
   check and stops. On a conflict it reports the files and proposes a task to
   resolve them, by the conflict rule in `HOUSE.md`.
3. Make `HOUSE.md`'s rule that a temporary session writes and pushes nothing
   name the exception: it opens and merges that one pull request. Make
   `session-close` step 9 point to the new form for a merge with no task.
4. With `Integration branch: none`, the form has nothing to do and says so.

**Decisions, MrFieldTech, 2026-10-01.**
- No keyword. `temp` is the session, and asking it to promote is an ordinary
  request in any words, which the session works out from the conversation.
- A promotion from a temporary session leaves no line in the `HANDOFF.md`
  session log. The pull request into main is the record.
- `session-close` step 9 stays, so a close still promotes when asked.

Done in release 1.2.0: `session-open`'s Temporary Session section promotes by
`session-close` step 9, waits for the checks on the integration branch's head,
stops on an open pull request into it, and offers a task on a conflict.
`HOUSE.md`, `session-close` step 9, `README.md`, `VERSION` and `CHANGELOG.md`
match.

Merged into preview and then main at MrFieldTech's request on 2026-10-01.

### Keep The README Update Prompt On The Current Version

**Slug:** `readme-version-update`
**Status:** DONE
**Opened:** 2026-09-30
**Closed:** 2026-09-30

MrFieldTech, 2026-09-30: the README's copy and paste block for updating
Claude-Kit in a repository opens with
`/session-open kit-update-<new version with hyphens>`. Make that line name the
version the kit is currently on, and keep it current: every version change
already changes the repository, so it updates the README to the version a
repository can update to as well.

Done: the update block's slug reads `kit-update-1-1-0`, the text
above it says the slug names the current release, the README's and
`CLAUDE.md`'s release rules add setting that slug, and `check.sh` section 4
fails when the slug does not match `VERSION`. README and `check.sh` are not
kit-owned, so this is not a release.

### Add A Temporary Session

**Slug:** `add-session-temp`
**Status:** DONE
**Opened:** 2026-09-30
**Closed:** 2026-09-30

MrFieldTech, 2026-09-30: there should be a temporary session option that
opens a session for questions about the repository and its details without
creating a task branch or anything that follows from one. If, during a
temporary session, MrFieldTech asks for branches to use later, creating them
is fine, but the temporary session itself creates none of that. MrFieldTech
asked for opinions first.

**Decided by MrFieldTech, 2026-09-30.**

1. The command is `/session-open temp`. If the owner later wants to build or
   keep something, the session asks for a slug or takes the one given,
   checks out that task's branch, and either records what is to be kept or
   starts building.
2. When a decision or a request for work comes up, the session offers to
   turn itself into a task or to open a new one, whichever fits, and may
   offer several when the session covered several topics.
3. A branch for later is a parked task, and its block records why it was
   made, what it is for, and as much background as it needs.

**Done, 2026-09-30, on the branch.** Release 1.1.0: a Temporary Session
section in `session-open`, a paragraph in `HOUSE.md`, `temp` reserved in
every repository, `session-close` stops with nothing to close for a temporary
session that opened no task, and `README.md` and `CHANGELOG.md` describe it.
`bash check.sh` passes. Not yet tried in a real temporary session.

**Closed, 2026-09-30.** MrFieldTech asked for 1.1.0 to reach `main`.

### Encrypt Credentials Committed In Transit

**Slug:** `multi-line-secrets`
**Status:** DONE
**Opened:** 2026-09-28
**Closed:** 2026-09-28

MrFieldTech, 2026-09-28: step 4 of `session-close` says a value held under
Credentials In Transit in `HANDOFF.md` is kept "in full plaintext". A
project's authority file says such values are encrypted, and it wins in that
project, but the kit should not say the opposite. Secrets should be
encrypted in transit. Make the kit hold a committed credential only
encrypted, by a method the Credentials setting names, keep the kit generic,
and record a value that spans more than one line, such as an encrypted
block or a key file, so that it survives whole.

**Done, 2026-09-28, on the branch.** Release 1.0.5: `HOUSE.md` never commits
a credential in plaintext, and the Credentials key names the encryption
method, the tool and the public key or recipient, for any place inside the
repository. `session-close` step 2 encrypts a value bound for a committed
file by that method and checks the output does not contain it, and sends it
to the close report as the only copy when no method is named or the
container cannot run it. Step 4 holds a value under Credentials In Transit
encrypted, with its method. A value that spans lines is kept whole in a
fenced block of its own, in `HANDOFF.md` and in the report. `bash check.sh`
passes.

**Closed, 2026-09-28.** MrFieldTech kept the rule that nothing is committed,
encrypted or not, unless the repository is confirmed private, and asked for
1.0.5 to reach `main`. The repository whose authority file requires
encryption names its method in its Credentials setting when it takes 1.0.5.

### Prepare The Repository To Go Public

**Slug:** `go-public`
**Status:** DONE
**Opened:** 2026-09-26
**Closed:** 2026-09-27

MrFieldTech, 2026-09-26: Claude-Kit is to be made public, so any session can check
and take updates without attaching it. They would rather the repository hold no direct reference to their other projects. The only one in the tree is the list of
project terms in `check.sh`, which guards the kit-owned files against a
project's details leaking in. Keep the guard, but move the list out of the
repository into a GitHub Actions secret, add a generic guard against
addresses that needs no list, and bring `README.md`, `CLAUDE.md` and the state
files up to date for a public repository. MrFieldTech changes the visibility.

**Done, 2026-09-26.** `check.sh` no longer holds the list. It reads the
`KIT_PRIVATE_TERMS` secret in CI, or an untracked `.private-terms` file
locally, and skips the name check with a notice when it has neither. A new
pattern check refuses web addresses, email addresses and host names in
kit-owned files with no list at all. Each guard was made to fail on purpose,
and the current kit passes the old list. `README.md`, `CLAUDE.md` and
`HANDOFF.md` now describe a public repository.

What is left is MrFieldTech's: the secret, so CI checks names again, and the
visibility. The task closes when both are done.

**Done, 2026-09-26, second session.** MrFieldTech chose to leave the history
as it is, and to have the repository's own files name the owner by the
account, so `CLAUDE.md`, `TASKS.md` and `HANDOFF.md` now say MrFieldTech. The
secret is optional: without it CI skips the name check and says so, and the
address check still runs.

**Done, 2026-09-27.** A review of every commit, every version of every file
and every pull request description found no credential, key, password,
private address or surname. From its findings, at MrFieldTech's request:
release 1.0.4 has `kit.sh update` name the source it fetches and runs and
pass it to `git clone` after `--`, and the update prompt in `README.md` has
the session confirm that source first, which works from every earlier
`kit.sh`; an update from 1.0.2 to 1.0.4 was tested. `check.sh` fails when a
pattern cannot be searched rather than passing. CI runs with a read-only
token and a pinned checkout action. Both prompts in `README.md` say to paste
them only into your own repositories. Two sentences that pointed at the old
list in the history came out of this file and `HANDOFF.md`, and fourteen
pull request descriptions now name MrFieldTech. MrFieldTech keeps the
history, including the company address on the merge commits.

Closing this task, GitHub declined recreating `preview` with
`GH007: Your push would publish a private email address`: MrFieldTech had
turned on email privacy, and `main`'s head was a merge made under the old
address. The branch was created through the GitHub API instead, and 1.0.4's
`session-close` now does the same when the push is declined.

**Closed, 2026-09-27.** MrFieldTech made the repository public. GitHub
reports it as not private, and its page loads for a visitor who is not
signed in.

### Pilot The Kit In A Second Repository

**Slug:** `first-pilot`
**Status:** DONE
**Opened:** 2026-09-24
**Closed:** 2026-09-26

MrFieldTech runs the first install outside the repository the skills came from, in a
fresh session on the second repository they chose, with Claude-Kit attached to
the session because it is private. They say the install prompt in
`README.md`. The first run should settle its Session Settings, asking only
what it cannot, remove the response-format section its existing `CLAUDE.md`
repeats from `HOUSE.md`, and push its first task branch.

Each defect the pilot finds is fixed here on this task's branch, released as a
patch version, and taken by `kit.sh update` in every repository that has the
kit. Record here what the pilot found, without naming the repository.

**Found, 2026-09-24.** The first attempt stopped before anything was
written, on two gates in front of the install, and asked MrFieldTech three
questions rather than work around them.

1. Auto mode's classifier blocked `kit.sh install` as `[Self-Modification]`,
   because it writes into `.claude/skills/`. The rule is a soft block, and
   `claude auto-mode defaults` says it clears only when the owner's message
   names the configuration change as wanted. The install prompt only said
   "install". Allow rules cannot clear it: they do not pre-approve writes into
   `.claude/`, and one would have to be written there.
2. The cloud session's instructions allow a push only to the branch it was
   assigned, and the first run pushes `task/kit-setup`. The session asked
   which to use. Once the kit is installed, `HOUSE.md` settles it, but the
   first run reads `HOUSE.md` too late.

Both are fixed in `README.md`, not in a kit-owned file, so there is no
release: the install prompt now names the writes into `.claude/` and
`CLAUDE.md` as wanted and gives permission to push the `task/` branch, says
why, and gives Accept edits mode as the fallback.

**Found, 2026-09-25.** The second attempt, with the fixed prompt, got past
the classifier, installed 1.0.0, named `task/kit-setup` as the branch it
would push, and stopped at six questions. MrFieldTech's answers, and what they
changed in 1.0.1:

1. The Owner was asked, with two names to choose from. MrFieldTech: the Owner is
   a placeholder for whoever answers, and is set without asking. It is now
   the account in the repository's remote URL.
2. The integration branch was asked, because the repository's contributing
   guide releases from `main`. MrFieldTech: `preview`, without asking. It is now
   asked only when a `preview` branch already exists.
3. The checks CI runs need a tool the container lacked, so the session asked
   whether to list them. Listed, they would fail at every close and park
   every task. Checks before merge now holds only commands the container
   runs, and CI runs the rest.
4. The existing `CLAUDE.md` repeated `HOUSE.md`'s response format. MrFieldTech:
   there should be no duplicate. A section that only repeats `HOUSE.md` is
   now removed without asking.
5. The repository's `.gitattributes` would let a Windows checkout give
   `kit.sh` CRLF endings, which bash cannot run. A fix in one repository
   reaches no other, so each kit directory now carries its own
   `.gitattributes`. A scratch clone with `core.autocrlf=true` confirmed it.
6. The contributing guide's file list did not name the kit's files. MrFieldTech:
   add them. The first run now does, without asking.

The environment's end-of-turn hook also told the session to commit the
uncommitted install to its assigned branch while it waited for answers. The
session refused on its own judgement. `session-open` now says to.

MrFieldTech also asked for a shorter install prompt, and `README.md` has one.

**Found, 2026-09-25, third attempt.** With 1.0.1 and the shorter prompt, the
session attached and cloned the kit, installed it, settled every setting
without asking, removed the repeated response-format section, added the
kit's paths to the contributing guide, and pushed `task/kit-setup` without
touching its assigned branch. Auto mode blocked registering the kit's clone
as a repository of the session, which did no harm, and `README.md` now says
that registration is not needed. MrFieldTech's review of its reply, fixed in 1.0.2:

1. The reply listed every Session Setting, which the people reading it do
   not need. It no longer lists them.
2. Automatically delete head branches was asked as a question. The workflow
   needs it, so it is now an `Action needed:` notice.
3. The session asked whether the contributing guide's release step, which
   pushes straight to `main`, or the kit's rule should hold. MrFieldTech: a
   project file that contradicts the kit rightly needs the owner's answer.
   The first run now asks this by rule rather than by the session's own
   judgement.

**Where it stands.** 1.0.2 is on `preview`. The pilot repository has 1.0.1
on its `task/kit-setup`, its session waiting on MrFieldTech's answer about the
release step. MrFieldTech, 2026-09-25: 1.0.2 goes to `main`, and the pilot
repository is rolled back and installed again with it rather than carried on
to `/session-close` on 1.0.1.

**Found, 2026-09-25, fourth attempt.** With 1.0.2 and the 1.0.1 prompt, auto
mode blocked the session's first step, attaching the kit's repository, as
`[Untrusted Code Integration]`. The first three attempts attached it with the
same kind of prompt, so the classifier does not decide the same way every
time. `claude auto-mode defaults` says the rule is a soft block that clears
when the owner names the external source being integrated. The session
changed nothing, refused to fetch the kit another way, and asked. The
install prompt in `README.md` now calls the repository the owner's own and
names running its `kit.sh install`, and the README says how to answer a
session that stops on a block. No kit-owned file changed.

**Found, 2026-09-25, fifth attempt.** With the prompt that named the kit as
the owner's source, the session attached, cloned and registered the kit, read
it, surveyed the repository, and was blocked at `kit.sh install` by the
server-side classifier, which gave no reason. The session stopped, changed
nothing, and offered the exact sentence to approve the command. Of five
attempts, two were blocked at the installer, one at attaching the kit, and
two passed, so no wording makes the install certain. MrFieldTech, 2026-09-25:
install sessions stay in Auto mode and a block is answered when it happens,
and the prompt may be as long as it needs, because it is pasted from the
README. The prompt is now one numbered step per action the classifier
reviews, and asks the session to stop with the approving sentence when a
step is blocked anyway. No kit-owned file changed.

**Found, 2026-09-26, sixth attempt.** With the rebuilt prompt, the install
went through with no block, and the first run settled every setting, asked
only about the contributing guide's release step, which pushed straight to
`main`, and pushed its first task branch. MrFieldTech answered to change the guide.
`/session-close` then marked the task done, created `preview`, merged into it
and on into `main` as asked, after CI passed on both pull requests, and GitHub
deleted both branches. The repository is on 1.0.2 with only `main` left.
MrFieldTech's review, fixed in 1.0.3:

1. The status block came out broken apart. It is now one fenced block with no
   backticks inside.
2. The close took about seventeen minutes: CI ran in full on both pull
   requests, and the session waited on a check-in sixteen minutes out. MrFieldTech:
   recheck about once a minute if that costs little, which it does, and skip
   the second run when nothing changed. `session-close` now does both.
3. The session log row said the task reached `preview`, not `main`. It now
   records a merge into the default branch the owner asked for.
4. MrFieldTech asked whether a repository updates itself. It does not, by design:
   `session-open` reports a newer release, and `README.md` now has the update
   prompt.

**Closed, 2026-09-26.** The kit installs and runs a full round in a second
repository. The pilot repository takes 1.0.3 by the update prompt when MrFieldTech
asks.

### Build The First Release

**Slug:** `release-1-0`
**Status:** DONE
**Opened:** 2026-09-24
**Closed:** 2026-09-24

MrFieldTech, 2026-09-24: the session skills they run in one repository should work in any of their repositories. A repository that has never used them gets a
first-run path that builds its state files, and the rules for how Claude works
and answers are shared the same way. This repository is the single source,
installed into each repository as a pinned copy.

**What 1.0.0 is.** `HOUSE.md`, the two skills, `kit.sh`, `todo_sweep.py` and
the templates, drawn from the existing skills with every value specific to one
repository moved into Session Settings. `check.sh` and the CI workflow guard a
release.

**How it was verified.**

1. `bash check.sh` passes, and each of its guards was made to fail on purpose
   to prove it can: a project term, an em dash, an unrecorded version, a skill
   the model could invoke, a stale `TODO.md`, and a broken `kit.sh`.
2. A scratch repository with a local remote went through the first-run path by
   the skill text alone: settings proposed, state files written on a pushed
   task branch, the task worked, closed, parked for want of a pull request,
   and resumed from a fresh clone. It was walked by hand, because the
   permission classifier refused to start a headless `claude` session with its
   permissions bypassed. The walk found four defects in the skill text: the
   default branch read with `origin/` still on it, a `CLAUDE.md` with no
   title, the kit check run before the kit is on the base, and a merge that
   created the integration branch before learning no pull request could be
   opened. A review pass after it found three more: the first task falling into
   the case that stops to ask, two credential rules that overlapped, and a
   pending combined status read as a running check. All seven are fixed.
3. The repository the skills came from installed 1.0.0 in place of its own
   copies. A fresh session there has not run it yet; `HANDOFF.md` flags it.

**Decided by MrFieldTech, 2026-09-24.** 1.0.0 reaches `main` before the pilot, so the
pilot installs by the command in `README.md`. No permission rule is added for a
headless `claude` session: the pilot and their own sessions in real repositories
are the fresh-session tests. At close they asked for everything to reach `main`.

The pilot is `first-pilot`.
