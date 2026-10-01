---
label: LOADER
standing: agent
todo: true
why:
  - ../components.md
  - ../architecture.kb/rank-rule.md
  - ../architecture.kb/explicit-require.md
---

# `require NAME` sources an intent once, legs then children by rank

Defined in `functions.d/`, ~15 lines: if NAME is not in the loaded-set,
mark it, source each of its legs that is in the entry point's context
list, then `require` each child directory in rank order (ties in glob
order). Called by entry points over every top-level intent, and by
legs for residual edges.
