---
label: FALSE_EDGE_BUDGET
standing: agent
why:
  - ../requirements.md
  - ../../../sh-config-loading.claims.md
---

# The layout asserts only orderings some leg needs

A false edge costs nothing at runtime and misstates the design; the
budget is the number a reader must explain away. Today's total order
asserts ~all pairs; the target is the true relation (~3 edges after
COMMUTE) plus whatever nesting adds for legibility, each of those
named in a `require` or a rank a reader can see.
