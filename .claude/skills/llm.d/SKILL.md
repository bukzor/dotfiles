---
name: llm.d
description: "Load when:\n\n1. Creating structured knowledge bases (.d/ directories) OR\n2. Organizing facts/tasks for multi-agent LLM access OR\n3. Need grep-able metadata with schema validation"
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    depends:
        - skills/llm.d
    ```
---

# llm.d Pattern

Create structured knowledge bases using `.d/` directory collections. Frontmatter
is optional, but if used, requires schema validation to prevent drift. Use when
organizing facts, tasks, or information for efficient LLM access across multiple
agents. Key principles: small focused files, directory listings as source of
truth (never enumerate contents in docs), CLAUDE.md maintenance guides for
future agents, and progressive disclosure via overview files.

## The Pattern

**Structure**:

```
topic.d/
├── category1.d/
│   ├── item1.md                # optional frontmatter + prose
│   ├── item2.md
│   └── CLAUDE.md               # maintenance guide for future agents
├── category1.jsonschema.yaml   # required if frontmatter used
├── category1.md                # overview (helps decide to read .d/)
├── CLAUDE.md                   # common principles across categories
└── README.md                   # navigation hub
```

**File format**: Markdown prose, optionally with YAML frontmatter. If
frontmatter is used, schema is required to prevent drift.

## Non-Obvious Principles

### 1. Directory Listing = Source of Truth

**Never enumerate directory contents in documentation.**

❌ Wrong: "Tools include: Goose, Aider, Cline, Cursor..." ✅ Right: "Browse
tools.d/ for individual tool profiles"

**Why**: Enumerations become stale. Directory listings (ls, find) stay current.

### 2. CLAUDE.md for Future Agents

**Root CLAUDE.md**: Common principles (pushed up from per-directory guides)
**Per-directory CLAUDE.md**: Category-specific guidance for creating files in
that `.d/`

**Purpose**: Help future agents (possibly different instances, models, or you
later) maintain and extend the collection without rediscovering patterns.

### 3. Overview Files (x.md)

**Each `x.md` describes what's in `x.d/` conceptually** - helps readers decide
whether to dive into details.

Focus on:

- What's there (concept, not enumeration)
- When to read it
- What's NOT there (boundaries)

**Not**: Directory listings, detailed content summaries.

### 4. Homogeneous `.d/` Collections

Each `.d/` directory contains **same type of thing**:

- Shared frontmatter schema (if using frontmatter)
- Same purpose/category
- Related by type, not by tool/subject

**Example**: `tools.d/` contains tool profiles; `features.d/` contains feature
comparisons.

## When to Use

**Good fit**:

- Information with structure (metadata + explanation)
- Multiple categories of related content
- Future agents will maintain/extend
- LLMs will consume frequently

**Poor fit**:

- Simple flat information (single README suffices)
- One-time use
- No structured metadata needed

## Creating a Collection

1. Identify homogeneous categories → `.d/` directories
2. Design schemas for frontmatter → `x.jsonschema.yaml` (if using frontmatter)
3. Create CLAUDE.md guides (root + per-directory)
4. Create overview files (`x.md` for each `x.d/`)
5. Populate content files
6. Validate with provided script (if using frontmatter)

See `references/pattern-guide.md` for detailed explanation. See
`references/complete-example.md` for real-world application.

## Reading Collections

**Use category directories as query filters.** Load entire categories in one
operation to save tokens and time:

```bash
head -n999 patterns.d/*.md          # All patterns
head -n999 topic.d/**/*.md          # Everything
grep -l "keyword" category.d/*.md   # Search within category
```

This exploits small focused files - loading 5 related files is faster than
searching one 500-line file.

## Tools Provided

### scripts/validate-frontmatter.py

**Purpose**: Catch frontmatter schema violations (error prevention)

**Why offered**: Manual validation is error-prone and wastes tokens debugging
schema mismatches.

**Usage**:

```bash
scripts/validate-frontmatter.py category.d/*.md
```
```

Auto-detects schema from directory structure.

## References

- `references/pattern-guide.md` - Complete pattern explanation
- `references/schema-design.md` - Schema design guidance
- `references/complete-example.md` - Real-world example (ai-coding-tools-facts.d)

Load as needed for detailed guidance.
