#!/bin/bash
# Auto-generate docs/adr/README.md index

set -e

if [ ! -d "docs/adr" ]; then
  echo "Error: docs/adr/ not found. Run from project root."
  exit 1
fi

{
  echo "# Architecture Decision Records"
  echo ""
  echo "Date-based ADRs: \`YYYY-MM-DD-NNN-title.md\`"
  echo ""

  # Count ADRs
  ADR_COUNT=$(ls -1 docs/adr/*.md 2>/dev/null | grep -v README | wc -l)

  if [ "$ADR_COUNT" -eq 0 ]; then
    echo "## Recent Decisions"
    echo ""
    echo "None yet. Create your first ADR:"
    echo ""
    echo "\`\`\`bash"
    echo ".claude/new-adr.sh \"Your decision title\""
    echo "\`\`\`"
  else
    echo "## Recent Decisions"
    echo ""

    ls -1t docs/adr/*.md | grep -v README | head -10 | while read file; do
      TITLE=$(head -1 "$file" | sed 's/^# //')
      BASE=$(basename "$file")
      DATE=$(echo "$BASE" | cut -d- -f1-3)
      STATUS=$(grep "^**Status:**" "$file" | sed 's/^**Status:** //' || echo "Unknown")
      echo "- [$TITLE]($BASE) - $DATE - *$STATUS*"
    done

    echo ""
    echo "## By Status"
    echo ""

    for status in Accepted Proposed Deprecated Superseded; do
      FILES=$(grep -l "Status.*$status" docs/adr/*.md 2>/dev/null | grep -v README || true)
      if [ -n "$FILES" ]; then
        echo "### $status"
        echo ""
        echo "$FILES" | while read file; do
          TITLE=$(head -1 "$file" | sed 's/^# //')
          BASE=$(basename "$file")
          echo "- [$TITLE]($BASE)"
        done
        echo ""
      fi
    done
  fi

  echo "## Quick Search"
  echo ""
  echo "\`\`\`bash"
  echo "# Recent ADRs"
  echo "ls -1t docs/adr/*.md | grep -v README | head -5"
  echo ""
  echo "# ADRs from specific month"
  echo "ls docs/adr/2025-11-*.md"
  echo ""
  echo "# Search by keyword"
  echo "grep -l \"keyword\" docs/adr/*.md"
  echo ""
  echo "# By status"
  echo "grep -l \"Status.*Accepted\" docs/adr/*.md"
  echo "\`\`\`"
  echo ""
  echo "## Creating ADRs"
  echo ""
  echo "\`\`\`bash"
  echo ".claude/new-adr.sh \"Your decision title\""
  echo "\`\`\`"
  echo ""
  echo "Auto-increments within each day. Supports up to 1000 decisions per day."

} > docs/adr/README.md

echo "✅ Updated docs/adr/README.md"
