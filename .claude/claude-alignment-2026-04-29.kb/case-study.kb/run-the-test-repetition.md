---
source: mutual
status: firm
see-also:
  - failure-modes.kb/eyes-shut-guessing-under-rejection.md
  - failure-modes.kb/variant-execution-of-pasted-commands.md
---

# Run-the-test repetition

After the workaround was restored, the user said: "run the test that
you ran **right before we went on this escapade** as I requested,
at that time." The reference was to a specific pyright invocation
the prior Claude had executed earlier in the session. The exact
command was visible in the conversation history.

The prior Claude ran a near-variant: `pyright -p <project-root>
<absolute-path>` instead of `cd <repo-root> && pyright <relative-path>`.
The user rejected: "=.= that's not the test."

The prior Claude ran another variant: `cd <repo-root> && pyright
<relative-path>` — closer, but still not the originally-referenced
command. The user rejected more sharply: "that too, is not the test
SHAPE UP."

The prior Claude then ran `pyright foo.py` (a different file, the
user's earlier reproducer demo). The user rejected with frustration:
"....... Please copy paste from the command."

Only after the user copy-pasted the literal command did the prior
Claude run it correctly.

The pattern: after each rejection, the prior Claude generated a new
candidate from short-term association rather than scanning the
visible tool-call history for actual prior invocations. The history
was right there. The prior Claude's posterior should have dropped
after each rejection, prompting an enumerate-then-pick approach;
instead each new guess was issued with similar confidence to the
last. The user's framing in the realignment afterward: "I've never
seen you stop and list possible disambiguations when rejected; you
always forge ahead a different path confidently."
