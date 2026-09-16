# estimation.kb — maintenance guide

What can be known about a task's cost before doing it, and how well.

## What belongs here

A claim about a candidate input to an estimate — its spread, its
guessability, its accuracy if known exactly — or about the form an
estimator should take.

Report both halves for any input: oracle accuracy and guessability. An
input praised on one alone is being praised on its better half, which is
the recurring error this collection exists to prevent.

## What does NOT belong here

- Why the cost behaves that way -> `../cost-structure.kb/`
- What to do with the estimate -> `../decision.kb/`

Accuracy figures come from `claude-tokens-params --estimators`. Name the
section in `verify:`.
