--- # workaround: anthropics/claude-code#13003
requires:
  - ./must-read.kb/before/git/commit.md
---

# Task: Integrate `~/.claude/sessions.kb/` into Skill(llm-subtask) (and consider relocating `/session-start` and `/session-end` into it)

## Problem

A new top-of-user persistence layer landed in `~/.claude/sessions.kb/`
(seeded in commits `d288b9a` → `0fe8338` on `bukzor/dotfiles@svelte-crostini`)
to track parallel claude-code sessions: their cwd, lifecycle, color,
priming reads, and per-session follow-ups. Concurrently,
`~/.claude/commands/session-{start,end}.md` were amended to maintain
this collection.

`Skill(llm-subtask)` is the natural home for the conceptual frame —
it already owns the four-tier task model, the artifacts inventory,
the session-lifecycle narrative, and the marker-command vocabulary —
but its `SKILL.md` predates `sessions.kb` and makes no mention of it.

Two adjacent concerns to settle in this task:

1. **Integrate the concept** into `SKILL.md` so future sessions
   discover sessions.kb via the skill, not via prose archeology.
2. **Decide whether** the two session-lifecycle commands should
   relocate from `~/.claude/commands/` into the skill (a
   `Skill(llm-subtask)`-bundled commands or scripts directory),
   following the trajectory set by the
   `CLAUDE.promote-mutation-testing-skill.task.md` precedent.

## Constraints

- `~/.claude/sessions.kb/` is **user-global** (per-USER), while
  `.claude/todo.kb/` and `.claude/ideas.kb/` are **per-PROJECT**.
  The integration must respect this scope difference — sessions.kb
  is not a 5th tier in the four-tier task hierarchy; it is an
  orthogonal axis (session identity over time, vs. task
  decomposition within a project).
- `Skill(llm-subtask)` lives at `~/.claude/skills/llm-subtask/` —
  verify symlink status before editing (`ls -L SKILL.md`); the
  canonical file may live in `~/repo/.../bukzor-agent-skills/llm-subtask/`.
- The session-start command's grep recipe
  (`grep -rl "uuid: $CLAUDE_CODE_SESSION_ID" ~/.claude/sessions.kb/`)
  hard-codes the path. Any relocation of the kb itself (out of
  `~/.claude/`) breaks the recipe; out of scope here.
