---
cwd: /home/bukzor/claude/homedir-archeology
session:
  uuid: cee48983-97b5-4479-86e8-085b12ba3d48
  started: 2026-05-22
  ended: 2026-05-26T20:02:21-05:00
---

# Personal Attention System — Design Conversation

A multi-day design session for a one-person-operator attention
system. Originated from reviewing
`homedir-archeology/planning.kb/2026-05-22.md` (the user's existing
backlog triage) and evolved into a meta-design for how to handle the
broader "find best next work" problem across wellness, family,
revenue, customers, ops, deep tech, and exploration.

The principal recorded artifact is the **`llm-vitals` skill design**
at `bukzor-agent-skills/llm-vitals/design.kb/` — but the conversation
covered substantially more than that, including adjacent designs that
have not yet been recorded. This entry exists so the broader work can
resume.

## Conceptual milestones reached

Listed roughly in conversation order. Most are recorded somewhere;
some are only in the conversation transcript.

**On prioritizing a personal backlog** (not recorded anywhere):

- Personal backlogs are noise-heavy. Most items will never be done.
- The dominant cost is *maintaining the ranking*, not picking wrong.
- **Culling beats ranking.** Delete aggressively; rank only the top tier.
- Rename "cull" → **fallow**. Preserve original thinking (often
  clearer than fresh thinking; idea ripens on back-burner).
- Three item states: **Active / Fallow / Closed**.
  - Fallow items carry a **wake condition** (event / calendar /
    threshold / reflection — what would make this active again).
  - Closed items carry a **resolution**: `done | wontdo |
    superseded(link) | moot | duplicate(link) | split(links)`.
- Cadence-installation is the hard problem. Calendar reminders decay.
  - **Bind to forced functions, not clocks.** Demand-driven review
    (compiler metaphor: runs when output is requested).
  - **Anchor to existing rituals** (Fogg's Tiny Habits, Clear's habit
    stacking).
- "Best next item" is the wrong question; "best next *session*" is
  better. Switching cost makes bundles win.
- Themes (problem domains spanning multiple items) ≈ Linear projects
  used as evergreen containers.

**On the system architecture** (recorded in `llm-vitals/design.kb/`):

- This is a **control system**, not a ranker. **Budgets with feedback**,
  not bans or fixed quotas. Classical control theory.
- **Vitals** as the central primitive — multi-axis SLO-style health
  categories. The word inherits both medical (vital signs) and SRE
  (golden signals) prior art; both converged on the same pattern.
- **Two-tier SLO**: tier 1 = check-in cadence (observability), tier 2
  = metric threshold within reported data (SLO). Tier 1 always
  evaluated first (liveness probe before SLO).
- **Vital kinds**: journal-kind (`.kb/` of entries; suits wellness)
  vs. task-kind (frontmatter tag on existing tasks; suits work).
- **Visible debt counter** as the primary forcing function against
  tech-bias ("days since revenue work: 12").
- **Anchoring**: hook picker into existing session-start / session-end
  skills. No new ritual.
- **FRP / event-sourcing mental model**; thin handlers, no framework.
- **Lightest-touch MVP**: one new frontmatter field (`vital:`), one
  append-only log (`day-log.jsonl`), one new command (picker), two
  skill hooks. Two weekends. Zero AWS.
- **Runway as master state variable** (deferred until cash flows
  ingestible): financial state auto-tunes the rest of the system.
- **Rabbit-hole as investment position**: pre-entry thesis + burn
  budget + exit signal; mid-hole intercept; post-hole calibration.
  Personal hit-rate accumulates over ~20 sessions.
- **Wellness extension = enterprise extension** architecturally —
  both just add tracks (vitals); neither changes code. Proof the
  design is well-factored.
- Recommended initial vitals:
  - **Wellness**: Body, Relationships, Restoration, Meaning
  - **Work**: Revenue, Customer, Tech, Maintenance, Exploration
  - **Enterprise (later)**: Ops, Marketing, Monitoring
- **Repo split**: skill in `bukzor-agent-skills/llm-vitals/` (public);
  personal/wellness data in `private.evan-family/vitals/`; business
  data in `private.bukzor-llc/vitals/`. Skill takes a list of
  `vitals_root:` paths.
- **Import from SRE**: error budgets (humane miss allowances), burn-
  rate alerts (leading indicators).
- **Import from EOS Scorecards**: red/yellow/green status coloring.
- **Renames**: "floor" → "minimum" / "maximum" / "threshold"; "track"
  → "vital"; "personal CFO" framing dropped (over-reach beyond
  control-theory backbone).

**On prior art** (recorded in 040-design/vocabulary.md and
implicit elsewhere):

- Three independent traditions converged on multi-axis health
  monitoring: Balanced Scorecard (business), Wheel of Life (wellness
  coaching), Golden Signals (SRE).
- EOS L10 Scorecard is essentially the same artifact for orgs.
- Tier 1/tier 2 maps exactly onto Kubernetes liveness vs. readiness
  probes.

## Recorded artifacts

