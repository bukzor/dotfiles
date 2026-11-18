---
label: CHECKPOINT_INTERVAL
standing: bare
why:
  - ./three-modes-are-three-review-rates.md
  - ../measurement.kb/spend-on-abandoned-branches.md
  - ./the-operator-bills-at-150-an-hour.md
---

# The optimal review interval does not depend on task size

The optimal number of checkpoints is proportional to task size, so the
optimal *interval* between them is a constant: **review every N turns,
where N does not depend on how big the task is.**

With `k` checkpoints over `T` turns, cost is

```
C(k) = c.T  +  H.r.k  +  (c + H.f).lambda.T^2 / 2k  +  d(k).D
```

— agent tokens, review minutes, work discarded when a checkpoint catches
an error, and damage when none does. An error arrives at a random point
and survives to the next checkpoint, so expected discarded work is
`T/2k` per error.

Setting the derivative of the first three terms to zero:

```
k* = T . sqrt( (c + H.f).lambda / (2.H.r) )
```

`k*` is proportional to `T`, so the **interval** `T/k*` has no `T` in it:

```
T/k* = sqrt( 2.H.r / ((c + H.f).lambda) )
```

**Review every N turns, where N does not depend on how big the task is.**
A big task does not want proportionally more scrutiny per turn; it wants
the same scrutiny per turn, which means more checkpoints only because it
is longer.

The error rate follows from `REWORK_FLOOR`: 7.3% of spend was discarded
under a 6.4-turn interval, and 0.073 = lambda x 3.2 gives **lambda ~
0.023** — one rework-worthy error every ~44 turns.

The derivation drops `d(k).D`, which pushes toward more review and is
unbounded; `REVERSIBILITY_GATES` handles it separately because no interior
optimum exists once it is included.
