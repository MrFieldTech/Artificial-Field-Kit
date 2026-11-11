# Writing For Agents

How to write a file an agent reads as instructions: `CLAUDE.md`, the
authority file, a skill, a file one of them points at, and in the kit's own
repository every kit-owned file. An agent takes the same path through a
well written file on every run. A badly written one gives a different result
each time, and nobody notices until it matters.

This applies before any task writes or edits one of those files, including
when `session-close` moves a decision into `CLAUDE.md` or the authority file.

## Pointers

A **pointer** is a line an agent always has loaded that names material it
does not have loaded, and says when to reach it: a skill's description, a
line in `CLAUDE.md` naming a file, a line in `HOUSE.md` naming a practice.
The pointer's wording, not the material, decides whether the agent reaches
it. When an agent misses something it should have read, sharpen the pointer
before copying the material in.

- Lead with the word that should trigger it.
- Name each distinct case that should trigger it, once. Synonyms for one
  case are one case.
- Leave out what the material itself says.

## Two costs

- **Context.** Everything always loaded, `CLAUDE.md` with what it imports
  and every skill's description, costs tokens and attention on every turn,
  whether or not it applies.
- **The owner's memory.** Anything reached only when the owner remembers to
  ask for it costs them instead. Spend it only where their judgement is the
  point.

Material behind a pointer costs only the pointer's line until it is needed.

## Where material sits

Most immediate first:

1. **Steps in the file:** what the agent does, in order.
2. **Reference in the file:** rules and facts consulted as needed.
3. **Reference in another file,** behind a pointer, loaded only when the
   pointer fires.

Keep in the file what every case needs, and put behind a pointer what only
some cases reach. Keep a concept's definition, rules and exceptions together
under one heading. A file too long for its job thins the agent's attention
across every extra line, live or not.

## Steps end on a test

Every step ends on a condition that tells the agent it is done. A vague one,
such as "understanding reached", lets the agent stop early because the next
step is in view. A clear one, such as "every changed file accounted for",
can be checked and pulls the work to completion. The strongest are both
checkable and exhaustive.

## Leading words

A **leading word** is a compact concept the model already knows, used as a
token rather than explained: a _tight_ loop, a _red_ command, the
_frontier_. Repeated, it anchors the same behaviour wherever it appears, in
fewer words than a definition. Look for a phrase spelled out in several
places that one word could replace.

State the behaviour wanted. A prohibition puts the forbidden behaviour in
front of the agent and can make it more likely. Keep a prohibition for a
hard guardrail with no positive form, and pair it with what to do instead.

## Pruning

- **One source of truth.** Each rule lives in one place. A copy drifts, and
  costs tokens besides.
- **The environment is a source.** A file that restates what a command, a
  config file or the directory layout already shows is a cache that goes
  stale. Write down what looking cannot find: the unwritten convention, the
  reason behind a choice, the gotcha no config admits.
- **Relevance.** A line that no longer bears on what the file does comes
  out, even when removing it feels riskier than keeping it.
- **No-ops.** A sentence that tells the agent what it does anyway changes
  nothing and costs every time. Delete the whole sentence. A word too weak to
  change the default gives way to a stronger word, not to more words.

Adapted under the MIT License from a public collection of agent skills.
`NOTICE.md` in the kit's own repository holds its notice.
