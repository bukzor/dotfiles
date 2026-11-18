---
label: ELICITATION_BLOCKS
standing: agent
why:
  - ./three-modes-are-three-review-rates.md
  - ./setup-cost-never-decides.md
---

# The cost of asking is latency, not dollars

Asking the operator for a whole answer is nearly free in tokens
(`SETUP_IS_NEGLIGIBLE`) and expensive in a way the cost model does not
represent: it **stalls until the operator is available**, which is minutes
when they are at the keyboard and hours when they are not.

In a model where cost is summed over work performed, a blocked task costs
nothing while it waits. In a model about debt, waiting is where debt
accrues — the work is not done, and everything depending on it is also not
done.

So the honest comparison between asking and delegating is not
$0.002 against $2.35. It is $0.002 plus an unbounded wait against $2.35
plus a review, and the wait is usually the larger number.

Signed rather than derived because the latency cost is not measured here:
the corpus records when messages arrived, not when the operator became
free to send them, so the two are indistinguishable in the data.
