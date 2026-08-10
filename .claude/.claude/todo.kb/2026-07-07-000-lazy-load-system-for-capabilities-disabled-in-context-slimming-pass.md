---
managed-by: Skill(llm-subtask)
status: open
---

# Lazy-load system for capabilities disabled in context-slimming pass

**Priority:** Low
**Complexity:** Medium
**Context:** 2026-07-07 context-slimming of `~/.claude/settings.json` (baseline: ~65k → <14k tokens, 50k+ saved per message; ~33% more usable session under a 200k budget)

## Problem Statement

We disabled a batch of never-used Claude Code capabilities to cut baseline
context (50k+ tokens saved). Should any be restorable **on demand** — a
"lazy load" system — rather than requiring a hand-edit of user settings plus
restart?

## Current Situation

Disabled in `~/.claude/settings.json`:

- **Tools denied** (bare deny removes schema from context):
  Workflow (~3.5k, multi-agent/ultracode); CronCreate/CronDelete/CronList,
  ScheduleWakeup (recurring prompts — breaks /loop, /schedule); Monitor
  (background watching); RemoteTrigger (cloud routines); Artifact, DesignSync
  (claude.ai publishing); NotebookEdit; PushNotification;
  EnterWorktree/ExitWorktree; SendMessage (agent messaging).
- **Connectors:** `disableClaudeAiConnectors: true` — Gmail/Calendar/Drive MCP
  no longer auto-load (~3k). Accounts stay connected at claude.ai.
- **Skills** — all hidden from model, all still typable as /name (zero context,
  invocation-lazy). Two mechanisms by ownership:
  - own files carry `disable-model-invocation: true` frontmatter: founder-coach,
    eol, gdb, polish-vars, web-search-quality (commands); llm-vitals,
    webapp-testing, artifacts-builder (skills — NB last two are vendored
    Anthropic content; a re-vendor would silently drop the flag).
  - Anthropic-bundled (uneditable) via `skillOverrides:
    "user-invocable-only"`: update-config, verify, code-review, run,
    keybindings-help, fewer-permission-prompts, simplify, security-review,
    review, init, claude-api, dataviz, artifact-design, deep-research, loop,
    schedule, batch, debug. (`disableBundledSkills` was tried first but makes
    bundled skills un-typable — reverted.)
- **Plugins:** all four LSP plugins false (lua, pyright, rust-analyzer,
  typescript) — zero recorded uses.

Scope-override semantics discovered (constrain the design):

- `permissions.deny` merges across scopes — project allow CANNOT override a
  user-level deny. Restoring a tool means removing the user-level entry.
- `disableClaudeAiConnectors`: any-source-true wins — same limitation.
- `enabledPlugins` and `skillOverrides`: project/local CAN override user —
  these two are per-project lazy-loadable **today**.

## Proposed Solution

Analysis (2026-07-07): the removals fall into three realms.

1. **Invocation-lazy — done, no machinery.** `user-invocable-only` skills and
   the still-typable built-in slash commands load on `/name`, costing context
   only when used.
2. **Scope-override lazy — works today.** `enabledPlugins` (and
   `skillOverrides`) follow normal precedence: a project re-enables in its
   `.claude/settings.local.json` + restart. `disableBundledSkills` is
   *probably* here too (plain boolean, no any-source-true language) — untested.
3. **Merge-wins settings — the only realm needing work.** `permissions.deny`
   unions across scopes; `disableClaudeAiConnectors` is any-source-true. No
   downstream scope (project/local/`--settings` flag) can undo them while they
   live in `~/.claude/settings.json`.

**Preferred design for realm 3:** move the deny list + connector-disable out of
`~/.claude/settings.json` into `~/.claude/settings-slim.json`, and alias
`claude` → `claude --settings ~/.claude/settings-slim.json`. Slim is then the
default; `claude-full` (or `\claude`) launches an unrestricted session. No file
edits, no mutated state to revert, one mechanism for all merge-wins settings.

**Hard limit:** mid-session restoration is impossible in any design — tool
schemas and connector loads are fixed at session start. Per-session
granularity is the floor.

## Implementation Steps

- [x] Verify `--settings`-scoped `permissions.deny` strips tool schemas the
      same way user-scope deny does — confirmed 2026-07-07 via init-message
      tool list (identical 9-tool set)
- [x] Monitor + SendMessage restored (2026-07-08): un-denied in
      `~/.claude/settings.json` (committed, along with the rest of the
      2026-07-07 slimming pass that had sat uncommitted); descriptions
      slimmed in transit by `~/claude/mitmproxy/toolpatch.py` from
      `~/.claude/tool-description-patches.d/` (Monitor 6132→574 chars,
      SendMessage 778→659); Monitor guidance preserved at
      `must-read.kb/before/using-claude-code-tool/Monitor.md`. Net ~950
      tokens over the fully-denied baseline, vs ~4.6k un-patched.
- [x] Hardened toolpatch.py/syspatch.py against stale-cache ghost incidents
      (2026-07-08): both used to snapshot `*-patches.d/` once at mitmproxy
      startup, so editing patches under a live proxy produced incidents
      describing the old config. Fixed by re-reading patches fresh inside
      `_request()` every time -- no more restart-before-trusting-warnings.
      Design rationale: `~/claude/mitmproxy/design/040-design.kb/exact-compare-tool-stubs.md`.
      Committed and pushed (mitmproxy f1d47c7, ~/.claude 47a11a3).
- [ ] Verify whether project-scope `disableBundledSkills: false` overrides
      user-scope true (classifies it realm 2 vs realm 3)
- [ ] Consider extending toolpatch to the rest of the deny list / fat
      always-on tools (Bash, Agent, ...) — measured wins pending appetite
- [ ] Update `must-read.kb/before/lazy-loading/{skills,commands}.md` — they
      describe a scheme that no longer matches reality (skills/commands ARE
      auto-listed now; `skillOverrides` is the current mechanism)

## Open Questions

- Most of SendMessage's measured 1.7k-token footprint is NOT its description
  (778 chars): enabling it pulls conditional agent/teammate prose in
  elsewhere (probably `system` or Agent's description) — a syspatch target
  if worth chasing.
- TaskStop remains denied: a `persistent: true` Monitor cannot be cancelled
  early. Un-deny (small schema) or avoid persistent monitors.
- The settings-slim/`--settings` launcher design remains valid for capabilities
  the proxy can't restore (connectors); unbuilt — proxy solved the two that
  mattered.

## Success Criteria

- [ ] Any capability above restorable in ≤2 user actions
- [ ] Baseline context stays at the slimmed level for sessions that don't opt in

## Notes

Deny-list restoration is just deleting the entry from `permissions.deny`;
nothing is uninstalled. LSP re-enable per project:
`.claude/settings.json` → `"enabledPlugins": {"pyright-lsp@claude-plugins-official": true}`.
