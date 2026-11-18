---
label: STRIP_PRICE
standing: bare
why:
  - ./each-turn-rebills-the-whole-prompt.md
  - ../measurement.kb/price-multipliers-on-the-base-rate.md
verify: "the reconciliation in the body: formula predicts $22.4/Mtok against $22.82/Mtok observed"
---

# Adding a token costs its write plus a read per remaining turn

Putting `T` tokens into the context when `R` turns remain costs
**`base x T x (w + h x R)`** — one cache write, plus a cache read on
every turn that follows.

```
base x T x (w + h x R)
```

where `w` is the cache-write multiplier (2.0 at one-hour TTL, 1.25 at
five-minute) and `h` the cache-hit multiplier (0.1, or 0.025 on Fable
5.1). For Opus 5 at $5/Mtok base and one-hour writes, that is
**$10 + $0.50 x R per Mtok**:

| turns remaining | cost of 1 Mtok added |
|---|---|
| 0 | $9.30 |
| 10 | $14.30 |
| 25 | $21.80 |
| 50 | $34.30 |

The formula reconciles against the corpus. With a blended write
multiplier of 1.86, a blended base of $5.18, and the measured replay
multiple of 24.7 standing in for average `R`, it predicts
$5.18 x (1.86 + 2.47) = **$22.4 per Mtok of new tokens**. The observed
input-side cost is **$22.82 per Mtok**.

So the replay multiple is not a separate empirical fact — it is average
remaining-turns, and the same number appears in both the formula and the
measurement.
