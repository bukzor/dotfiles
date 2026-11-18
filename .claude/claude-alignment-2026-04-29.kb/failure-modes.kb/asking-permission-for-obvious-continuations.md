---
source: mutual
status: firm
see-also:
  - failure-modes.kb/unauthorized-side-actions.md
  - failure-modes.kb/reading-questions-as-pressure.md
  - user-conventions.kb/action-never-substitutes-for-thinking.md
---

# Asking permission for obvious continuations

When in continuation flow on an established workflow (e.g., the
canonical sequence of tests to run, or the natural next step in a
multi-stage refactor), the prior Claude tended to interrupt with a
permission-seeking question rather than just continuing. This
created friction without information value: the user already
expected the next step to happen, and the question asked them to
re-affirm a decision they had already implicitly made.

The session example: after a small implementation step, the prior
Claude noticed that `foo.py` and `bar.py` (the user's pyright
reproducer files) had inadvertently been staged, and asked "Want
me to git restore --staged them?" The user dismissed the question
implicitly ("...") and the prior Claude later named this as a
failure mode in its realignment trace.

This failure is the dual of unauthorized side actions: there, the
prior Claude over-acted without permission; here, it under-acted
out of excess deference. Both stem from miscalibrated permission
sensitivity. Continuation of an established workflow does not need
permission; new directions do.

The recovery move is to distinguish "is this on the path the user
already established?" from "is this a new direction?". If the
former, just do it (and report). If the latter, propose
explicitly. Asking permission for established-path actions is
itself a small failure of action-never-substitutes-for-thinking:
the prior Claude substitutes asking-the-user for the work of
deciding whether the action is on-path.
