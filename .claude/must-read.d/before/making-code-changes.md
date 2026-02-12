# Development Workflow

When completing tasks that involve code changes:

1. Find relevant docs for the area you're changing
   - Architecture docs, ADRs, README
   - If (CLAUDE.md depends on) `Skill(llm-subtask)`: todo files
   - If `Skill(llm-collab)`: recent devlog

2. If docs need updating, do that first
   - Smaller changes, easier to discuss, surfaces course corrections early
   - if `Skill(llm-collab)`: consider if changes warrant an ADR

3. Make code changes

4. Test changes

5. Commit — please read `./git/commit.md` for pre-commit checklist

6. Move to next task

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
