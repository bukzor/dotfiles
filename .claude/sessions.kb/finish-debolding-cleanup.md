---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Finish in-progress de-bolding cleanup

A prior session was stripping markdown bold (`**text**`) from bullet
items per `docs/documentation-conventions.md`. Working tree has
scattered modifications across many files; the pass is half-done.

## Affected Files (working tree, uncommitted)

- `references/pattern-guide.md`
- `references/schema-design.md`
- `references/splitting-large-docs.md`
- `docs/documentation-conventions.md`
- `docs/dev/CLAUDE.md`
- `docs/dev/case-studies.kb/CLAUDE.md`
- `docs/dev/concepts.kb/{case-study,failure-mode,procedure}.md`
- `docs/dev/procedures.kb/reconcile-case-study.md`
- `SKILL.kb/self-audit.{kb/CLAUDE.md,kb/bloat.md,md}`
- `SKILL.kb/must-read/when/context-over-200k-tokens.md`
- `SKILL.kb/procedures.kb/enumerate-and-categorize.md`
- `tests/CLAUDE.md`
- `.claude/{ideas.kb/*,todo.kb/*}`

Some bundled into commit 799eb02 (the complete-example/ subset).

## Decision

Complete the pass and commit, or revert. Either way, coordinate with
`rename-rollup-d-to-kb-doc-references` before touching the
`references/*.md` files.
