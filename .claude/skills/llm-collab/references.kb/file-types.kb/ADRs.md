---
filename: docs/adr/YYYY-MM-DD-NNN-title.md
audience: Developers, future sessions
purpose: Record significant design decisions with context and rationale
---

# Architecture Decision Records (ADRs)

**Purpose:** Capture "why" behind significant design decisions

**When to create:**
- Choosing between multiple valid approaches
- Making decisions that will be hard to reverse
- Establishing patterns or conventions
- Resolving debates that might resurface

**Structure:**
```
docs/adr/
├── 2025-12-02-000-skill-ownership-header.md
├── 2025-12-02-001-cross-skill-referencing.md
└── ...
```

**File naming:** `YYYY-MM-DD-NNN-slug.md`
- Date: when decision was proposed
- NNN: auto-incrementing number (per date)
- Slug: lowercase hyphenated title

**Required sections:**
1. **Context** - What's the issue?
2. **Decision** - What we chose
3. **Alternatives Considered** - What else was viable
4. **Consequences** - Positive/negative/neutral outcomes
5. **Related** - Links to superseded or related ADRs

**Status values:**
- `Proposed` - Under discussion
- `Accepted` - Decision made, in effect
- `Superseded` - Replaced by another ADR
- `Deprecated` - No longer applies

**Script:** `scripts/new-adr.sh "Decision title"` creates a new ADR with template.

**Integration:**
- Reference from HACKING.md: "See [docs/adr/](docs/adr/) for architecture decisions"
- Link specific ADRs when explaining design choices in code comments or docs
