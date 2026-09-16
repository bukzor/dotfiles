---
label: PLATEAU
standing: bare
why:
  - ./each-turn-rebills-the-whole-prompt.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --warmup"
---

# The per-turn rate climbs to a plateau, so cost stays linear

The triangle would make a session quadratic in its length. Compaction
stops it: context is capped, so the per-turn rate rises and then flattens.

Median cumulative $/turn for Opus 5, by session length:

| turns | 1 | 3 | 8 | 21 | 55 | 144 | 610 |
|---|---|---|---|---|---|---|---|
| $/turn | .103 | .061 | .054 | .066 | .089 | .105 | .100 |

Three regimes. Turn 1 pays a cold cache write and is the most expensive
turn of the session. Turns 2 through 10 run against a small context and
are the cheapest, at roughly **half the eventual rate**. From about turn
144 the rate is flat at $0.100.

So a single flat $/turn — fitted, as it must be, mostly on long sessions —
**overcharges short tasks about twofold**, which is exactly the range
where a delegate-or-not decision is close. Folding the curve into an
exponent is `SUPERLINEAR`.
