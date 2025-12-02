#!/bin/bash
# Create new devlog entry from template

set -e

if [ ! -d "docs/devlog" ]; then
  echo "Error: docs/devlog/ directory not found. Run from project root or use init-docs.sh first."
  exit 1
fi

DATE=$(date +%Y-%m-%d)
FILE="docs/devlog/$DATE.md"

# Handle multiple sessions per day
if [ -f "$FILE" ]; then
  TIMESTAMP=$(date +%H%M)
  FILE="docs/devlog/$DATE-$TIMESTAMP.md"
fi

cat > "$FILE" <<EOF
# Devlog: $DATE

## Focus

[What was the goal for this session?]

## What Happened

### Completed

-

### Attempted

-

### Discovered

-

## Decisions Made

### [Decision Name]

**Rationale:** [Why]
**Alternatives:** [What we didn't choose]
**Impact:** [What this affects]

## Open Questions

-

## Next Session

**Start here:** [Specific task or file to open]
**Blockers:** [Anything preventing progress]

## Links

- [Related devlog entries]
- [Design docs updated/created]
EOF

echo "✅ Created $FILE"

# Update devlog index
DEVLOG_DIR="docs/devlog"
{
  echo "# Development Log"
  echo ""
  echo "Chronological record of development sessions."
  echo ""
  echo "## Recent Entries"
  echo ""

  ls -1t "$DEVLOG_DIR"/*.md 2>/dev/null | grep -v README | head -10 | while read entry; do
    basename=$(basename "$entry")
    date=$(echo "$basename" | cut -d. -f1)
    # Try to extract first ## heading as description
    desc=$(grep -m1 "^## Focus" "$entry" -A1 | tail -1 | sed 's/^\[//' | sed 's/\]$//' || echo "")
    if [ -n "$desc" ]; then
      echo "- [$date]($basename) - $desc"
    else
      echo "- [$date]($basename)"
    fi
  done

  echo ""
  echo "## By Topic"
  echo ""
  echo "TODO: Organize by topic as patterns emerge"

} > "$DEVLOG_DIR/README.md"

echo "✅ Updated docs/devlog/README.md"
