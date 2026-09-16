---
label: DEBT_DOMINATES
standing: agent
why:
  - ../estimation.kb/estimating-the-input-is-the-whole-problem.md
  - ../estimation.kb/a-coarse-size-call-is-most-of-the-available-accuracy.md
  - ../../attention-costs.md
---

# The debt estimate is worse than the cost estimate, so spend effort there

The target is to act when expected debt reduction exceeds cost. That is a
comparison between two estimates, and they are not equally good.

Cost estimation bottoms out around **43% error** from a coarse size call
(`TSHIRT_BOUND`), and the ceiling even with perfect size knowledge is 27%.
Debt estimation — how much future work an action saves — has no such
floor, because it is **counterfactual rather than merely unobserved**. A
task's cost is revealed by doing it; the work an action saved is never
observed at all, under any procedure.

So the comparison is dominated by the debt term, and the practical rule
follows: **estimate cost coarsely and stop.** Four log-spaced buckets,
no rate table, no arithmetic. Every refinement past that — the superlinear
exponent, per-model rates, self-calibration from early turns — is
precision on the smaller error, and the effort belongs on the debt side
instead.

This is the ledger's last claim and the one it exists to reach: the
measurement programme that produced everything above concludes that most
of it should not be used.

Signed, and the weakest claim here. The asymmetry is argued from the
structure of the two problems rather than measured, because measuring it
needs debt estimates paired with outcomes, which nothing in this corpus
records. What would settle it: an agent logging predicted and realised
debt across enough actions to score the way costs were scored here.
