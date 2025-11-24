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

**Templates:** See skeleton/ directory for file templates

**Guidance:**
- [writing-design-docs.md](writing-design-docs.md) - How to write design-rationale.md and technical-design.md
- [writing-planning-docs.md](writing-planning-docs.md) - How to write development-plan.md and milestones
- [design-incubators.md](design-incubators.md) - Pattern for exploring unsolved problems
- [documentation-antipatterns.md](documentation-antipatterns.md) - Common mistakes and how to avoid them
- [new-project-checklist.md](new-project-checklist.md) - Setup checklist for new projects