- Coordinate with the sister "must-read-kb-skill" session if its
  description-rewrite for llm-subtask is still in flight (the
  `Skill(llm-subtask)` description is on that session's edit list).

## Inventory (current state, re-verify before acting)

### Sessions.kb shape (as of this writing)

- `~/.claude/sessions.jsonschema.yaml` — strict schema:
  - `cwd` (required, abs path)
  - `session` (required object): `uuid?`, `started: [instant, null]`, `ended: [instant, null]`
  - `color?` (enum matching `/color` palette)
  - `focus?` (array of strings — priming reads for the session)
  - `additionalProperties: false` at root and inside `session`
- `~/.claude/sessions.kb/CLAUDE.md` — maintenance guide
- `~/.claude/sessions.kb/.template.md` — dotfile template, skipped
  by the validator (`frontmatter_validate.py` line 73-76)
- Entries follow `kebab-case-slug.md` naming, no date prefix

### Commands (current state)

- `~/.claude/commands/session-start.md`
  - Frontmatter: `depends: - Skill(llm-collab)`
  - Body: `$ARGUMENTS` dispatch (taskfile vs. heuristic); grep
    recipes for sessions.kb; rules of thumb for creating entries
- `~/.claude/commands/session-end.md`
  - Frontmatter: `depends:` git must-read files; `requires:`
    Skill(llm-collab), Skill(llm-subtask), Command(commit)
  - Body: sessions.kb maintenance step, commit/push default args

### Skill(llm-subtask) shape

- `~/.claude/skills/llm-subtask/SKILL.md` — 4-tier model, artifacts,
  marker commands, session lifecycle, agent initiative, ideas pattern
- `bin/`: `llm-subtask-{idea,init,todo}` (3 scripts; no
  session-related script yet)
- `references/`: `four-tier-system.md`, `marker-commands.md`
- `skeleton/`: template files for `.claude/todo.md` etc.

## Part 1: Integrate sessions.kb into SKILL.md

### Conceptual placement

Sessions.kb is **not** a new tier. The 4-tier model describes
task decomposition granularity within a project; sessions.kb
indexes **agent identity across projects**. Two axes, one matrix:

```
                        per-project (tiers)
                  ─────────────────────────────────
                  T0 conv  T1 ephem  T2 todo.md  T3 todo.kb/
per-user
sessions.kb       ──── session entry references any of the above ────
```

A single sessions.kb entry can reference todo.kb/ files in
its body (cross-cwd). A single tier-3 todo.kb/ file can outlive
several sessions.

### SKILL.md edits (suggested)

1. **Add to "Artifacts" list:**
   ```markdown
   - `~/.claude/sessions.kb/YYYY...-slug.md` - Cross-session index
     (per-USER; tracks which session owns what work, across cwds)
   ```

2. **New section: "Cross-Session Tracking"** (after "Session
   Lifecycle"):
   - Describe the per-user vs. per-project scope distinction.
   - Reference `~/.claude/sessions.kb/CLAUDE.md` as the authoritative
     "what belongs" rule.
   - Note when to capture (rules of thumb already in `session-start.md`).

3. **Update "Session Lifecycle":** reference `/session-start` and
   `/session-end` commands as the operational entry/exit hooks
   that maintain sessions.kb.

4. **Update `subtask save` semantics:**
   - Current: "items with subtasks → todo.kb/ (strategic); all
     others → todo.md (tactical)"
   - Proposed addition: "if the work-stream spans cwds or warrants
     cross-session continuity, ALSO update the corresponding
     sessions.kb entry (or propose one)"

5. **Update `subtask load` semantics:**
   - Current: read `.claude/todo.md`, list `.claude/todo.kb/`
   - Proposed addition: also check `~/.claude/sessions.kb/` for an
     entry matching this session (UUID, cwd, topic) and load its
     `focus:` files

### New bin script (optional)

Consider `bin/llm-subtask-session "session topic slug"` that:
- Substitutes the `~/.claude/sessions.kb/.template.md` placeholders
  (`$(pwd)`, `$CLAUDE_CODE_SESSION_ID`, `$(date -Is)`)
- Writes the new file at `~/.claude/sessions.kb/<slug>.md`
- Mirrors the `llm-subtask-{idea,todo}` script ergonomics

## Part 2: Relocate `/session-start` and `/session-end` into the skill

### Question

Should `~/.claude/commands/session-{start,end}.md` move into
`~/.claude/skills/llm-subtask/commands/` (or equivalent)?

### Arguments for

- **Cohesion:** they implement the skill's session-lifecycle
  contract; the skill is their semantic home.
- **Discoverability:** a future maintainer reading the skill sees
  the operational hooks alongside the marker commands.
- **Precedent:** `CLAUDE.promote-mutation-testing-skill.task.md`
  established the pattern of moving command-related artifacts
  into the owning skill.

### Arguments against

- **Availability:** if claude-code only surfaces skill-bundled
  commands when the skill is loaded, `/session-start` becomes
  unavailable at fresh-session start (chicken-and-egg).
- **Cross-skill dependencies:** session-end currently
  `requires: Skill(llm-collab)` for devlog conventions. Bundling
  it under llm-subtask makes the cross-skill dep less obvious.
- **Breakage risk:** users with the existing `/session-end` muscle
  memory expect it to work; relocation must preserve the slash
  invocation.

### Open questions (resolve before acting)

- **Command resolution rules.** Does claude-code resolve `/foo`
  when `foo.md` is at `~/.claude/skills/<skill>/commands/foo.md`?
  Test: stash a `~/.claude/skills/test-skill/commands/probe.md`,
  start a fresh session, attempt `/probe` with and without the
  skill loaded. If only-when-loaded, relocation breaks
  fresh-session ergonomics — keep commands at the top-level.
- **Alternative: keep commands global, document in SKILL.md.**
  If command resolution is load-gated, the right answer is to
  *leave the commands at `~/.claude/commands/`* and just point
  at them from `SKILL.md`. The commands' frontmatter already
  declares the skill dependency; the cross-link is one-way.

## Procedure (one possible sequencing — adjust based on findings)

### Phase A: SKILL.md integration (low-risk, high-value)

1. Edit `SKILL.md` per Part 1 §"SKILL.md edits" (5 changes).
2. Validate by reading freshly — does the document still flow?
3. Commit per `requires:` (path-scoped, single commit).

### Phase B: Resolve command-resolution open question

4. Run the test described in Part 2 §"Open questions". Document
   the finding (commit a small ADR or note in the skill's `docs/adr/`).

### Phase C: Act on Phase B finding

- **If skill-bundled commands resolve at top-level:**
  5. `git mv ~/.claude/commands/session-{start,end}.md
     ~/.claude/skills/llm-subtask/commands/`
  6. Update any `requires:` paths inside those files (relative
     paths likely shift one or two levels).
  7. Verify both commands still invoke correctly.
  8. Commit.

- **If skill-bundled commands are load-gated:**
  5. Skip the relocation.
  6. Add a `SKILL.md` cross-link section pointing at the
     top-level commands, explaining why they live there.
  7. Commit.

### Phase D: Optional bin script

8. Add `bin/llm-subtask-session` if it earns its weight (judgment
   call; cheap to add but adds maintenance surface).

## Risks

- **Drift between sessions.kb's schema and what SKILL.md describes.**
  The schema is rapidly evolving (color, focus, session block added
  within the past hour as of writing). Reference paths and field
  names, not field semantics, in SKILL.md so the doc tolerates
  schema additions.
- **The "where does sessions.kb fit" framing becomes load-bearing.**
  If the SKILL.md presents it as "Tier 4" rather than "orthogonal
  axis," future maintainers will inherit a confused model. The
  matrix framing above is deliberate — preserve it.
- **Command relocation breaks the host CLAUDE.md's existing
  references** (e.g. `commands/session-end.md` referenced by name
  in user prose). Sweep for any such references before moving.
- **Cross-skill dep on `Skill(llm-collab)` in session-end.md.**
  If relocated under llm-subtask, the file still requires llm-collab
  — that cross-skill chain isn't a problem, but make sure it's
  preserved in the frontmatter post-move.

## Out of scope

- **Moving sessions.kb itself out of `~/.claude/`.** The grep
  recipes in session-start.md hard-code that path; relocation is
  a separate, larger decision (private repo? per-user dotfiles
  carve-out?). See sessions.kb entry
  `extract-sessions-kb-to-private-repo.md` if extant; otherwise
  defer.
- **Schema redesign.** Sessions.kb schema is the rapidly-evolving
  one. Don't relitigate field choices in this task — work with
  whatever the schema is at execution time.
- **Promoting `/session-start` and `/session-end` to skills.**
  Heavy; only justified if Part 2 finds that commands cannot
  live under a skill at all AND the workflow merits skill-shape
  rather than command-shape. Defer.
- **Backporting sessions.kb retroactively to old sessions.**
  Sessions before this artifact existed have no entry; that's
  fine. Index new sessions only.

## Files of record

- `~/.claude/sessions.jsonschema.yaml` — current schema
- `~/.claude/sessions.kb/CLAUDE.md` — collection guide
- `~/.claude/sessions.kb/.template.md` — entry template
- `~/.claude/sessions.kb/yaml-date-jsonschema.md` — the
  originating session entry (committed work + minor noted items)
- `~/.claude/commands/session-{start,end}.md` — current command
  homes; subject to Part 2 relocation
- `~/.claude/skills/llm-subtask/SKILL.md` — target for Part 1 edits
- `~/.claude/CLAUDE.promote-mutation-testing-skill.task.md` —
  precedent for command-into-skill relocation

## Retention

Git history (both `~/` and the relocated-files' repo, if any) is
the retention mechanism. Each phase is a small atomic commit; any
phase can be reverted independently. If the task is partially
landed and paused, the system stays in a coherent state — SKILL.md
documenting sessions.kb is independently useful even without the
command relocation.
