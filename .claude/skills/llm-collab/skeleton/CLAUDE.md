--- # workaround: anthropics/claude-code#13003
depends:
    - skills/llm-collab
---

# [Project] - Development Guide for Claude

## Quick Reference

**Implementing new [component]:**
[2-3 sentence summary] → See [HACKING.md#section](HACKING.md#section)

**Understanding [key concept]:**
[Brief explanation] → See [docs/dev/technical-design.md#concept](docs/dev/technical-design.md#concept)

**Current tasks:** See [.claude/todo.md] for active work and priorities.

## Architecture Overview

[3-5 sentence summary of how the system works]

**Key subsystems:**
- [Subsystem 1]: [One sentence] → [Link to docs/dev/technical-design/subsystem-1.md]
- [Subsystem 2]: [One sentence] → [Link to docs/dev/technical-design/subsystem-2.md]

## Data Flow

[Brief description or ASCII diagram showing how data moves through system]

See [docs/dev/technical-design.md#data-flow](docs/dev/technical-design.md#data-flow) for details.

## Key Files

- `[path]` - [What it does]
- `[path]` - [What it does]

## Conventions

- [Style/naming/organization conventions]

## Testing

[How to run tests, what to check]

See [HACKING.md#testing](HACKING.md#testing) for details.
