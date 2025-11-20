#!/bin/bash
# Auto-generate STATUS.md from latest devlog and ROADMAP

set -e

if [ ! -f "STATUS.md" ] || [ ! -d "docs/devlog" ]; then
  echo "Error: STATUS.md or docs/devlog/ not found. Run from project root."
  exit 1
fi

# Find latest devlog
LAST_LOG=$(ls -1t docs/devlog/*.md 2>/dev/null | grep -v README | head -1)

if [ -z "$LAST_LOG" ]; then
  echo "Warning: No devlog entries found. Create one with: .claude/new-devlog.sh"
  exit 1
fi

LAST_DATE=$(basename "$LAST_LOG" .md)

# Extract "Next Session" tasks from latest devlog
NEXT_ACTIONS=$(sed -n '/^## Next Session/,/^##/p' "$LAST_LOG" | grep -v "^##" | grep -v "^$" | head -5 || echo "")

# Extract current milestone from ROADMAP if it exists
MILESTONE="See [ROADMAP.md](ROADMAP.md)"
if [ -f "ROADMAP.md" ]; then
  FIRST_MILESTONE=$(grep -m1 "^### Milestone" ROADMAP.md | sed 's/^### //' || echo "")
  if [ -n "$FIRST_MILESTONE" ]; then
    MILESTONE="$FIRST_MILESTONE - See [ROADMAP.md](ROADMAP.md)"
  fi
fi

# Generate STATUS.md
cat > STATUS.md <<EOF
# Project Status

**Last Updated:** $(date +%Y-%m-%d) (auto-generated)

## Current Focus

- **Last Session:** [devlog/$LAST_DATE](docs/devlog/$LAST_DATE.md)
- **Milestone:** $MILESTONE

## Next Actions

$NEXT_ACTIONS

---
*Auto-generated from latest devlog. See devlog for full details.*
EOF

echo "✅ Updated STATUS.md from $LAST_LOG"
