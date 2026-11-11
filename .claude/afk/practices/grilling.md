# Grilling

Settle what a task is before it is written down. A task's block is its
specification, and a block written from a guess is the fluent and wrong
output `HOUSE.md` warns about. Grilling interviews the owner relentlessly
about every decision the task depends on, so the block records decisions
rather than assumptions.

`session-open` runs this on a new task's branch, right after the claim, and
for any decision a task's block leaves open before the step that needs it. It also
runs whenever the owner asks for a plan, a design or an idea to be
stress-tested, in any words.

## The design tree

Treat the request as a tree of decisions, where each decision opens the
decisions that hang off it. The **frontier** is every open decision whose
prerequisites are already settled: the questions that can be asked now
without guessing at an answer not yet given.

## Facts are the session's, decisions are the owner's

Before asking anything, look up every fact the repository, its state files,
its history or a command can answer. A question to the owner is a decision,
or a fact only the owner holds. A fact that only someone other than the
owner holds goes into a questionnaire, by `questionnaire.md`, and the
decision that waits on it stays open.

A lookup holds up only the questions that wait on it. Ask the rest of the
frontier now, and the waiting questions once the fact is in.

## Rounds

Ask the whole frontier in one round, in the numbered question format
`HOUSE.md` sets. Each question carries the context it needs and the
session's recommended answer, listed first as option `a` and marked
`(recommended)`, so the owner can accept a round with `1a, 2a`, or with
`all recommended`.

Before asking a round, write it into the task's block as its open
questions, numbered, with their options, and commit and push. A round asked
only in the reply is lost with the conversation.

Then wait for the answers. Each answer settles a branch and opens the
decisions behind it. Remove the answered question from the block and write
a decision in its place under the block's decisions: the owner's name, the
date, what was decided, what it changes and why, in the owner's sense rather
than their words. The block keeps decisions, never a transcript of the
rounds. Commit and push, recompute the frontier, and ask the next round. A
question whose answer depends on another question in the same round
belongs in a later round.

## Done

Grilling is done when the frontier is empty: every branch visited, nothing
left silently assumed, and the owner agreeing the understanding is shared.
A request that already settles every branch takes no round at all. Say so
in one line and go on.

When the session has to stop before the frontier is empty, the open round
is already in the block. Its stopping point names that round, and the task
parks as usual. Open questions stay in the block, and reach `HANDOFF.md` only
when the task blocks on one or closes with one unanswered.

When grilling shows the task should not go ahead, because the owner
dismisses it or it duplicates another task, mark it `DISMISSED` with a
`Dismissed:` line saying why. It merges at close like a finished task, so
its branch is deleted and its block keeps the reason. A slug that turns out
misleading stays, because it is a label; the task is dismissed and another
opened only when the owner asks.

Grilling with no task, such as a plan stress-tested in a temporary session,
asks its rounds in the reply until the owner keeps the result as a task.

Adapted under the MIT License from a public collection of agent skills.
`NOTICE.md` in the kit's own repository holds its notice.
