#!/bin/bash
# Create new TODO file with date-based auto-incrementing number

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: new-todo.sh \"TODO title\""
  echo "       PRIORITY=high new-todo.sh \"TODO title\"  (set priority)"
  echo "       DATE=YYYY-MM-DD new-todo.sh \"TODO title\"  (for backdating)"
  exit 1
fi

TITLE="$*"
PRIORITY="${PRIORITY:-medium}"

# Ensure .claude/todo.d/ exists
mkdir -p .claude/todo.d

DATE=${DATE:-$(date +%Y-%m-%d)}
LAST=$(ls .claude/todo.d/$DATE-* 2>/dev/null | tail -1 || echo "")

if [ -z "$LAST" ]; then
  NUM="000"
else
  # Extract number after date prefix
  LAST_NUM=$(basename "$LAST" | sed -E "s/^$DATE-([0-9]{3})-.*/\1/")
  NUM=$(printf "%03d" $((10#$LAST_NUM + 1)))
fi

# Create slug from title
SLUG=$(echo "$TITLE" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
FILE=".claude/todo.d/$DATE-$NUM-$SLUG.md"

cat > "$FILE" <<EOF
# $TITLE

**Priority:** ${PRIORITY^}
**Complexity:** [Low/Medium/High]
**Context:** [Link to related docs/issues]

## Problem Statement

[What needs to be done and why?]

## Current Situation

[What's the current state?]

## Proposed Solution

[How should this be addressed?]

## Implementation Steps

1. [ ] First step
2. [ ] Second step
3. [ ] Third step

## Open Questions

- [Question 1]
- [Question 2]

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Notes

[Additional context, references, etc.]
EOF

echo "✅ Created $FILE"
