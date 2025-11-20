#!/bin/bash
# Session start helper - reads key files for orientation

set -e

HERE="$(cd "$(dirname "$0")"; pwd)"

echo "📖 Reading session context..."
echo ""

# Read CLAUDE.md
if [ -f CLAUDE.md ]; then
  echo "=== CLAUDE.md ==="
  cat CLAUDE.md
  echo ""
fi

# Read .claude/todo.md
if [ -f .claude/todo.md ]; then
  echo "=== .claude/todo.md ==="
  cat .claude/todo.md
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
echo "  - Create ADR: $HERE/new-adr.sh \"Decision title\""
echo "  - Create devlog: $HERE/new-devlog.sh"
echo "  - Update .claude/todo.md before commit"
