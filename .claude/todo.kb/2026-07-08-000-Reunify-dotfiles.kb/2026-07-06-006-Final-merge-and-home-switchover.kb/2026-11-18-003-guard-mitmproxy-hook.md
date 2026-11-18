---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-001-config-references-missing-on-main.md  # Open Question 1
---

# `settings.json`: skip the mitmproxy hook where it's absent, and warn visibly

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

> [!@bukzor] 2026-11-18: skip it *and visibly warn*.

The `SessionStart` hook in `.claude/settings.json` runs
`"$HOME"/claude/mitmproxy/lib/claude_mitmproxy/binpatch.py`. That is a
checkout that exists on penguin and not here, so the hook exits 127.
Where the script exists, run it as now. Where it doesn't, exit 0 and show
the user a one-line warning naming the missing path. Use Claude Code's
hook output contract for a user-visible message (look it up; don't guess),
not just stderr.

Land the change byte-identical on both branches. Then `git -C ~ pull
--ff-only`, and prove both cases by running the hook command by hand: once
with the path absent (exit 0, warning JSON) and once with a stub script on
a temporary `HOME` (the stub runs). Check `jq . settings.json`.

Same ssh workaround as unit 001.

**Scope (only these files):** `.claude/settings.json` in both workspaces;
`git pull` in `~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
