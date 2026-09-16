---
label: PRICE_MULTIPLIERS
standing: bare
verify: "claude-tokens-cost totals reproduce `npx ccusage@latest --json` to four decimals per model"
---

# Every rate is a multiple of the model's base input price

Four token classes are billed, an order of magnitude apart, so they are
never summed into one "tokens" number. Against the model's base input
rate:

- **cache write**: 2.0x at one-hour TTL, 1.25x at five-minute. Roughly
  80% of writes here are one-hour, so collapsing the two understates
  spend materially.
- **cache read**: 0.1x — except Fable 5.1, which is **0.025x**. Missing
  that overstates its cache reads fourfold, and cache reads are most of
  its bill.
- **output**: 5.0x.
- **long context**: no surcharge. Fitting a >200k multiplier against the
  corpus drives it to exactly 1.00; 4.6 and later bill the full window at
  standard rates.

Base rates per Mtok: Opus 5 and Opus 4.8 at $5, Sonnet 5 at $2, Fable 5
and 5.1 at $10, Haiku 4.5 at $1.

`claude-tokens-cost` encodes these and raises on an unknown model rather
than pricing it at zero — a silent zero is the failure this guards.
