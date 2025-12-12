# Skeleton directory pattern for file templates

**Date:** 2025-12-02
**Status:** Accepted

## Context

Skills that create files (task files, devlog entries, ADRs) need templates. These templates define:
- File structure and sections
- Ownership headers
- Example content showing expected format

Templates could be stored as:
1. Heredocs in shell scripts
2. Separate template files
3. Directory tree mirroring target structure

## Decision

Skills use a `skeleton/` directory containing the exact directory tree and file templates they create:

```
skill/
├── skeleton/
│   └── .claude/
│       ├── todo.md
│       └── todo.d/
│           └── YYYY-MM-DD-000-example-task.md
├── bin/
│   └── llm-subtask-todo
└── SKILL.md
```

**Scripts copy from skeleton:**
```bash
cp "$SKELETON" "$FILE"
```

**Templates include:**
- Ownership header: `<anthropic-skill-ownership llm-subtask />`
- Section headers
- Example content with placeholders

**Agent customizes after copy:** The agent opens and edits the file, replacing placeholders. Scripts don't do sed substitutions.

## Alternatives Considered

### Heredoc in script
```bash
cat > "$FILE" <<EOF
# $TITLE
**Priority:** $PRIORITY
...
EOF
```
- **Pros:** Self-contained, variable substitution built-in
- **Cons:** Hard to read/edit, escaping issues, duplicates template if multiple scripts

### Template with sed substitution
```bash
sed -e "s/TITLE/$TITLE/" template.md > "$FILE"
```
- **Pros:** Separates template from script
- **Cons:** Regex escaping fragile, limited substitution, agent edits anyway

### Generator script with options
```bash
new-todo --title "X" --priority high --complexity medium
```
- **Pros:** Full control via CLI
- **Cons:** Over-engineering, agent has to learn CLI, still needs to edit result

## Consequences

**Positive:**
- Templates are real files, easy to edit and preview
- Directory structure is self-documenting
- Scripts are minimal (just copy)
- Ownership headers included by default

**Negative:**
- Templates not parameterized (agent must edit)
- Skeleton directory adds to skill size

**Neutral:**
- Establishes visual convention for skill capabilities

## Related

- Related to: Skill ownership header convention (headers in skeleton templates)
- Related to: Cross-skill referencing (skeleton is authoritative source for file format)
