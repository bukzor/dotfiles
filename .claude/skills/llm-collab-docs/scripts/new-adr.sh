#!/bin/bash
# Create new Architecture Decision Record with auto-incrementing number

set -e

if [ -z "$1" ]; then
  echo "Usage: new-adr.sh \"Decision title\""
  exit 1
fi

# Ensure we're in project root
if [ ! -d "docs/adr" ]; then
  echo "Error: docs/adr/ directory not found. Run from project root or use init-docs.sh first."
  exit 1
fi

DATE=$(date +%Y-%m-%d)
LAST=$(ls docs/adr/$DATE-* 2>/dev/null | tail -1)

if [ -z "$LAST" ]; then
  NUM="000"
else
  # Extract number, handle leading zeros properly
  NUM=$(basename "$LAST" | grep -oP '\d{3}' | head -1)
  NUM=$(printf "%03d" $((10#$NUM + 1)))
fi

# Create slug from title
SLUG=$(echo "$*" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]-')
FILE="docs/adr/$DATE-$NUM-$SLUG.md"

cat > "$FILE" <<EOF
# $*

**Date:** $DATE
**Status:** Proposed

## Context

[What's the issue we're addressing?]

## Decision

[What we chose to do]

## Alternatives Considered

### Option A
- **Pros:**
- **Cons:**

### Option B
- **Pros:**
- **Cons:**

## Consequences

**Positive:**
-

**Negative:**
-

**Neutral:**
-

## Related

- Supersedes:
- Related to:
EOF

echo "✅ Created $FILE"

# Update ADR index
if [ -f .claude/update-adr-index.sh ]; then
  .claude/update-adr-index.sh
fi

# Open in editor if available
if [ -n "$EDITOR" ]; then
  $EDITOR "$FILE"
elif command -v code >/dev/null; then
  code "$FILE"
fi
