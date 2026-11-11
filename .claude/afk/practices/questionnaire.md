# Questionnaire

Gather answers that someone other than the session must give, in one
document they fill in on their own time, or go through with the owner in a
meeting. The numbered questions in a reply are for the owner, now. A
`TODO:` holds one question where it belongs in a file. A questionnaire is
for a person who holds what the session cannot look up, or for the owner
when the answers need time, records, or someone else.

It applies when:

- A task is about to go `BLOCKED` on more than a couple of such questions.
- Grilling, by `grilling.md`, finds facts that only someone other than the
  owner holds.
- The owner asks for a way to get answers from someone else, or for the
  open questions or `TODO:` items of part of the repository to be answered
  in one sitting, in any words.

## 1. Ask about the send, not the subject

The owner can always answer two things, so ask both in one round:

- **Who is it for?** Their role, what they know that the owner does not,
  and how technical they are. This sets the tone and how much context each
  question carries.
- **What is needed back?** The decisions or facts the owner cannot settle
  alone, as a concrete list.

When the owner is the recipient, both are known already, so go on.

## 2. Write it

Aim every question at the gap between what the recipient knows and what is
needed. Put the most important first, because an answer may come back only
once. Give each question one idea. Group questions under a heading per
theme once there are more than a handful. Done when every item from step 1
has a question.

```markdown
# <Title>

**Purpose:** why this exists, and the decision that rides on it.
**From:** <the owner> **To:** <the recipient>
**How your answers are used:** <where they go>

## Context

One paragraph for someone who was not in the conversation. Enough to answer
well, not a page.

## How to answer

When it is needed by, and roughly how long it takes. "I don't know" and a
partial answer both help: mark what you are unsure of rather than skipping
it.

## <Theme>

### <One question>

_Why this matters:_ only where the question could be misread or invite a
throwaway answer.

>

## Anything else?

Anything we did not ask that we should know?
```

## 3. Hand it over

The questionnaire stays out of the repository. It goes to the owner whole,
in a fenced block of its own so it copies in one piece. The task's block
records that it was sent, to whom, and each of its questions, so a later
session can match the answers.

It asks where a credential is kept and never for its value. A value travels
only by the Credentials setting in `CLAUDE.md`.

When answers come back, each goes where its question belongs: a `TODO:`
answered in its file, a decision into the task's block with the
recipient's name and the date, a fact into the file that records it.

Adapted under the MIT License from a public collection of agent skills.
`NOTICE.md` in the kit's own repository holds its notice.
