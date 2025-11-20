#!/bin/bash
# Session start helper - reads key files for orientation

set -e

echo "📖 Reading session context..."
echo ""

# Read CLAUDE.md
if [ -f .claude/README.md ]; then
  echo "=== .claude/README.md ==="
  cat .claude/README.md
  echo ""
fi

# Read STATUS.md
if [ -f STATUS.md ]; then
  echo "=== STATUS.md ==="
  cat STATUS.md
  echo ""
fi

# Read latest devlog
LAST_LOG=$(ls -1t docs/devlog/*.md 2>/dev/null | grep -v README | head -1)
if [ -n "$LAST_LOG" ]; then
  echo "=== Latest Devlog: $(basename "$LAST_LOG") ==="
  cat "$LAST_LOG"
  echo ""
fi

# Show recent ADRs
ADR_COUNT=$(ls -1 docs/adr/*.md 2>/dev/null | grep -v README | wc -l)
if [ "$ADR_COUNT" -gt 0 ]; then
  echo "=== Recent ADRs ==="
  ls -1t docs/adr/*.md | grep -v README | head -3 | while read adr; do
    TITLE=$(head -1 "$adr" | sed 's/^# //')
    echo "  - $TITLE ($(basename "$adr"))"
  done
  echo ""
fi

echo "✅ Session context loaded"
echo ""
echo "Quick commands:"
echo "  - Create ADR: .claude/new-adr.sh \"Decision title\""
echo "  - Create devlog: .claude/new-devlog.sh"
echo "  - Update STATUS: .claude/update-status.sh"
echo "  - End session: .claude/session-end.sh"
