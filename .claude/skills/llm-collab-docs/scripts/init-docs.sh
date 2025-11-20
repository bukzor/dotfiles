#!/bin/bash
# Initialize LLM-collaborative documentation structure

set -e

PROJECT_ROOT=${1:-.}
cd "$PROJECT_ROOT"

echo "🚀 Initializing LLM-collaborative documentation structure..."

# Create directory structure
mkdir -p .claude
mkdir -p docs/{adr,architecture,milestones,devlog,examples}

echo "✅ Created directory structure"

# Create .claude/README.md (CLAUDE.md)
if [ ! -f .claude/README.md ]; then
  cat > .claude/README.md <<'EOF'
# Development Guide for Claude

## Quick Reference

**Current state:** See [../STATUS.md](../STATUS.md) for milestone, blockers, and next actions.

## Common Tasks

TODO: Document common development tasks with brief summaries and links to detailed docs.

## Architecture Overview

TODO: 3-5 sentence summary of how the system works.

See [docs/architecture/overview.md](../docs/architecture/overview.md) for details.

## Key Files

TODO: List important files and what they do.

## Latest Session

See most recent entry in [docs/devlog/](../docs/devlog/) for last session's work.
EOF
  echo "✅ Created .claude/README.md"
fi

# Create STATUS.md
if [ ! -f STATUS.md ]; then
  TODAY=$(date +%Y-%m-%d)
  cat > STATUS.md <<EOF
# Project Status

**Last Updated:** $TODAY

## Current Focus

- **Last Session:** [devlog/$TODAY](docs/devlog/$TODAY.md)
- **Milestone:** See [ROADMAP.md](ROADMAP.md)

## Next Actions

1. TODO: First concrete action
2. TODO: Second concrete action
3. TODO: Third concrete action
EOF
  echo "✅ Created STATUS.md"
fi

# Create ROADMAP.md
if [ ! -f ROADMAP.md ]; then
  cat > ROADMAP.md <<'EOF'
# Roadmap

## Milestones

### Milestone 1: [Name]

**Status:** Not Started

**Goal:** [What this milestone achieves]

See [docs/milestones/01-milestone-name.md](docs/milestones/01-milestone-name.md) for details.
EOF
  echo "✅ Created ROADMAP.md"
fi

# Create CONTRIBUTING.md
if [ ! -f CONTRIBUTING.md ]; then
  cat > CONTRIBUTING.md <<'EOF'
# Contributing

## For Human Contributors

### Setup

TODO: Development setup instructions

### Running Tests

TODO: How to run tests

## For LLM Development Assistants

See [.claude/README.md](.claude/README.md) for agent-specific guidance.
EOF
  echo "✅ Created CONTRIBUTING.md"
fi

# Create docs/adr/README.md
if [ ! -f docs/adr/README.md ]; then
  cat > docs/adr/README.md <<'EOF'
# Architecture Decision Records

Date-based ADRs: `YYYY-MM-DD-NNN-title.md`

## Quick Search

```bash
# Recent ADRs
ls -1t docs/adr/*.md | grep -v README | head -5

# ADRs from specific month
ls docs/adr/2025-11-*.md

# Search by keyword
grep -l "keyword" docs/adr/*.md
```

## Creating ADRs

```bash
.claude/new-adr.sh "Your decision title"
```

## Recent Decisions

None yet. Create your first ADR!
EOF
  echo "✅ Created docs/adr/README.md"
fi

# Create docs/devlog/README.md
if [ ! -f docs/devlog/README.md ]; then
  cat > docs/devlog/README.md <<'EOF'
# Development Log

Chronological record of development sessions.

## Recent Entries

None yet. Create your first devlog entry!

## By Topic

Will be organized as entries are created.
EOF
  echo "✅ Created docs/devlog/README.md"
fi

# Create docs/architecture/overview.md
if [ ! -f docs/architecture/overview.md ]; then
  cat > docs/architecture/overview.md <<'EOF'
# Architecture Overview

## System Overview

TODO: High-level description of what the system is.

## Components

TODO: Major components and their responsibilities.

## Data Flow

TODO: How information moves through the system.
EOF
  echo "✅ Created docs/architecture/overview.md"
fi

# Copy helper scripts to .claude/
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for script in new-adr.sh new-devlog.sh update-status.sh update-adr-index.sh session-start.sh session-end.sh; do
  if [ -f "$SKILL_DIR/scripts/$script" ] && [ ! -f ".claude/$script" ]; then
    cp "$SKILL_DIR/scripts/$script" ".claude/"
    chmod +x ".claude/$script"
  fi
done

echo "✅ Copied helper scripts to .claude/"

# Create first devlog entry
if [ ! -f "docs/devlog/$(date +%Y-%m-%d).md" ]; then
  .claude/new-devlog.sh
  echo "✅ Created first devlog entry"
fi

echo ""
echo "🎉 Documentation structure initialized!"
echo ""
echo "Next steps:"
echo "  1. Edit .claude/README.md with project-specific guidance"
echo "  2. Update STATUS.md with current milestone and actions"
echo "  3. Create first ADR: .claude/new-adr.sh \"Your decision\""
echo "  4. At session end: .claude/session-end.sh"
