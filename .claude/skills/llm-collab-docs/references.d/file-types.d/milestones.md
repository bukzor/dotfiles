---
filename: docs/milestones/NN-milestone-name.md
audience: Developers, project managers
purpose: Detailed breakdown of milestone scope and progress
---

# docs/milestones/

**Purpose:** Detailed planning and tracking for each milestone

**Structure:**
```
docs/milestones/
├── 01-initial-setup.md
├── 02-core-features.md
└── 03-polish-and-release.md
```

**File naming:** `NN-milestone-name.md`
- NN: Two-digit number (ordering)
- Name: Lowercase hyphenated description

**Required sections:**
1. **Goal** - What this milestone achieves (1-2 sentences)
2. **Success Criteria** - How we know it's complete (checkboxes)
3. **Scope** - What's included (and explicitly excluded)
4. **Tasks** - Work breakdown (can link to .claude/todo.d/ for tactical details)

**Optional sections:**
- Dependencies on other milestones
- Risks and mitigations
- Related ADRs

**Example:**
```markdown
# Milestone 01: Initial Setup

**Status:** In Progress

## Goal

Establish project structure and development environment.

## Success Criteria

- [ ] CI pipeline runs tests on every PR
- [ ] Documentation structure in place
- [ ] Core dependencies configured

## Scope

**Included:**
- Project scaffolding
- CI/CD setup
- Base documentation

**Excluded:**
- Feature implementation (Milestone 02)
- Deployment (Milestone 03)

## Tasks

See [.claude/todo.d/2025-01-15-000-initial-setup.md](../../.claude/todo.d/2025-01-15-000-initial-setup.md)
```

**Integration with ROADMAP.md:**
Each milestone has a summary entry in ROADMAP.md with link to the full doc.
