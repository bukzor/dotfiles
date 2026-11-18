---
label: SUPERLINEAR
standing: bare
why:
  - ../cost-structure.kb/the-per-turn-rate-reaches-a-plateau.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators"
---

# Session cost grows slightly faster than turn count

`p[model] x turns^1.13` scores 27.2%, against 29.1% for a flat rate and
29.1% for an affine one. The exponent is the warm-up curve of `PLATEAU`
compressed into a single number: cheap early turns, then a flat rate.

Two points of accuracy for one constant, and the constant is shared across
models rather than fitted per model, so it costs nothing in parameters.
Worth taking where an estimator is being written down; not worth
mentioning where someone is estimating in their head.

The exponent is below the value a pure triangle would give, and that gap
is `PLATEAU` doing its work: without compaction the exponent would
approach 2.
