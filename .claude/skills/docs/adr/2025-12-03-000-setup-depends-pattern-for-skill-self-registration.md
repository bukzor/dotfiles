# setup-depends pattern for skill self-registration

**Date:** 2025-12-03
**Status:** Accepted

## Context

Skills need a way to ensure they get loaded in future sessions when a project uses their patterns. Without this, agents may work on projects using skill conventions without loading the skill, leading to inconsistent behavior.

Problem A: Projects using skill patterns should automatically load the skill.
Problem B: When should an agent first load a skill?

## Decision

Skills declare a `setup:` field in their SKILL.md frontmatter instructing projects to add a `depends:` entry to their CLAUDE.md frontmatter:

```yaml
# In SKILL.md
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    depends:
        - skills/skillname
    ```
```

```yaml
# In project CLAUDE.md
depends:
    - skills/llm-collab-docs
    - skills/subtask
```

This solves Problem A. Problem B (first-time loading) is addressed by action-based triggers in the skill description.

## Alternatives Considered

### Lazy-loading trigger files in must-read-before.d/
- **Pros:** Automatic detection based on file patterns
- **Cons:** Chicken-and-egg problem; if pattern exists, project should already have depends:

### Prose instructions in "Adopting in Projects" section
- **Pros:** Human-readable
- **Cons:** Easy to miss, not machine-parseable, buried in docs

## Consequences

**Positive:**
- Explicit project-level declaration of skill dependencies
- Consistent with `depends:` pattern used elsewhere (commands, must-read-before)
- Machine-parseable frontmatter

**Negative:**
- Requires manual addition to CLAUDE.md when adopting a skill

**Neutral:**
- Skills are responsible for documenting their setup requirements
