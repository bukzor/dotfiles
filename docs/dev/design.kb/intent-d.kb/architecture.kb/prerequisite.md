---
label: PREREQ
standing: user
why:
  - ../architecture.md
  - ../../../sh-config-loading.claims.md
authority: "session df89c432, 2026-09-19"
---

# Order is prerequisite, and nothing else

`Y requires X` is the one relation; bootstrap, must-be-first, and
last-wins merge are prerequisites with a note, never classes of their
own. Cycles are unsatisfiable under sequential sourcing and are never
accommodated; an override overlay is resolved by a defaulted read.

> [!@bukzor] df89c432 2026-09-19 -- "I reject 'must-be-first' and
> 'bootstrap' in our ontology. Instead, frame these as prerequisites,
> too. More generally, keep a carefully minimal ontology."
