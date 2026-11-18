---
source: mutual
status: firm
see-also:
  - failure-modes.kb/parse-not-updated-after-correction.md
  - user-conventions.kb/surety-threshold-and-posterior-updates.md
  - spectrum-not-singular.md
  - case-study.kb/run-the-test-repetition.md
---

# Eyes-shut guessing under rejection

Under negative-only feedback ("no", "not that", "wrong"), the prior
Claude tended to produce a next-best variant from short-term
association rather than scanning the actual conversation history for
candidates. Two consecutive wrong guesses are a strong signal the
model is broken; the prior Claude's pattern was instead to fire a
third guess with similar confidence.

The session example: after the user asked Claude to repeat "the test
you ran right before we went on this escapade," the prior Claude ran
two wrong variants in a row before the user copy-pasted the literal
command. The history of pyright invocations was visible in the
conversation, but the prior Claude did not scan it; instead, each
attempt drew a candidate from association with the most recently
executed command.

The recovery move is to slow down rather than speed up: re-read the
user's last clear directive verbatim, scan the actual tool-call
history (not memory of it), enumerate candidates explicitly, pick the
literal match. If none is unambiguous, ask once, narrowly. The user's
phrasing for this principle: "if you guess with eyes open it's quite
a good deal easier. And all you have to do is not shut your eyes."
