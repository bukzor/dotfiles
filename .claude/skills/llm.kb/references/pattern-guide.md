# The llm.d Pattern - Detailed Guide

## Origins

Unix `.d/` directories (e.g., `/etc/cron.d/`, `systemd/system.d/`) applied to LLM knowledge bases with schema validation and agent maintenance guides.

## Key Components

### CLAUDE.md Files (Non-Obvious)
**Root CLAUDE.md**: Common principles pushed up from per-directory guides
**Per-directory CLAUDE.md**: Category-specific creation/maintenance guidance

**Purpose**: Future agents maintain the collection without rediscovering patterns.

**Include**: Templates, quality guidelines, when to create/update files.

### Overview Files (x.md) (Non-Obvious)
**Purpose**: Help readers decide whether to explore `x.d/` in detail.

**Critical**: Never enumerate directory contents - point to directory instead.

❌ "Files include: item1, item2, item3"
✅ "Browse category.d/ for individual items"

### File Size
**Typical**: 200-600 words per file
**Reference docs**: Can be 800-1500 words when comprehensive coverage is the point

## Non-Standard Principles (The Point)

### No Enumeration (Counterintuitive)
**Never list directory contents in documentation** - directory listing is source of truth.

**Why**: `ls` stays current, documentation becomes stale instantly.

### CLAUDE.md for Agents (Unique)
Help future agents maintain without rediscovering patterns. Include templates, guidelines, and quality standards.

### Progressive Disclosure
Overview (`x.md`) → Detail (`x.d/*.md`) → Cross-references.

LLMs load what they need, nothing more.

## Use Cases

### Knowledge Bases
- Tool comparisons and evaluations
- API documentation
- Architecture decision records
- Reference libraries

### Task Collections
- Deployment procedures
- Testing checklists
- Workflow definitions
- Runbook procedures

### Any Structured Information
- Product catalogs
- Team documentation
- Project specifications
- Training materials

## Creating a Collection

### 1. Identify Categories
What homogeneous groups exist?

**Example**: AI coding tools project
- Tools (8 profiles)
- Features (3 comparisons)
- Providers (3 support docs)
- Architectures (2 patterns)
- Workflows (1 guide)
- Comparisons (2 decision docs)

Each category becomes a `.d/` directory.

### 2. Design Schemas
What structured data matters for each category?

**Example**: Tool profiles need
- name, developer, license (required)
- repository, language (optional)
- type, interface (required)

Create `category.jsonschema.yaml` with these fields.

### 3. Create Directory Structure
```bash
mkdir -p {category1.d,category2.d,category3.d}
```

### 4. Write Schemas
Create `category1.jsonschema.yaml`, etc.

Use JSON Schema Draft 07 format in YAML.

### 5. Create CLAUDE.md Files
**Root**: Common principles (small files, schemas, cross-refs, etc.)

**Per-category**: Specific guidance for that category

### 6. Create Overview Files (where helpful)
Write `category1.md` when a summary helps readers decide whether to dive into
`category1.d/`.

### 7. Populate Content
Create individual files following schemas.

### 8. Add README.md (only when needed)
Navigation hub, only when a plain directory contains multiple `.d/` collections.

### 9. Validate
Run validation script on all files.

## Maintenance

### Adding Files
1. Check schema for requirements
2. Read directory's CLAUDE.md
3. Create file following pattern
4. Validate with script
5. Add cross-references

### Updating Files
1. Preserve frontmatter schema compliance
2. Update prose as needed
3. Update related files if facts change
4. Re-validate

### Adding Categories
1. Create new `.d/` directory
2. Design schema (`category.jsonschema.yaml`)
3. Write CLAUDE.md for category
4. Write overview (`category.md`) if helpful
5. Create first example file
6. Update README.md if present

## Anti-Patterns

**Don't**:
- ❌ Enumerate directory contents in docs
- ❌ Create files >1000 words (split instead)
- ❌ Duplicate information across files
- ❌ Skip schema creation
- ❌ Forget cross-references
- ❌ Mix topics in single file

**Do**:
- ✅ Keep files focused
- ✅ Link generously
- ✅ Validate regularly
- ✅ Update CLAUDE.md as patterns evolve
- ✅ Use directory listings for discovery

## Benefits

**For LLMs**:
- Efficient selective loading
- Clear structure and metadata
- Easy to navigate
- Validated consistency

**For Humans**:
- Progressive disclosure
- Clear organization
- Easy to browse
- Cross-referenced

**For Maintenance**:
- CLAUDE.md guides future agents
- Schemas prevent errors
- Small files easier to update
- Clear patterns to follow

## Comparison to Alternatives

**vs Single Large Docs**:
- ✅ Better token efficiency
- ✅ Easier maintenance
- ✅ More structured
- ⚠️ More overhead for small projects

**vs Unstructured Markdown**:
- ✅ Validation catches errors
- ✅ Metadata enables tooling
- ✅ Clearer organization
- ⚠️ Requires schema design

**vs Database**:
- ✅ Human-readable
- ✅ Git-friendly
- ✅ Simple tooling
- ⚠️ Less queryable

## When to Use

**Good fit**:
- Multiple categories of related information
- Structure aids understanding
- Future maintenance expected
- LLM will consume frequently

**Poor fit**:
- Single simple document suffices
- No structured data needed
- One-time use
- Very small amount of information

## Tool Support

**Validation** (prevents errors):
- `bin/validate-frontmatter` - Check schema compliance recursively
