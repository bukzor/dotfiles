---
label: WIRE_ORPHANS
standing: bare
why:
  - ./three-independent-cross-checks.md
verify: "claude-tokens-wire --since 2026-09-01 | claude-tokens-cost  (orphan count on stderr)"
---

# The wire sees calls no transcript records

The mitmproxy capture records about **11% more requests** than the
transcripts do. In September alone, **882 orphan calls costing $77.82**
— roughly 7.5% of that month's spend — appear on the wire with no
transcript record and no `ccusage` entry.

They are title generation, warmup pings, quota probes, and every turn of
a session whose transcript was later deleted.

Two consequences. Every total derived from transcripts, including
`CORPUS_TOTAL`, is a slight underestimate. And `ccusage` agreeing with
`claude-tokens` exactly confirms they parse the same source correctly —
it does not confirm that source is complete, because both read it.
