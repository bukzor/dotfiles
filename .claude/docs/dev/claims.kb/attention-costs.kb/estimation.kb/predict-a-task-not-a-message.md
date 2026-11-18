---
label: TASK_SCALE
standing: bare
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators, against the same fit run per-episode"
---

# Predict at task scale; per-message prediction is not worth attempting

The same estimator scores **72% median error per episode and 29% per
session**. Nothing about the model changes — the bucket does. Per-turn
noise averages out, and cost is a sum over turns.

This is the cheapest accuracy available anywhere in this theory, and it
costs nothing but choosing the unit. Every other lever here is worth
single-digit points; this one is worth forty.

It also sets what the rest of the theory is about. An estimate answers
"what will this task cost", never "what will this reply cost", and an
agent tempted to price its next message is asking a question whose answer
is noise.
