# Development Workflow

When completing tasks that involve code changes:

1. Make changes
2. Test changes
3. for bukzor-owned repositories: check documentation obligations in ./creating-documentation.md
4. Commit (including the TODO update in the same commit)
5. Move to next task

Never skip ahead to the next task before completing all steps for the current task.

## Bulk Operations: Cost Optimization

Choose approach based on file count and edit complexity:

| Files | Edit Type | Approach |
|-------|-----------|----------|
| 1-3 | Any | Direct Edit tool |
| 4-10 | Mechanical | Haiku Task or sed |
| 4-10 | Contextual | Direct Edit or Haiku Task |
| 10+ | Mechanical | sed/awk via Bash |
| 10+ | Contextual | Haiku Task |

**Mechanical edits:** Pattern-based find/replace, no file-specific logic needed.

**Contextual edits:** Require reading content to decide what to change.

### sed for Mechanical Bulk Edits

Best for 10+ files with identical transformations:

```bash
# Test on one file first
sed -i 's/old/new/' path/to/one/file.md

# Then apply to all
find . -name "*.md" | xargs sed -i 's/old/new/'
```

Cost: ~100 tokens total vs ~50 tokens × N files for Edit calls.

### Haiku Task for Semi-Mechanical Edits

Use `model: haiku` in Task tool for:
- Template-based generation across files
- Simple logic that doesn't need full Sonnet reasoning
- Middle ground when sed is too rigid

### Direct Edit

Use when:
- Few files (1-3), any complexity
- Complex contextual changes requiring Sonnet reasoning
- Changes depend on surrounding code structure
