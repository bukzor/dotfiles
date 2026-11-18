---
source: mutual
status: firm
see-also:
  - user-conventions.kb/questions-are-fact-queries.md
  - failure-modes.kb/parse-not-updated-after-correction.md
---

# Rule architecture: ambient vs trigger-gated

The instructions Claude operates from are organized in a hierarchy of
scope. `~/.claude/CLAUDE.md` holds *ambient* rules that always apply
to every turn. `~/.claude/must-read.d/` holds *trigger-gated* rules
that apply only when their trigger condition fires (typically a
`when/`, `before/`, or `after/` directory).

Trigger-gating is a token-efficiency optimization: it lets specific
guidance load lazily so that ambient instructions stay short. The
optimization is sound for guidance whose applicability is genuinely
narrow (e.g., rust programming guidance does not need to be loaded
during prose editing). It misfires for rules whose applicability is
broad — rules that should fire across many trigger conditions but
have no convenient way to enumerate them all.

The session evidence: two rules originally placed ambiently in
`~/.claude/CLAUDE.md` —

> "Treat disagreement and questioning as requests for deeper analysis,
> not grounds for immediate reversal"
>
> "Propagate corrections — trace revised assumptions to their source
> and re-evaluate"

— were moved into trigger-gated `must-read.d/` files in commit
`01dc2d3` ("Extend trigger-based guidance: add
contradicting-a-previous-response trigger"). The triggers attached
were "retracting or conceding a claim" and "contradicting a previous
response" — narrow conditions that match position changes but not
parse corrections, mid-task questions, or elided-subject mismatches.
The rules' practical effect narrowed sharply.

The structural finding: some rules cannot be trigger-listed without
losing scope, because their failure modes are too varied to enumerate
in advance. "Propagate corrections" applies to position changes, parse
corrections, behavior changes, mode changes, and others not yet seen.
"Questions are requests for analysis" applies to all questions, not
just questions about a position. These rules belong ambient.

The user explicitly invited a rethink of the must-read trigger
mechanism in light of this finding: "We need to entirely rethink the
'must read' trigger. I was never satisfied with it, but it's the best
we came up with that day. Perhaps today's experience sheds light on
what's better."
