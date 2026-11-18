---
label: SELF_CALIBRATION
standing: bare
why:
  - ./the-model-is-the-one-parameter-worth-keeping.md
  - ../cost-structure.kb/the-per-turn-rate-reaches-a-plateau.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --selfcal"
---

# Watching a task's opening turns beats predicting it cold

Spend on the turns already taken is known exactly, so only the remainder
needs estimating — and the accuracy that buys is the largest available
after the size judgement itself.

| method | error | within 2x |
|---|---|---|
| rate table alone | 29.1% | 83% |
| watch 3 turns, table for the rest | 26.4% | 87% |
| watch 10 turns, table for the rest | 25.6% | 89% |
| watch 20 turns, table for the rest | **23.0%** | **91%** |

The second finding is the more useful one. Extrapolating a task's **own**
observed rate, with no rate table at all, scores 38.2% at 3 turns, 29.7%
at 10, and **21.7% at 20 — matching the table** (23.0%).

So the parameter table is scaffolding for a task's first twenty turns.
Past that it stops earning its place, and a task that has run long enough
is its own best estimator. That matters more than the accuracy: the table
is the perishable part of this ledger, and this is the claim that says
when it can be ignored.

Extrapolation must scale up the observed rate — about 1.6x here — because
the opening turns are the cheapest of the task (`PLATEAU`). Using the
observed rate flat systematically under-predicts.
