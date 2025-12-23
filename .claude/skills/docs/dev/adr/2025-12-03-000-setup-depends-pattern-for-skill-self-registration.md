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
---
name: skillname
description: "Load when..."
---
--- # workaround: anthropics/claude-code#13005
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    depends:
        - skills/skillname
    ```
---
```

```yaml
# In project CLAUDE.md
--- # workaround: anthropics/claude-code#13003
depends:
    - skills/llm-collab
    - skills/llm-subtask
---
```

This solves Problem A. Problem B (first-time loading) is addressed by action-based triggers in the skill description.

## Implementation Notes

**Frontmatter stripping workarounds:**

Due to Claude Code bugs where frontmatter is stripped before showing files to the model, workarounds are required:

- **CLAUDE.md files** ([#13003](https://github.com/anthropics/claude-code/issues/13003)): Add comment on first `---` line
- **SKILL.md files** ([#13005](https://github.com/anthropics/claude-code/issues/13005)): Split frontmatter - load-bearing fields (`name:`, `description:`) in first block, custom fields (`setup:`) in second block with workaround comment

These workarounds ensure the model can see the `depends:` and `setup:` instructions.

## Alternatives Considered

### Lazy-loading trigger files in must-read.d/before/
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
