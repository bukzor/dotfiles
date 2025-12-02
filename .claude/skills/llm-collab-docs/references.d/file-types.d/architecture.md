---
filename: docs/architecture/*.md
audience: Developers
purpose: Technical system design and component documentation
---

# docs/architecture/

**Purpose:** Detailed technical design documentation

**Audience:** Developers who need to understand how the system works

**Structure:**
```
docs/architecture/
├── overview.md           # System overview, components, data flow
├── component-name.md     # Detailed component docs (if >100 lines)
└── subsystem/            # Subsystem-specific docs (if complex)
```

**overview.md required sections:**
1. **System Overview** - What the system is (high-level)
2. **Components** - Major components and responsibilities
3. **Data Flow** - How information moves through the system

**When to add files:**
- Component documentation exceeds ~100 lines
- Subsystem is complex enough to warrant its own docs
- Topic is frequently referenced independently

**Relationship to other docs:**
- CLAUDE.md references docs/architecture/ for deep dives
- technical-design.md (docs/dev/) covers implementation details
- docs/architecture/ covers system-level design

**Example overview.md:**
```markdown
# Architecture Overview

## System Overview

A CLI tool for managing X. Built on Y framework with Z storage backend.

## Components

- **Parser** - Handles input processing
- **Core** - Business logic
- **Storage** - Persistence layer

## Data Flow

1. User input → Parser → Command objects
2. Commands → Core → Operations
3. Operations → Storage → Persistence
```
