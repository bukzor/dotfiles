---
label: MEASUREMENT
standing: agent
ontology:
  - corpus
  - live branch
  - abandoned branch
  - orphan call
stale-when: the transcript stops carrying per-request `usage`, or the wire capture stops recording responses
---

# measurement — what the numbers are, and what they miss

The **corpus** is every API request this operator's Claude Code made,
reconstructed from `~/.claude/projects/` and cross-checked against a
mitmproxy capture of the wire. At the time of writing it is 44,341
requests over 70 days, costing $6,243.45 at list prices.

Two structures in the transcript decide whether the arithmetic is right
or merely plausible, and both are easy to miss because getting them wrong
produces numbers that look reasonable:

- one response is written as **several records**, one per content block,
  each repeating the whole `usage`;
- a compaction starts a record with no `parentUuid`, so a **live branch**
  walked naively appears to end there, and every earlier era looks like an
  **abandoned branch**.

This theory is prior to every other here and cites none. Its claims are
checkable rather than judged: each carries a `verify:` naming a command
that reproduces it, and a claim that cannot name one does not belong here.

What the corpus does not see is itself a claim (`WIRE_ORPHANS`): the wire
records **orphan calls** that no transcript and no billing tool knows
about, so every total below is a slight underestimate.
