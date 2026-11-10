---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park"; the `.claude/` reconcile step
  - ~/.claude/sessions.kb/CLAUDE.md  # "Push / pointer-bump cadence"
  - ~/.claude/sessions.kb/buck-win10.kb/subagent-handoffs-one-home-per-fact.md  # left the skill symlinks uncommitted
---

# `~/.claude/` uncommitted state: commit on wsl-buck-win10

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

Commit `~/.claude/`'s live uncommitted state on `wsl-buck-win10`, so the
merge into main carries it. The svelte-side reconcile is a later step of the
parent; don't do it here, but do report, per path, whether svelte already
has the change, lacks it, or has diverged (feeds that step).

- `settings.json`: the parent says wsl's diff vs. svelte is mostly lag.
  Commit the live file on wsl as-is (it is what runs here); list which keys
  are real local intent vs. lag.
- `reference.kb/python/style.md`: a genuine addition (parent names it).
- `sessions.jsonschema.yaml`: check the diff matches what the
  `sessions.kb` submodule switch (`4795ca9`) intended.
- `sessions.kb` gitlink: bump it to the submodule's pushed HEAD (verify it
  is pushed).
- `design-rules.kb/mirror-the-sources-distinctions.md`: untracked, written on
  user request by a session that crashed (see `~/.claude/todo.md`). Commit
  it, unless it is incomplete or contradicts a tracked rule (then Open
  Questions).
- `skills/llm-sessions`, `skills/subagent-handoffs`: symlinks into
  `~/repo/github.com/bukzor/bukzor-agent-skills/`; commit them the way the
  sibling skill symlinks are tracked.

**Scope (only these files):** in `~`: the six `.claude/` paths above and
`~/.claude/todo.md` (tick its design-rule item); this handoff file.

## Steps

- [x] Survey: diff each path vs. `HEAD` and vs. `svelte-crostini`; submodule pushed?
- [x] wsl commit: `reference.kb/python/style.md`
- [x] wsl commit: `sessions.jsonschema.yaml` + `skills/llm-sessions` + `sessions.kb` gitlink
- [x] wsl commit: `skills/subagent-handoffs`
- [x] wsl commit: design rule + `todo.md` tick
- [x] wsl commit: `settings.json`
- [x] push; final report; `status: done`; commit this file on svelte

## Decisions

- Schema stub + `skills/llm-sessions` in one commit: the stub `$ref`s
  `skill://llm-sessions/...`. Both match svelte, as `4795ca9` intended.
- Design rule committed: complete; contradicts no tracked rule. Svelte-only
  `count-data-variants.md` is near its corollary but on another axis
  (consumers vs. domain kinds).

## Open Questions

- The reconcile step should confirm the `settings.json` "local intent" keys
  below with the user (inferred from svelte's history).

## Final report

Commits on `wsl-buck-win10`, all pushed (`5742bdb..bae4cf3`; `80721c6` in
between is a sibling's): `d31ef1a` style.md, `0dda91e` schema + llm-sessions
link + gitlink `838f45d -> 88129c2` (bukzor.claude-sessions `origin/main`,
pushed; svelte's `a3bae3f` is its ancestor), `691ab61` subagent-handoffs
link, `f559249` design rule + `~/.claude/todo.md` tick, `bae4cf3`
settings.json. `git status .claude/` in `~` is clean.

Svelte status per path (for the reconcile step):

| path | svelte-crostini |
|---|---|
| `reference.kb/python/style.md` | lacks the TypeGuard bullet; otherwise svelte is newer (`6056a15`: explicit-else, Docstrings) -- diverged, apply the one bullet |
| `sessions.jsonschema.yaml` | has it (identical) |
| `sessions.kb` gitlink | behind (`a3bae3f`, ancestor of `88129c2`) |
| `design-rules.kb/mirror-the-sources-distinctions.md` | lacks |
| `skills/llm-sessions` | has it (identical) |
| `skills/subagent-handoffs` | lacks |
| `settings.json` | diverged (below) |

`settings.json`, live wsl vs. svelte:

- Local intent (svelte lacks): `model: "opus"`; `effortLevel: "medium"`
  (svelte and old wsl: `xhigh`); top-level `autoCompactWindow: 300000`;
  `modelSettings.claude-opus-5-5.autoCompactWindow: "auto"`; `Bash(sudo:*)`
  removed from `deny`.
- Converged independently: `autoCompactEnabled: true`; memory deny rule
  `Write` -> `Edit` (svelte `fd19815`).
- Lag (take svelte's): every svelte-only key (`cleanupPeriodDays`,
  `defaultMode`, `questionable`, `skillOverrides`, `disableClaudeAiConnectors`,
  `tui`, `switchModelsOnFlag`, `agentPushNotifEnabled`, the extra
  allow/ask tools, other `modelSettings` models); `enabledPlugins` all true
  (svelte disabled them, `d1900d0`); `TaskStop` in `deny` (svelte: `questionable`);
  the `//hooks-disabled` block (svelte deleted it); the duplicate deny line.
- Host caveat: svelte's `SessionStart` (`~/claude/mitmproxy/.../binpatch.py`)
  and `UserPromptSubmit` (`~/.claude/hooks/session-rename.py`) hooks point at
  files absent on buck-win10; taking them here would fail those hooks.

No deviations from the brief.
