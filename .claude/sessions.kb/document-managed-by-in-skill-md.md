---
cwd: /home/bukzor/.claude/skills/llm-subtask
session:
  uuid: null
  started: null
  ended: null
---
# Document `managed-by` Convention in SKILL.md / CLAUDE.md

The `managed-by: Skill(llm-subtask)` convention is established and enforced
by the schema (`const`), present in skeleton templates, and described in
`references/marker-commands.md` + `references/todo.kb-pattern.md`. But
`SKILL.md` and `CLAUDE.md` (skill-level) don't yet mention it. Cold agents
that only read SKILL.md learn the convention implicitly via the skeleton
or the first file they encounter — not directly.

Scope: add a short section to `SKILL.md` (and `CLAUDE.md` if the user-facing
contract belongs there) stating that files managed by this skill declare
ownership via frontmatter `managed-by: Skill(llm-subtask)`, validated by
the schema's `const`. Cross-link to the schema files and to
`references/marker-commands.md`.

Context: this follow-up was surfaced by the `managed-by-cutover` session
(2026-05-17 → 2026-05-18) — see commits `9c4342f` (bukzor-agent-skills)
and the matching corpus commits across ~10 repos.
