---
name: llm.d
description: "Load when:\n\n1. Creating structured knowledge bases (.d/ directories) OR\n2. Organizing facts/tasks for multi-agent LLM access OR\n3. Need grep-able metadata with schema validation"
---
--- # workaround: anthropics/claude-code#13005
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    --- # workaround: anthropics/claude-code#13003
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
project/                        # plain container
├── CLAUDE.md                   # agent maintenance
├── README.md                   # navigation hub (plain containers only)
├── category1.jsonschema.yaml   # schema (required if frontmatter used)
├── category1.md                # optional summary of category1.d/
├── category1.d/
│   ├── CLAUDE.md
│   ├── item1.md                # optional frontmatter + prose
│   └── item2.md
├── category2.d/                # no summary needed here
│   ├── CLAUDE.md
│   └── nested.d/
│       ├── CLAUDE.md
│       └── item.md
```

**Navigation**:
- `x.md` summarizes `x.d/` when it helps avoid reading the whole directory
- `README.md` as navigation hub when a plain directory has multiple `.d/` collections
- `CLAUDE.md` at each level guides future agents

**File format**: Markdown prose, optionally with YAML frontmatter. If
frontmatter is used, schema is required to prevent drift.

## Non-Obvious Principles

### 1. Directory Listing = Source of Truth

**CLAUDE.md enables maintenance decisions, not content discovery.**

After reading, Claude must determine: "Does X belong here?" Content discovery is `ls`.

❌ "Tools: Goose, Aider..." / "PRs: #123, #456..." / "Contains: api.md, auth.md"

Never enumerate—including "snapshots" or "current state."

### 2. CLAUDE.md for Future Agents

**Root CLAUDE.md**: Common principles (pushed up from per-directory guides)
**Per-directory CLAUDE.md**: Category-specific guidance for that `.d/`

After reading `x.d/CLAUDE.md`, agent must know:
- What belongs here (concept, not enumeration)
- What does NOT belong (boundaries)
- When to add/read files here

### 3. Summary Files (x.md)

**Created only at user request.** Summarizes `x.d/` to help decide whether to dive in.

If present, requires frontmatter:
```yaml
last-updated: YYYY-MM-DD
```

Listings aren't helpful here—`ls` serves users better.

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
4. Create overview files (`x.md`) where summaries help
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
