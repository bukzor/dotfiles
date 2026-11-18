---
source: agent
status: exploratory
see-also:
  - rule-architecture.md
  - spectrum-not-singular.md
---

# Candidate: ambient in `~/.claude/CLAUDE.md`

Place the spectrum-not-singular principle directly in
`~/.claude/CLAUDE.md`, near the top, as part of "Behavioral Posture"
or as its own foundational section. The rule loads on every turn
without trigger conditions.

The fit is good because the principle subsumes other rules already
ambient in CLAUDE.md (the 80% threshold, the "give specific point
estimates" guidance, the "discuss with user if unclear" item). Those
existing rules are subordinate to the spectrum framing — once
spectrum-not-singular is foundational, they read as natural
consequences.

The cost is token budget: CLAUDE.md is loaded on every turn, so
adding a substantive new principle inflates every-turn context.
This is the same tradeoff that motivated the original migration of
ambient rules into trigger-gated `must-read.d/` files (commit
01dc2d3, see `../../rule-architecture.md`). The savings from that
migration are at risk if spectrum-not-singular adds back a similar
amount of text.

The risk has a precedent counter-pattern: the migration that saved
tokens is exactly what narrowed the rules' scope and produced this
session's failures. Adding spectrum-not-singular back to CLAUDE.md
is partly an admission that some rules can't safely be lazy-loaded.
The token cost is real but bounded; the alternative (lazy-loading a
foundational rule) has compounding scope-narrowing costs.
