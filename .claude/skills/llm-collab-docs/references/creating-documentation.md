# Documentation Structure for LLM-Collaborative Projects

This guide establishes a standard documentation structure optimized for:
- Human users (README)
- Human contributors (HACKING)
- LLM development assistants (CLAUDE.md)
- Multi-session project continuity
- Efficient context loading

## The Core Structure

```
project/
├── README.md              # Users: what this does, how to install/use
├── HACKING.md             # Contributors: how to develop, test, contribute
├── CLAUDE.md              # LLMs: quick-ref, current focus, architecture
├── STATUS.md              # Current milestone, blockers, next actions
├── docs/
│   ├── dev/
│   │   ├── design-rationale.md        # Why decisions were made
│   │   ├── design-rationale/          # Deep dives on specific choices
│   │   ├── technical-design.md        # What the system is/does
│   │   ├── technical-design/          # Subsystem details
│   │   ├── development-plan.md        # How we build it, milestones
│   │   ├── development-plan/          # Per-milestone breakdowns
│   │   └── devlog/
│   │       ├── README.md              # Index of entries
│   │       └── YYYY-MM-DD.md          # Daily/session logs
│   └── examples/                      # Usage recipes, tutorials
└── design-incubators/                 # Unsolved design problems
    └── problem-name/                  # Each gets its own subdirectory
        ├── CLAUDE.md                  # Problem framing
        └── ...                        # Explorations, prototypes
```

## Documentation Resources

**Templates:** See [../skeleton/](../skeleton/) directory for file templates

**Detailed Guidance:** Browse [../references.d/](../references.d/) for:
- **File types:** How to write each type of doc (README, CLAUDE.md, ADRs, devlogs, etc.) - [file-types.d/](../references.d/file-types.d/)
- **Guidelines:** Documentation principles (linking, DRY, subdirectories, anti-patterns) - [guidelines.d/](../references.d/guidelines.d/)
- **Workflows:** Practical procedures (setup, maintenance, when to deviate) - [workflows.d/](../references.d/workflows.d/)

