---
label: RANK_RULE
standing: agent
why:
  - ../architecture.md
  - prerequisite.md
  - ../../../sh-config-loading.claims.md
---

# One rule orders a directory: legs, then children by rank

Within a directory, legs are sourced before subdirectories; an entry's
rank is its numeric prefix, unbounded if none; entries of equal rank
are unordered; ranks ascend. Numbers assert order, names assert none.
Nesting-by-prerequisite and the alternating ordered/unordered layers
the owner proposed are both this rule (series-parallel decomposition).

> [!@bukzor] df89c432 2026-09-19 -- "My bid: alternating layers of
> ordered/unordered subdirectories."
