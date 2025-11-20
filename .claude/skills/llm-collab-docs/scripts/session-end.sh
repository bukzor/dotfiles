#!/bin/bash
# Session end helper - updates documentation

set -e

HERE="$(cd "$(dirname "$0")"; pwd)"

echo "📝 Wrapping up session..."
echo ""

# Reminder to update todo.md
echo "⚠️  Remember to update .claude/todo.md with current TodoWrite state"
echo ""

# Show git status
echo "=== Git Status ==="
git status

echo ""
echo "✅ Session wrapped up"
echo ""
echo "Next steps:"
echo "  1. Update .claude/todo.md (if not already done)"
echo "  2. Review changes: git diff"
echo "  3. Commit if appropriate: git add -A && git commit -m \"...\""
echo "  4. Next session: $HERE/session-start.sh"
