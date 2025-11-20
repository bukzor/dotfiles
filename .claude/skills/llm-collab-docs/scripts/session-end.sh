#!/bin/bash
# Session end helper - updates documentation

set -e

echo "📝 Wrapping up session..."
echo ""

# Update STATUS.md from latest devlog
if [ -f .claude/update-status.sh ]; then
  .claude/update-status.sh
fi

# Update ADR index
if [ -f .claude/update-adr-index.sh ]; then
  .claude/update-adr-index.sh
fi

# Show git status
echo ""
echo "=== Git Status ==="
git status

echo ""
echo "✅ Session wrapped up"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Commit if appropriate: git add -A && git commit -m \"...\""
echo "  3. Next session: .claude/session-start.sh"
