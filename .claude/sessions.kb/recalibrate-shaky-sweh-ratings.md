---
cwd: /home/bukzor/repo/github.com/bukzor/2026-05-19--task-archeology
session:
  uuid: null
  started: null
  ended: null
parent: backlog-triage-with-cost-of-delay.md
---
# Recalibrate Shaky SWEH Ratings

Planned. Spun out of the backlog-triage parent at the user's
direction 2026-05-21 ("we'll schedule the rerating for next round").

The 2026-05-18 observation
(`.claude/observation.kb/sweh-ratings-need-recalibration.md` in
`/home/bukzor/repo/github.com/bukzor/2026-05-19--task-archeology`)
flagged 20 pre-existing SWEH ratings as "shaky" — values entered
before the dollar-anchor and 5-band confidence vocabulary landed.
Two of those have since been resolved as DONE in sweep continuations
#2 and the wsjf-rank-tool-gaps-cleanup work, leaving ~18 still in
need of *actual* re-rating (not done-marking).

## Surfacing

`./wsjf-rank --sort=swing` from the project root puts the highest-
swing items first — the tier of all-tentative items at swing=2.46
plus the lone `hypothetical` cod-2w at swing=2.73 mark the
recalibration's highest-value first move. Each is currently driven
by a single default-`tentative` (or worse) leg whose 2x band makes
the ranking indistinguishable from noise.

## Method

Per item, in priority order:

1. Surface the file via `wsjf-rank --sort=swing` and find the leg(s)
   with the weakest confidence.
2. Re-evaluate against the $100 USD/SWEh anchor (decision.kb/sweh-
   dollar-anchor.md): walk the dollar flows or shippability priors
   that actually justify the rated `@value`.
3. Adjust `@value` and `confidence` together; record the rationale
   in the file. Move from `tentative` to `confident` (or downgrade
   to `unsure`/`hypothetical`) as the new evidence justifies.
4. Re-run `wsjf-rank` after each batch; the swing-vs-exec_score
   delta tells you whether the calibration sharpened the ranking.

## Known holds

- **bukzor-llc cod-2w (hypothetical)** — held per user reframing as
  an option-value rating dependent on the "review 8 projects"
  subtask. Don't re-rate until that subtask lands real priors.

## Related context

- `decision.kb/sweh-dollar-anchor.md` — $100 USD ≈ 1 SWEh.
- `decision.kb/sweh-confidence-field.md` — 5-band vocabulary.
- `decision.kb/confidence-aware-wsjf.md` — how confidence flows
  into exec_score and swing.
- `principle.kb/roi-misses-cost-of-delay.md` — why cod-2w exists.
- `principle.kb/verify-done-state-by-reading-target.md` — apply this
  before re-rating; some "shaky" items may have silently completed.
- `reference.kb/refresh-task-list-command.md` — how to regenerate
  `task-list.md` and `task-list.wsjf.toon`.
