---
cwd: /home/bukzor/claude/homedir-archeology
session:
  uuid: null
  started: 2026-05-22T17:18:00-05:00
  ended: 2026-05-26T19:51:00-05:00
parent: backlog-triage-with-cost-of-delay.md
spawned:
  - $(slug-for-future-followup).md  # see "Spawned follow-ups" below if any
---
# Rate unrated tasks after inventory-coverage fix

Original brief: triage the items that surfaced when
`~/bin/claude-open-tasks-list` gained `todo.d/*.md` scanning and
"existence is the signal" semantics for `todo.{d,kb}/*.md` (2026-05-22,
then uncommitted). Every item in the unrated cohort either gets
`cost-benefit-sweh` frontmatter or `status: done`; then
`task-list.wsjf.toon` is regenerated and the new top of WSJF reported.

## What happened

### Phase 1 (2026-05-22): the rate-unrated sweep itself

- 21 unrated → 0 in one pass: 12 done-marks + 9 new ratings.
- Validation revealed 3 more files were silently done (one of them, an
  ideas.kb entry, had become the new WSJF #1 because of pre-confidence-
  vocabulary rating math). Same `verify-done-state-by-reading-target`
  failure mode caught earlier sweeps too — pattern is durable.
- Found genuine coverage gaps:
  - `test-results/.claude/todo.md` used bare `-` instead of `- [ ]`
    → invisible to inventory. **Fixed by user direction** (bullet
    format conversion).
  - `pnpm-run PATH` in hearts-2025 pre-commit hooks had no task file
    → orphan. **Fixed** with a line-item in hearts-2025/.claude/todo.md.
  - `terminfo` was *not* an orphan after all; lives in
    `~/.claude/todo.md`.
- Re-rated `skill-evolution-for-chatfs-harmonization` to `0.1/0/0`
  confident — pure coordination file, math artifact at exec=0.87 gone.

### Phase 2: convention work (the unplanned expansion)

User-driven discussion turned this from a rating session into a
foundational convention sweep. Captured the conclusions structurally
rather than just in memory:

- **`- [ ]` is load-bearing.** Stressed in `Skill(llm-subtask)/SKILL.md`
  and `~/.claude/sessions.kb/CLAUDE.md`. Bare `-` is invisible to
  inventory.
- **Migrations.kb pattern** — new kb-class under `Skill(llm-kb)` for
  schema/convention migrations: rationale + executable + scope +
  status, all idempotent and re-runnable. Created 13 entries
  (chronologically backfilled by originating-commit date) capturing
  every migration we knew of.
- **`.oneOf.kb/` suffix** for or-class .kbs. AND is the implicit
  default on every .kb. Decision recorded as migration 000.
- **Time-period nesting:** `benefit-2w` / `cost-of-delay-2w` /
  `timebox` move under a `2w:` key (migration 001).
- **Effort vs wallclock split:** `timebox` → `effort`; admit
  `wallclock` as optional sibling for Ameriprise-class items where
  labor ≠ calendar time (migration 002).
- **Fine status vocabulary:** tentative → planning → started →
  in-progress → complete → verified → archival. Orthogonal
  `kind: recurring` field for never-finishes migrations like the
  bullet-bracketed validator. Recorded in
  `migrations.kb/CLAUDE.md`.

### Phase 3: inventory script expansion

User noted `~/claude/` (no dot) holds real work that
`claude-open-tasks-list` missed. Migration 009 documents the one-line
fix; ~/claude/ content now visible. Five newly-visible task files
rated; one parallel-session entry remains unrated (not this arc's
work).

### Phase 4: completion audit

Ran drift checks on the three migrations marked `complete` from git
log back-annotation:

- **2025-12-18 CLAUDE.d → requires:** zero drift → `verified`.
- **2026-03-02 llm.kb → llm-kb skill rename:** 20+ active drift
  → downgraded to `in-progress`.
- **2025-12-11 docs/dev separation:** 10+ projects on old layout (3
  in newly-visible ~/claude/) → downgraded to `in-progress`.

The `verified` step pulled real signal — two of three "complete"
claims were wrong on inspection.

## State of follow-ups

Live migrations.kb at
`~/.claude/skills/llm-kb/migrations.kb/` carries all the durable
state. Status field is the source of truth:

- `verified` (1): 2025-12-18 CLAUDE.d → requires
- `complete` (2): 2026-05-26-009 inventory-roots; 2026-05-26-003
  bullet-bracketed (+ `kind: recurring`)
- `in-progress` (7): the migrations with documented live drift
- `planning` (3): 000 oneOf, 001 time-period, 002 effort/wallclock —
  scripts written, awaiting user go-ahead

Inventory: 70 rated, 1 unrated (`samsung-mom-phone-forensics-and-
debloat.md` — parallel session, not this arc).

Composite drift snapshot (post-~/claude/ scope):

```
000 oneOf-suffix              4 (2 high-confidence + 2 noise)
001 time-period nesting       65 flat-shape files
003 bullet-must-be-bracketed  767 candidates (signal + prose noise)
004 ownership-marker          12 active files
005 .d → .kb                  249 .d/ directories to evaluate
006 em-dash → --              5485 occurrences
007 confidence-band missing   34 legs
008 schema propagation        4 missing schema files
```

## Spawned follow-ups

None new at session-end — every loose end lives in the migrations.kb
entries with status and drift counts. The closeout absorbed:

- `bukzor-agent-skills/llm-subtask/.claude/todo.kb/2026-02-10-000-milestone-phase-planning-pattern-gap.md`
  → `status: done` (resolved by the cardinality + marginal-timebox
  conventions; closeout note added).

## Reading order for the next session

If a future session wants to pick up:

1. `~/.claude/skills/llm-kb/migrations.kb/CLAUDE.md` — pattern overview
   + status vocabulary.
2. Pick a migration by `status` and run its `validate.sh`. The live
   drift count is the work-to-do.
3. `planning`-state migrations need an explicit user go-ahead per
   their scope notes.

## What expanded the scope from the original brief

The original was "rate 21 unrated items." Each conversation turn after
that surfaced a structural concern that needed durable capture, not
just memory. Treating those as out-of-scope would have left the
problem half-solved (data rated, conventions still implicit). The
migrations.kb pattern grew out of needing somewhere durable to put
the conclusions. By session-end the migrations.kb pattern was load-
bearing itself.
