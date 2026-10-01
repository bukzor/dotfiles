---
source: agent
status: exploratory
see-also:
  - rule-architecture.md
  - spectrum-not-singular.md
---

# Candidate: trigger-gated in `~/.claude/must-read.d/`

Place spectrum-not-singular as a trigger-gated entry under
`must-read.d/before/` or `must-read.d/when/`. The trigger condition
would fire on something like "before producing a parse, inference,
or interpretation" or "when generating an answer under uncertainty."

The fit is good for token economy: the rule loads only when its
trigger condition is met, keeping the every-turn context tight.

The cost is exactly the failure mode this kb already documents.
Trigger-gated rules narrow in proportion to how cleanly their
triggers enumerate the relevant cases. Spectrum-not-singular applies
to *every* parse and *every* answer — the rule's coverage is
universal, which means there's no narrow trigger that captures it.
A trigger that fires "before any answer" is not really a trigger;
it's an ambient rule with extra ceremony. A narrower trigger
("before answering an ambiguous question") creates exactly the
narrowing problem.

This candidate's cost is structural, not just textual. See
`../../rule-architecture.md` for the analysis of the
ambient-vs-trigger-gated tradeoff. Spectrum-not-singular is a
specific instance of a rule whose failure modes are too varied to
trigger-gate safely.
