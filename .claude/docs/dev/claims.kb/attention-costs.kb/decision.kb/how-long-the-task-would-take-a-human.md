---
label: HUMAN_MINUTES
standing: open
why:
  - ./the-operator-bills-at-150-an-hour.md
  - ../estimation.kb/a-coarse-size-call-is-most-of-the-available-accuracy.md
---

# How is the human side of the comparison estimated?

Every threshold in this theory is a ratio against the operator's own time
— 7x for Opus (`HOURLY_COMPARISON`), a break-even in minutes. Both sides
need an estimate, and **only the agent side has one.**

`HUMAN_RATE` prices a minute. Nothing here estimates *how many minutes* a
task would take the operator, and nothing in the corpus could: transcripts
record when messages arrived, never how long the work behind them took, or
what it would have taken unaided.

So the comparison is currently half-grounded. Agent cost is measured to
about 43% from a coarse call (`TSHIRT_BOUND`); human cost is whatever the
operator guesses, with no check on it at all.

An answer would settle:

- whether human effort admits the same coarse bucketing that works for
  agent cost, or whether its distribution is shaped differently;
- whether the operator's own estimates are biased, and in which
  direction — the literature on software estimation says low, and this
  corpus cannot confirm or deny it;
- whether **review** minutes (the `r` guessed at 2 in `OVERSUPERVISION`)
  and **authoring** minutes need separate treatment, since review is the
  term that recurs on every delegation.

Until then, treat any delegate-or-not threshold as resting on an unchecked
input, and prefer decisions that stay right across a wide range of it —
which most do, since the ratios are 4x to 16x and a human estimate wrong
by half moves nothing.
