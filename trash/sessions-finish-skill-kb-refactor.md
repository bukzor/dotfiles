---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
---
# Finish SKILL.kb refactor

Working tree shows in-progress structural moves and modifications,
likely part of the methodology kb seed work (commit 2705abe).

## Pending Moves (staged renames)

- `SKILL.kb/SKILL.jsonschema.yaml -> SKILL.jsonschema.yaml`
- `docs/dev/procedures.kb/post-mortem.md -> SKILL.kb/procedures.kb/post-mortem.md`

## Pending Modifications (working tree, uncommitted)

- `SKILL.kb/self-audit.{md,kb/CLAUDE.md,kb/bloat.md}`
- `SKILL.kb/must-read/when/context-over-200k-tokens.md`
- `SKILL.kb/procedures.kb/enumerate-and-categorize.md`

## Decision

Complete the refactor and commit, or revert. Some modifications
overlap with `finish-debolding-cleanup`; coordinate so the same files
are not edited twice in conflicting ways.
