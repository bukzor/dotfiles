---
label: TRIANGLE
standing: bare
why:
  - ../measurement.md
verify: "next turn's cache_read against previous turn's input+cache_create+cache_read, over consecutive pairs in costed.tsv"
---

# Each turn rebills the whole prompt before it

A turn's cache read equals the previous turn's entire prompt. Across
**43,796 consecutive request pairs the median ratio is 1.000**, and 87.2%
of pairs match exactly.

So context is not paid for once. Every token is billed on entry and again
on each subsequent turn of the session, which makes a session's cumulative
token count triangular in its length: 208M new tokens here generated 4.93G
of replay, a **24.7x replay multiple**.

The exceptions are the informative ones. A pair mismatches when the
context was cut between turns — a compaction, a rewind, or a tool result
large enough to evict — which is why the ratio is a diagnostic for context
loss as well as a confirmation of the billing model.
