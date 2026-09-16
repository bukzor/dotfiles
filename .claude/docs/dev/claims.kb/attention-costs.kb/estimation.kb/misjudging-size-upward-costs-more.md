---
label: SIZE_ERROR_ASYMMETRY
standing: bare
why:
  - ./a-coarse-size-call-is-most-of-the-available-accuracy.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators"
---

# Guessing one size too big costs three times more than one too small

Guessing one size bucket too big costs **285% error**, against **81%**
for one too small — so a task between two buckets belongs in the
smaller one.

| size call | error |
|---|---|
| correct | 42.8% |
| one bucket too small | 81.1% |
| one bucket too big | **285.5%** |

The asymmetry follows from the buckets being log-spaced: overestimating
multiplies, underestimating divides, and a multiplicative miss on a
long-tailed quantity is the more expensive direction.

So the operating rule is **bias the call low** — a task between two
buckets goes in the smaller one. A too-small estimate that leads to
delegating something expensive is recoverable, because the work is
observable while it runs; a too-large estimate that suppresses a
worthwhile delegation is not, because nothing happens and nothing is
measured.
