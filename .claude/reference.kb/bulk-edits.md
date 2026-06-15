# Bulk edits: cost optimization

Choose the edit approach by file count and complexity:

| Files | Edit type  | Approach                  |
|-------|------------|---------------------------|
| 1-3   | Any        | Direct Edit tool          |
| 4-10  | Mechanical | Haiku Task or sed         |
| 4-10  | Contextual | Direct Edit or Haiku Task |
| 10+   | Mechanical | sed/awk via Bash          |
| 10+   | Contextual | Haiku Task                |

**Mechanical:** pattern-based find/replace, no file-specific logic.
**Contextual:** require reading content to decide what to change.

## sed for mechanical bulk edits

Best for 10+ files with identical transformations. Test on one file, then apply
to all:

    sed -i 's/old/new/' path/to/one/file.md
    find . -name '*.md' -print0 | xargs -r0 sed -i 's/old/new/'

Cost: ~100 tokens total vs ~50 tokens × N for Edit calls.

## Haiku Task for semi-mechanical edits

Use `model: haiku` in the Task tool for template-based generation, simple logic
that doesn't need full reasoning, or the middle ground when sed is too rigid.

## Direct Edit

Few files (1-3) of any complexity, or changes that depend on surrounding code
structure and need full reasoning.