`bukzor-agent-skills/llm-vitals/` (this session's main output):

- `CLAUDE.md` — project root
- `design.kb/` — layered design, 32 entries, all pass `llm.kb-validate`
  - `010-mission.md`
  - `020-goals.kb/` (6 goals)
  - `030-requirements.kb/` (7 requirements)
  - `040-design.kb/` (11 architectural entries)
  - `070-future-work.kb/` (7 deferred ideas with explicit triggers)
  - Schemas, CLAUDE.md per layer

`homedir-archeology/planning.kb/2026-05-22.md` — the originating
backlog triage that started the conversation (pre-existing; the
session reviewed it).

## Unrecorded conceptual designs (worth recording soon)

These were settled in conversation but have no permanent home yet.
They are not part of `llm-vitals` proper because they concern *items*
in the user's existing task system, not vitals (categories).

- [ ] Record the **fallow item state + wake-condition** design.
      Possible homes: a sibling skill (`llm-fallow`?), an extension
      of `llm-subtask`, or homedir-archeology `.claude/decision.kb/`.
      Includes the Active/Fallow/Closed states, the wake-condition
      taxonomy (event/calendar/threshold/reflection), and the asymmetric
      review cadence.
- [ ] Record the **closed resolution metadata** taxonomy
      (`done | wontdo | superseded | moot | duplicate | split`).
      Same homes apply as the fallow-state design.
- [ ] Record the **rabbit-hole-as-investment-position** protocol in
      full. Currently only a stub in `llm-vitals/070-future-work/
      rabbit-hole-protocol.md`; the broader framing (pre-entry gate,
      burn budget, exit signal, mid-hole intercept, postmortem
      calibration, personal hit-rate) is conversation-only.
- [ ] Record the **"culling is the prioritization" principle** —
      this is the meta-claim that motivates the fallow design. Likely
      home: `homedir-archeology/.claude/principle.kb/`.

## Resume-from points — implementation of llm-vitals

- [ ] Write `llm-vitals/SKILL.md` (skill description per
      bukzor-agent-skills conventions; look at sibling skills for shape)
- [ ] Implement `claude-pick` Python CLI — reads task surfaces and
      `day-log.jsonl` from configured `vitals_root:` paths, computes
      per-vital debt, applies bias rule (e.g., revenue debt > N forces
      revenue into slot 1), prints dashboard
- [ ] Implement `claude-log` Python CLI — session-end prompt for the
      day-log entry (items touched, vitals, est. hours), appends to
      `day-log.jsonl`
- [ ] Define `config.schema.yaml` for `~/.claude/llm-vitals.yaml`
      (list of `vitals_root:` paths; per-vital declarations of kind,
      tier-1 interval, optional tier-2 thresholds)
- [ ] Define `day-log.jsonl` line schema
- [ ] Hook `claude-pick` into `/session-start` skill output
- [ ] Hook `claude-log` into `/session-end` skill flow
- [ ] Create `private.evan-family/vitals/{body,relationships,
      restoration,meaning}.kb/` with seed CLAUDE.md per kb
- [ ] Create `private.bukzor-llc/vitals/` structure — decide per-vital
      whether journal-kind or task-tag-only
- [ ] Backfill `vital:` frontmatter on existing tasks across user's
      various `todo.md` and `todo.kb/` files (multi-repo, one-time pass)
- [ ] Decide initial tier-1 intervals per vital
- [ ] Populate `design.kb/050-components.kb/` and `060-deliverables.kb/`
      as the implementation progresses

## Resume-from points — broader system

- [ ] Decide where the `day-log.jsonl` lives canonically. Candidates:
      `private.evan-family/vitals/day-log.jsonl` (it's personal time
      tracking) or `~/.claude/llm-vitals/day-log.jsonl` (skill-local).
- [ ] Decide on initial wellness vitals to commit to (recommend the
      four; user may choose subset)
- [ ] Decide on initial business vitals (recommend revenue, customer,
      ops; marketing and monitoring later)
- [ ] Consider whether the fallow-state design should be implemented
      alongside vitals or separately. They are architecturally
      independent but conceptually adjacent.

## Known judgment skips from self-audit (revisit when triggered)

- `vital-kinds.md` has parallel >50-token sections — promote to
  `vital-kinds.kb/` if a third kind is ever added
- `why: mission` slug references `010-mission.md` by stem-minus-prefix
  convention — keep unless a reader gets confused

## Future-work entries in design (each has trigger condition)

Recorded in `design.kb/070-future-work.kb/`; do not act until trigger
fires:

- Rabbit-hole protocol — after ~20 day-log entries
- Wake conditions on fallow items — after MVP picker is sticky
- Perishables via cloud polling — when visible-debt counter insufficient
- Runway as master state variable — when cash flows tracked
- Themes as first-class — when ≥3 items share root cause
- LLM-assisted metric extraction — after ~3 months of journal corpus
- Wheel of Life visualization — when sharing dashboard with someone

## Conversation thread

Long-form reasoning lives in the transcript, including:

- The prior-art surveys (wellness tracking, CEO best practices, SRE)
- The Linear-projects-vs-themes analysis (the "if one-person is to
  themselves what the enterprise is to its employees" framing)
- The repo-placement debate (mingle in `private.bukzor-llc` vs. split
  by semantic boundary across two private repos)
- The rename arguments (track → vital; floor → minimum/threshold; cull
  → fallow)
- The "demand-driven review" / compiler analogy
- The two-tier SLO derivation from Kubernetes liveness/readiness

If the *outcomes* aren't enough, the transcript is authoritative for
*reasoning*.
