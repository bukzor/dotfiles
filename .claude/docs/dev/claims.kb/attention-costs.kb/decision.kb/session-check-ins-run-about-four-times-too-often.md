---
label: OVERSUPERVISION
standing: agent
why:
  - ./the-checkpoint-interval-is-constant-in-task-size.md
---

# Session check-ins run about four times more often than the optimum

Substituting this corpus's values — H = $2.50/min, review r = 2 min,
cleanup f = 0.2 min/turn, c = $0.087/turn, lambda = 0.023:

```
N = sqrt( 2 x 2.50 x 2 / ((0.087 + 0.50) x 0.023) ) ~ 27 turns
```

The observed session interval is **6.4 turns**. By this model the
operator reviews roughly **four times more often than pays**.

The optimum is robust across the guessed parameters: a 30-second review
gives 13 turns, a fourfold higher error rate gives 13, and no plausible
setting drops it below about 10. The gap to 6.4 survives the whole sweep.

Two corroborations, and one reason to discount it. The optimal interval
costs 27 x $0.087 ~ **$2.35 of agent work per review**, against an
observed median delegation of **$2.04 over 32 turns** — so delegation
instincts here already sit near the optimum, and it is session rhythm
that is tight. Against that: a check-in is not only a check. It is also
where the operator steers, and steering adds information rather than
merely confirming. The model prices review as pure overhead, so it
understates short intervals by whatever steering is worth — which is not
measured here and could plausibly close much of a 4x gap.

Signed, not derived: `r` and `f` are guesses, and the steering term is
missing rather than estimated.
