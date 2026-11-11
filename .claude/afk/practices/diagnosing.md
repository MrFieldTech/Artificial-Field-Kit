# Diagnosing

Find the cause of a failure before changing anything to fix it. A fix
written from a theory can turn a check green without touching the cause,
and the next session trusts the green.

This runs whenever something fails that should pass: a command under
Checks before merge, a check GitHub runs on a pull request, a Regenerate
command, a build, or a command the work relies on. It runs when the owner
reports something broken, wrong or slow, in any words, and from the start
of a task whose work is a fix. `session-close` runs it before it parks a
task on a failure.

## 1. Get a red command

Everything below depends on one command that goes **red** on this failure:
it drives the code path that fails and checks the exact symptom, so it
fails now and passes once the cause is fixed. With it, the cause will be
found. Without it, reading code only produces theories, so no hypothesis
comes before it.

A failing check is usually that command already. Otherwise build one, trying
these roughly in order:

1. The repository's own test or check, narrowed to the failing case.
2. A request to the dev or preview server, compared with the expected
   status, header or body.
3. The command run on a fixed input, its output compared with a known good
   copy.
4. A headless browser script, when the container has a browser, that drives
   the page and checks the page, its console or its network requests.
5. Two runs compared: the old version against the new, or one setting
   against another.
6. A bisection over the commits between a known good and a known bad state.

Make it **tight**: seconds rather than minutes, the same verdict every run,
and checking the symptom itself rather than that nothing crashed. A failure
that happens only sometimes is run in a loop until it reproduces often
enough to work with.

When no red command can be built, stop and say so: what was tried, and
what would make one possible, such as access to the environment where it
fails, or a log or capture from it.

## 2. Reproduce and shrink

Run it and watch it go red. Confirm it fails the way the owner or the check
described, and not with some nearby failure, because the wrong failure gets
the wrong fix. Then cut inputs, steps and settings one at a time, running it
after each cut, until every part left is needed for it to fail.

## 3. Rank hypotheses

Write three to five possible causes, most likely first, each with the
prediction that would prove it wrong: "if X is the cause, changing Y makes
it pass". A cause with no such prediction is sharpened or dropped. When the
owner is present, show the list before testing it, since they may already
know which one it is. When they are not, test in the ranked order.

## 4. Instrument

Test one prediction at a time, changing one thing at a time. Prefer reading
state directly over adding output. Every temporary log line carries one tag
unique to this diagnosis, such as `[DEBUG-a4f2]`, so a single search finds
every one of them to remove.

## 5. Fix, and guard against its return

Where the repository has a test or a check that reaches the real failure,
add the failing case there first, watch it fail, then fix and watch it
pass. Where nothing reaches it, fix it anyway and record the gap in the
task's block, where the retrospective in `retro.md` turns it into a
proposal. Then run the red command from step 1 again on the original case.

## 6. Clean up

Done when all of these hold:

- The red command from step 1 passes.
- The new test passes, or the task's block says why there is none.
- A search for the tag finds nothing.
- Anything built only to diagnose is removed.
- The fix's commit message names the cause that proved true, so the next
  session learns it.

A diagnosis that cannot finish in this session is written into the task's
block: the red command, the hypotheses already ruled out, and the next one
to test. That is where the next session resumes it.

## Credentials in output

Commands, logs and captured requests show credentials easily. Show the line
around a value with the value replaced by `<REDACTED>`, and pass a
credential to a command through the environment rather than its arguments.
A value found somewhere it should not be falls under the credential rule in
`HOUSE.md`.

Adapted under the MIT License from a public collection of agent skills.
`NOTICE.md` in the kit's own repository holds its notice.
