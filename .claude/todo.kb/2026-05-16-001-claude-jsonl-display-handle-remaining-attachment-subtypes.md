---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 2.0
    rationale: |
      ~17 attachment subtypes; per-subtype work is small but schema
      discovery varies. Beyond 2h, high-frequency subtypes (hook results,
      edited files, skill listings) are covered; remaining rare subtypes
      can stay raw JSON.
  benefit-2w:
    "@value": 1.5
    rationale: |
      JSONL skim is daily flow (~2-3x/day). Estimate ~5 min saved per
      skim once formatters land × ~30 skims over 2 weeks = ~1.5h direct.
      Plus reduced cognitive noise reading transcripts.
---

# claude-jsonl-display: handle remaining attachment subtypes

**Priority:** Medium — improves transcript readability for the 8% of attachments not currently handled (the 17 non-hook subtypes), proportionally largest gains for `command_permissions`, `edited_text_file`, `skill_listing`, `deferred_tools_delta`.
**Complexity:** Medium — each subtype is a small ~10–20-line formatter; the work is repetitive but unblocked. Schema discovery is the only judgment-heavy step.
**Context:**
- Script: `/home/bukzor/bin/claude-jsonl-display`
- Repo: the same repo `/home/bukzor` is rooted in (branch `svelte-crostini`, ahead of `origin/svelte-crostini` by ~9 commits as of 2026-05-16)
- Refactor that this builds on: commits `36d8854` through `fc8c194` (run `git log --oneline -- bin/claude-jsonl-display` from anywhere in the repo)

## Problem Statement

`format_attachment` currently dispatches all `hook_*` subtypes to a structured one-line summary (`format_hook_attachment`) and falls every other subtype through to `format_unknown`, which dumps the raw JSON record inside a red `UNKNOWN (attachment/<type>)` box. That dump is ~20–40 lines per record and almost all of it is metadata (timestamps, uuids, parentUuid chains, sessionId, version, etc.) — not the semantically meaningful payload.

Across the user's transcript archive, the 17 non-hook subtypes account for ~1100 records. The most frequent (`command_permissions`, `edited_text_file`, `skill_listing`, `deferred_tools_delta`, `nested_memory`, `queued_command`, `diagnostics`) deserve compact custom rendering similar to the hook one-liner.

## Current Situation

Relevant code locations in `/home/bukzor/bin/claude-jsonl-display`:

- `format_attachment(content, state) -> Text` — dispatch entry point (around line ~395)
- `format_hook_attachment(att, state, att_type) -> Text` — the pattern to emulate (around line ~360)
- `_HOOK_MARKER` dict — the marker/colour table per subtype (around line ~345)
- `format_unknown(label, data, state) -> Text` — current fallback (red box, raw JSON)

The `Text` IR (uniform `list[colorize]` after `normalize_outputs`), the `colorize` constructor with `code=None` default, and the centralized `as_text`/`render` plumbing are all in place — new formatters just return `list[colorize | str]` shorthand and the pipeline takes care of the rest.

Full subtype frequency (gathered 2026-05-16 across `~/.claude/projects/**/*.jsonl`):

```
4471 hook_success                ✓ handled
 195 command_permissions
 184 hook_non_blocking_error     ✓ handled
 145 edited_text_file
 143 skill_listing
 120 deferred_tools_delta
 107 nested_memory
  95 queued_command
  92 diagnostics
  47 agent_listing_delta
  39 date_change
  27 auto_mode
  22 plan_mode_exit
  18 hook_blocking_error         ✓ handled
  12 ultrathink_effort
   9 file
   7 plan_mode
   5 auto_mode_exit
   4 already_read_file
   1 task_reminder
```

## Proposed Solution

Mirror the `format_hook_attachment` pattern: one tiny formatter per subtype, each extracting the few semantically meaningful fields and emitting a compact one-line summary (with optional second line for noteworthy detail).

Add a dispatch table to `format_attachment`:

```python
_ATTACHMENT_FORMATTERS = {
    "command_permissions": format_command_permissions,
    "edited_text_file":    format_edited_text_file,
    "skill_listing":       format_skill_listing,
    # ...
}

def format_attachment(content, state) -> Text:
    att = content.get("attachment")
    if not isinstance(att, dict):
        return format_unknown("attachment", content, state)
    att_type = att.get("type")
    if isinstance(att_type, str) and att_type.startswith("hook_"):
        return format_hook_attachment(att, state, att_type)
    if (fn := _ATTACHMENT_FORMATTERS.get(att_type)) is not None:
        return fn(att, state)
    return format_unknown(f"attachment/{att_type}", content, state)
```

Anything not in the dispatch table continues to fall through to `format_unknown` — that's fine; the goal is to *shrink* the unknown bucket, not eliminate it.

## Implementation Steps

