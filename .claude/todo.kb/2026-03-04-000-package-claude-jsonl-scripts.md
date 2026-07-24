---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 2.0
    rationale: |
      ~0.5h decision on packaging shape, ~1h README + repo structure,
      ~0.5h migrate scripts + smoke-test. Low complexity per the file's
      own assessment.
    confidence: tentative
  benefit-2w:
    "@value": 0.5
    rationale: |
      Minor cleanup win: scripts become discoverable + versioned. No
      blocking downstream. ~$50 worth of "less embarrassing if shared"
      and "easier to maintain."
    confidence: tentative
  cost-of-delay-2w:
    "@value": 0.1
    rationale: |
      Scripts work fine in ~/bin/ today. Only cost: each 2w delay
      leaves more callers/usage to migrate later. Trivial.
    confidence: tentative
---

# Package claude-jsonl scripts

**Priority:** Low
**Complexity:** Low
**Context:** `~/bin/claude-jsonl-*`, `~/bin/claude-branch-*`, `~/bin/claude-path`,
`~/bin/claude-slug`, `~/bin/claude-fork`, `~/lib/pythonpath/bukzor/claude/`
(`session.py`, `branch_extract.py`, `branch_list.py`, `tree.py`,
`format_short.py`) — grown well past the original two scripts as of
2026-07-24 (branch recovery session; see
`docs/dev/devlog/2026-07-24-000-Claude-Code-branch-recovery--extract-by-leaf--not-by-carve.md`).

## Problem Statement

A family of `claude-jsonl-*`/`claude-branch-*` scripts plus a
`bukzor.claude` Python package live loose in `~/bin/` and
`~/lib/pythonpath/`. They should be a proper package — either a
standalone repo or part of an existing one (e.g. bukzor-agent-skills or
a new claude-jsonl-tools repo).

## Implementation Steps

- [ ] Decide packaging: standalone repo vs skill vs dotfiles
- [ ] Add README with usage
- [ ] Add to package manager if applicable
