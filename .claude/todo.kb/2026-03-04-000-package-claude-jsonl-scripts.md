---
managed-by: Skill(llm-subtask)
cost-benefit-sweh:
  timebox:
    "@value": 1.0
    rationale: |
      Packaging shape is decided and proven; what's left is moving one
      714-line script into an existing package and making it survive
      pyright strict + doctests.
    confidence: tentative
  benefit-2w:
    "@value": 0.3
    rationale: |
      The valuable half already shipped. Remainder is consistency:
      one more untested script becomes tested and installable.
    confidence: tentative
  cost-of-delay-2w:
    "@value": 0.1
    rationale: |
      Scripts work fine in ~/bin/ today.
    confidence: tentative
---

# Package claude-jsonl scripts

**Priority:** Low
**Complexity:** Low
**Context:** `~/bin/claude-jsonl-{display,cwd,path,to-log}`

## Problem Statement

Packaging is decided and half-executed: 2026-08-09 moved `claude-search`,
`claude-inventory`, `claude-branch-list`, `claude-branch-extract` and the
whole `bukzor.claude` library out of `~/bin` + `~/lib/pythonpath` into
`bukzor-tools/packages/claude-code-archeology` (bukzor-tools commit
f6c2700; dotfiles f155f32).

Still loose in `~/bin`: `claude-jsonl-display` (714 lines of stdlib
Python, untested), and the thin `claude-jsonl-{cwd,path,to-log}`
wrappers. `claude-jsonl-display` duplicates content-block walking that
`claude_code_archeology.format_short` already does.

Not in scope: `claude-path`, `claude-slug`, `claude-fork`, `claude-plan`,
`claude-s`, and friends stay in dotfiles -- they're shell glue for local
config, which is the line bukzor-tools' README draws. `claude-path` also
has an external consumer (git-localhost-store symlinks it).

## Implementation Steps

- [x] Decide packaging: a sub-package of bukzor-tools, one command family
      per package
- [x] Add README with usage (bukzor-tools README table + SKILL.md)
- [x] Add to package manager (`uv tool install bukzor-tools`)
- [ ] Move `claude-jsonl-display` in as `claude_code_archeology.display`,
      sharing `format_short`'s block walking; doctest it
- [ ] Fold `claude-jsonl-{cwd,path}` into that package (or into
      `claude-inventory` as flags) and delete the wrappers
