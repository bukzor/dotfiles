---
label: CORPUS_TOTAL
standing: bare
why:
  - ./one-response-is-many-records.md
  - ./price-multipliers-on-the-base-rate.md
verify: "claude-tokens | claude-tokens-cost >/dev/null  (prints the total and request count on stderr)"
---

# What the corpus totals

44,341 requests over 70 days, costing **$6,243.45** at list prices —
notional API-equivalent dollars, since the usage was on a subscription.

That total is a **stamp, not a constant**: the corpus grows with every
session, so re-running `verify:` will always exceed it. The session that
first wrote this claim added $89 and 546 requests before it was
committed. What is durable is the *shape* below — the class split, and
the ratio between caching and its absence. Cite those; re-run for a
total.

The split by token class is the fact worth carrying, because it is not
what the raw counts suggest. New tokens are 208M and replayed tokens are
4.93G — a 24:1 ratio — yet their costs are nearly equal:

| class | share of spend |
|---|---|
| cache read (replay) | 38.8% |
| cache write | 37.0% |
| output | 23.8% |
| uncached input | 0.3% |

Caching is what makes those first two comparable rather than the replay
dominating. Priced without it, the same corpus costs **$28,321** — 4.5x
more.
