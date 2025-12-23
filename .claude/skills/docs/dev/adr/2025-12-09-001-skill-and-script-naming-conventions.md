# Skill and script naming conventions

**Date:** 2025-12-09
**Status:** Accepted

## Context

Skills and their scripts need consistent, distinctive naming:

1. **Skill names** appear in `Skill("name")` calls and as directory names
2. **Script names** may be invoked standalone or added to PATH
3. Both should be self-documenting and avoid collisions

Previous names like "subtask" and "docs" are too generic to be distinctive when mixed with other tooling.

## Decision

### Skill Naming

Use `llm-` prefix for all skills:

| Old | New |
|-----|-----|
| llm-collab-docs | llm-collab |
| subtask | llm-subtask |
| llm.d | llm.kb |

The prefix creates a distinctive family. Dots allowed when meaningful (`.kb` = knowledge base pattern).

### Script Naming

Scripts use **subcommand form**: `{supertool}-{noun}[-{verb}]`

1. **Supertool** = skill name (e.g., `llm-collab`)
2. **Noun** = resource type (e.g., `adr`, `devlog`, `todo`)
3. **Verb** = action, omit if only one exists (e.g., no `-new` if there's no `-delete`)

Examples:
```
llm-collab-init      # llm-collab init
llm-collab-adr       # llm-collab adr (implicit: new)
llm-collab-devlog    # llm-collab devlog (implicit: new)
llm-subtask-init     # llm-subtask init
llm-subtask-todo     # llm-subtask todo (implicit: new)
llm.kb-validate      # llm.kb validate
```

### Script Location

All executables in `bin/`, no language suffix:
- `bin/llm-collab-adr` (not `bin/llm-collab-adr.sh`)
- Python scripts symlinked from `lib/python/` (see separate ADR)

### Agent Instructions as Slash Commands

Scripts that primarily expand context for the agent become slash commands:
- `/session-start` - load tactical context
- `/session-end` - save tactical context

## Alternatives Considered

### Generic super-tool names (docs, task)
- **Pros:** Shorter
- **Cons:** Collision risk with system tools, not distinctive in PATH

### Verb-first naming (new-adr, ensure-todo)
- **Pros:** Familiar from existing scripts
- **Cons:** Doesn't group related commands alphabetically

### Always include verb (llm-collab-adr-new)
- **Pros:** Explicit
- **Cons:** Verbose when only one action exists

## Consequences

**Positive:**
- Distinctive: `llm-*` won't collide with system tools
- Self-documenting: name implies skill and resource
- Alphabetically grouped: `llm-collab-*` clusters together
- Extensible: add `-delete`, `-list` verbs when needed

**Negative:**
- Longer names than before
- Requires renaming existing scripts and references

## Related

- Related to: `llm.d/docs/adr/2025-12-03-000-pivot-from-d-to-kb-naming-convention.md`
- See also: Python lib structure ADR (pending)
