---
label: MODEL_REQUIRED
standing: bare
why:
  - ./predict-a-task-not-a-message.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators"
---

# The model is the one parameter that cannot be dropped

Per-model rates score 29% error; a single model-blind rate scores 67%.
That 38-point gap is larger than every other modelling refinement
combined.

The reason is spread: $/turn ranges from $0.009 on Haiku 4.5 to $0.38 on
Fable 5.1, a factor of 41. No single constant covers that.

| model | $/turn | $/hr of session |
|---|---|---|
| fable-5-1 | 0.381 | 36 |
| fable-5 | 0.234 | 31 |
| opus-5 | 0.087 | 21 |
| sonnet-5 | 0.031 | 9 |
| haiku-4-5 | 0.009 | 17 |

Note the second column spans only 4x where the first spans 41x. Hourly
rates are the naturally compressed coordinate, which is why they survive
rounding and $/turn does not.
