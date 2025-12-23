# CLAUDE.md vs SKILL.md frontmatter semantics

**Date:** 2025-12-11
**Status:** Accepted

## Context

During skill reorganization, confusion arose about what `depends:` means in two different files:
- `$SKILL/CLAUDE.md` - The project-level context file
- `$SKILL/SKILL.md` - The skill definition file

Both have frontmatter, but the semantics differ.

## Decision

**CLAUDE.md `depends:`** answers: "What skills should load when working IN this directory?"

Based on the directory's structure. If a skill directory contains:
- `.claude/todo.md`, `.claude/todo.d/` → depends on `llm-subtask`
- `docs/adr/`, `docs/devlog/` → depends on `llm-collab`

Self-reference is valid when a skill uses its own patterns (e.g., llm-collab using ADRs).

**SKILL.md `setup:`** answers: "What should projects that USE this skill configure?"

Based on the skill's functionality. Tells consumers how to integrate.

## Example

`llm-collab/CLAUDE.md`:
```yaml
depends:
    - skills/llm-subtask  # has todo.md, todo.d/
    - skills/llm-collab   # has docs/adr/ (self-ref valid)
```

`llm-collab/SKILL.md`:
```yaml
setup: |
    Projects using this skill should add to CLAUDE.md:
    depends:
        - skills/llm-collab
```

## Consequences

**Positive:**
- Clear mental model for each file's purpose
- Self-references now make sense (skill uses its own patterns)
- Easier to audit: check directory structure against depends

**Negative:**
- Two similar-looking `depends:` with different meanings requires documentation

## Related

- Related to: skill directory organization
