---
label: COST_STRUCTURE
standing: agent
ontology:
  - tip
  - strip
  - triangle
  - replay multiple
  - remaining turns
  - plateau
why:
  - ./measurement.md
stale-when: a turn stops resending the prior context, or cache reads stop being billed
---

# cost-structure — why a token's price depends on when it arrives

A session is a **triangle**. Each turn resends everything before it, so a
token entering at turn *n* is billed again on turns *n+1*, *n+2*, and so
on to the end. Measured across 43,796 consecutive pairs, a turn's cache
read equals the previous turn's whole prompt — median ratio 1.000.

That gives two different prices for the same token, and the distinction
runs through everything downstream:

- the **tip** is what it cost to put the token in: one cache write;
- the **strip** is what it will cost in total: the write plus a cache read
  on each of its **remaining turns**.

The ratio between them is the **replay multiple** — 24.7 across this
corpus, meaning the average token is read back about 25 times.

Left alone, the triangle would make long sessions quadratic. Two things
stop it. Caching discounts the replay to a tenth of base, which happens to
cancel the triangle almost exactly. Compaction caps the context, so the
per-turn rate climbs to a **plateau** rather than growing without bound.
