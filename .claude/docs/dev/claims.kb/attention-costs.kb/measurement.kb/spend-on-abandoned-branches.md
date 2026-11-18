---
label: REWORK_FLOOR
standing: bare
why:
  - ./a-compaction-root-names-its-predecessor.md
  - ./one-response-is-many-records.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --rework"
---

# Abandoned branches are 7.3% of spend, and that is a floor

**$444.00 of $6,054 — 7.3% — was spent on work later abandoned.** 54% of
sessions contain some; among those, the median session wasted 3% of its
spend and the 90th percentile wasted 23%.

A transcript is a forest, so this is directly measurable: walk back from
the newest record to get the live branch, and anything off it was written
and then rewound past.

It is a **floor on the error rate, not the rate**. Three kinds of error
are invisible to it:

- errors caught and fixed forward, which leave no abandoned branch and
  are far more common;
- errors never caught at all, which are the expensive ones;
- errors in work that was committed before being found wrong, where the
  transcript branch survives and the damage is outside it.

Converting it to a per-turn error rate is `CHECKPOINT_INTERVAL`'s
business, and that claim needs exactly this number.