```
- [x] 1. Sample each subtype to discover its schema (2026-05-16; jq pipelines into trash/)
- [x] 2. Triage each subtype (all handled with one-line summaries; none kept in UNKNOWN)
- [x] 3. Implement formatters in descending frequency order
    - [x] Tier 1 (>=100 records each)  → commit 173f9b9
        - [x] command_permissions
        - [x] edited_text_file
        - [x] skill_listing
        - [x] deferred_tools_delta
        - [x] nested_memory
    - [x] Tier 2 (40-99)  → commit bc44de9
        - [x] queued_command
        - [x] diagnostics
        - [x] agent_listing_delta
    - [x] Tier 3 (<40)  → commit e171f0f
        - [x] date_change
        - [x] auto_mode / auto_mode_exit
        - [x] plan_mode / plan_mode_exit
        - [x] ultrathink_effort
        - [x] file
        - [x] already_read_file
        - [x] task_reminder
- [x] 4. Add the dispatch table (landed with tier-1; not empty-first since the tiers
        are all small and review-cheap in three commits)
- [x] 5. Eyeball-test against the three reference transcripts
    - 212e719e: -720 stderr lines (large because it carried ~30 diagnostics records)
    - b7e39cec: -195 stderr lines
    - 6e8223d3: -299 stderr lines
    - All three exit cleanly. Tier-3 subtypes don't appear in references; verified
      against a synthesized stream of one real record per tier-3 subtype.
```

## Result

Task complete. Four commits on `svelte-crostini`:

- `173f9b9` claude-jsonl-display: dispatch attachment subtypes through a lookup table
- `bc44de9` claude-jsonl-display: tier-2 attachment formatters
- `e171f0f` claude-jsonl-display: tier-3 attachment formatters
- `65e774d` claude-jsonl-display: expand content-bearing attachment subtypes

Every attachment subtype observed in the archive (20 total — 4 `hook_*` + 16
others) now has a dedicated formatter. Five content-bearing subtypes
(`edited_text_file`, `nested_memory`, `file`, `queued_command`, `diagnostics`)
render the full payload boxed; the rest stay one-line.

Per user calibration ("err on the side of completeness over brevity, with
small concession to ergonomics/token count"), the multi-line forms are the
right tradeoff for payloads that carry actionable content the reader can't
recover elsewhere.

## Open Questions

- **Threshold for "worth handling"** — is the implicit cutoff "all 17" or "everything down to some frequency floor"? My read: do every subtype, but spend ~10 minutes per low-frequency one and don't over-engineer.
- **Subtypes that may genuinely be noise** — `skill_listing` and `deferred_tools_delta` are dictionary-shaped lists that pad transcripts heavily. A one-liner "▸ N skills available" or "▸ +3 tools, -1 tool" may be enough; the full list is rarely useful in a rendered log. Confirm with the user before suppressing full content.
- **`file` attachment payload** — is it base64-encoded inline content or a path reference? Sample it before deciding rendering. Inline payloads (especially binary) should never be rendered verbatim.
- **Re-using the dispatch pattern for hooks** — the current `format_attachment` has a `startswith("hook_")` branch. Once a generic dispatch table exists, the 4 hook subtypes could be entries in it (each pointing to a shim that calls `format_hook_attachment`). Stylistic call; the prefix branch is fine.

## Success Criteria

```
- [ ] Each of the 17 non-hook subtypes either has a custom formatter or has been deliberately documented as "keep in UNKNOWN" with reasoning.
- [ ] No subtype's rendering exceeds 5 lines in the typical case (vs. the current 15-40 of raw JSON).
- [ ] The three reference transcripts render without errors and produce shorter output than they do today.
- [ ] Commits are small (one subtype per commit, or one tier per commit) and follow the existing commit message style: "claude-jsonl-display: <description>".
```

## Notes

**The pattern to follow** — `format_hook_attachment` in `bin/claude-jsonl-display`:
- Extracts a handful of meaningful fields (`hookName`, `exitCode`, `durationMs`, `permissionDecision` from a parsed JSON stdout).
- Composes them into a single one-line summary span colored by severity (green/yellow/red).
- Optionally appends a continuation line for stderr.

**Smoke-test workflow** used during the refactor: stash the WIP, render the three references with HEAD, pop the stash, render again with WIP, diff. See `git log -p` on the refactor commits for the exact bash. Note: byte-identity is *not* the goal of this work — the whole point is to *change* the output. The smoke test catches crashes and regressions on already-handled subtypes, not whether new formatters match the old `format_unknown` fallback.

**Don't churn the architecture** — the refactor that just landed established the `Text` / `colorize` / `render` / `normalize_outputs` pipeline. New formatters slot in by returning `list[colorize | str]` shorthand and letting the pipeline do the rest. No new global state, no string-with-baked-ANSI shortcuts.

**If two formatters share logic** (e.g., `auto_mode` and `auto_mode_exit` are clearly a pair), factor it once you have 2 concrete uses, not preemptively. Three similar lines beat a premature abstraction.
