---
managed-by: Skill(llm-subtask)
---

# Package claude-jsonl scripts

**Priority:** Low
**Complexity:** Low
**Context:** `~/bin/claude-jsonl-path`, `~/bin/claude-jsonl-summarize`

## Problem Statement

The claude-jsonl-path and claude-jsonl-summarize scripts live loose in
~/bin/. They should be a proper package — either a standalone repo or
part of an existing one (e.g. bukzor-agent-skills or a new
claude-jsonl-tools repo).

## Implementation Steps

- [ ] Decide packaging: standalone repo vs skill vs dotfiles
- [ ] Add README with usage
- [ ] Add to package manager if applicable
