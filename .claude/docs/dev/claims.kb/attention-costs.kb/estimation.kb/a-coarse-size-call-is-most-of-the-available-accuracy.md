---
label: TSHIRT_BOUND
standing: bare
why:
  - ./estimating-the-input-is-the-whole-problem.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators"
---

# A correct coarse size call captures most of the available accuracy

Three size buckets recover **two thirds of the distance** from no
judgement at all to an exact turn count — 42.8% error against 71% and
27.2%.

Sorting a task into size buckets, assuming the sort is right:

| judgement | error | within 2x |
|---|---|---|
| none — history prior only | 71.0% | 43% |
| 3 buckets (turns cut at 16 / 79) | 42.8% | 66% |
| 5 buckets (cut at 5 / 27 / 66 / 124) | 34.6% | 77% |
| exact turn count | 27.2% | 85% |

Three buckets recover **two thirds of the distance** from no judgement to
a perfect one. Five recover most of the rest, and nothing beyond an exact
count exists to recover.

The form that skips conversion entirely does as well: naming a dollar
magnitude directly, from **< $0.50 / $0.50–3 / $3–15 / > $15**, scores
42.6% with **no parameters, no model table and no turn counting** —
matching the three-bucket turn call while asking for a judgement instead
of an arithmetic.

These are upper bounds: they assume the classification is correct.
`SIZE_ERROR_ASYMMETRY` is what happens when it is not.
