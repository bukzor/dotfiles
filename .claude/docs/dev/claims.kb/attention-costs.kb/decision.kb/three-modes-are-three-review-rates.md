---
label: MODES_ARE_REVIEW_RATE
standing: agent
why:
  - ../decision.md
  - ./review-is-a-real-cost-of-delegating.md
---

# The three modes are three values of one variable

Delegating to a subagent, asking the operator outright, and working turn
by turn in session are not three kinds of thing to choose between. They
are three checkpoint rates:

| mode | checkpoints | measured here |
|---|---|---|
| ask the operator | agent does no turns | — |
| subagent | **one**, at the end | 32 turns per delegation |
| session | **one per episode** | 6.4 turns per checkpoint |

Reading them as one variable is what makes the choice computable: instead
of three options with incomparable profiles, there is a single quantity
with an optimum (`CHECKPOINT_INTERVAL`), and each mode is a region of it.

It also predicts modes the list omits. A subagent reporting progress
midway, or a session whose operator reads every third episode, are
interior points and neither is a hybrid of anything — they are just other
values of the interval.

Signed rather than derived: the identification is a modelling choice, and
what would overturn it is a mode differing in some way the interval does
not capture. The nearest candidate is asking the operator, which differs
in *who authors* the content rather than in who checks it, and is
represented here only by having no agent turns to check.
