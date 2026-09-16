---
label: CONVERSION_IS_CHEAP
standing: bare
why:
  - ./the-model-is-the-one-parameter-worth-keeping.md
  - ./turns-beat-wall-clock-as-a-prospective-input.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators, comparing oracle rows against the history-prior rows"
---

# Estimating size is the whole problem; converting it to dollars is not

Knowing turn count exactly gives 27% error. Predicting turn count from
session history and converting gives **71%**. Predicting cost directly
from history, with no size estimate and no rate table at all, gives
**72.9%**.

The entire conversion apparatus — per-model rates, the superlinear
exponent, the warm-up curve — is worth **about two points** once the input
must itself be guessed. Roughly 98% of the error budget sits in estimating
size.

The consequence is a rule about where to spend effort, and it points away
from most of what is easy to build: **refining the cost model is nearly
worthless; refining the size judgment is nearly everything.** An agent
that can sort a task into the right size bucket beats one carrying an
exact rate table and a vague sense of scale.

This claim is what makes `TSHIRT_BOUND` the practical form of the
estimator rather than a fallback for when precision is unavailable.
