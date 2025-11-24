#!/bin/bash
# Session end helper - updates documentation

set -e

HERE="$(cd "$(dirname "$0")"; pwd)"

echo "📝 Wrapping up session..."
echo ""

# Reminder to create TODOs
echo "⚠️  Remember to create .claude/todo.d/ files for remaining work:"
echo "    $HERE/new-todo.sh \"Task title\""
echo ""

# Show git status
echo "=== Git Status ==="
git status

echo ""
echo "✅ Session wrapped up"
echo ""
echo "Next steps:"
echo "  1. Create TODOs for remaining work: $HERE/new-todo.sh \"Task title\""
echo "  2. Review changes: git diff"
echo "  3. Commit if appropriate: git add -A && git commit -m \"...\""
echo "  4. Next session: $HERE/session-start.sh"
