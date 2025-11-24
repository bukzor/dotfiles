#!/bin/bash
# Initialize LLM-collaborative documentation structure

set -e

PROJECT_ROOT=${1:-.}
cd "$PROJECT_ROOT"

echo "🚀 Initializing LLM-collaborative documentation structure..."

# Create directory structure
mkdir -p .claude/todo.d
mkdir -p docs/{adr,architecture,milestones,devlog,examples}

echo "✅ Created directory structure"

# Create .claude/README.md (CLAUDE.md)
if [ ! -f .claude/README.md ]; then
  cat > .claude/README.md <<'EOF'
# Development Guide for Claude

## Quick Reference

**Current state:** Check `.claude/todo.d/` for pending tasks, or latest [devlog entry](../docs/devlog/).

## Common Tasks

TODO: Document common development tasks with brief summaries and links to detailed docs.

## Architecture Overview

TODO: 3-5 sentence summary of how the system works.

See [docs/architecture/overview.md](../docs/architecture/overview.md) for details.

## Key Files

TODO: List important files and what they do.

## Decision History

See [docs/adr/](../docs/adr/) for architecture decisions.
EOF
  echo "✅ Created .claude/README.md"
fi

# Create .gitkeep for todo.d
if [ ! -f .claude/todo.d/.gitkeep ]; then
  touch .claude/todo.d/.gitkeep
  echo "✅ Created .claude/todo.d/ directory"
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

Use the llm-collab-docs skill scripts (see ~/.claude/skills/llm-collab-docs/scripts/).

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

# Note: Helper scripts remain in skill directory
HERE="$(cd "$(dirname "$0")"; pwd)"
SKILL_DIR="$(cd "$HERE/.." && pwd)"

echo "✅ Helper scripts available at: $SKILL_DIR/scripts/"

# Create first devlog entry
if [ ! -f "docs/devlog/$(date +%Y-%m-%d).md" ]; then
  "$HERE/new-devlog.sh"
  echo "✅ Created first devlog entry"
fi

echo ""
echo "🎉 Documentation structure initialized!"
echo ""
echo "Next steps:"
echo "  1. Edit .claude/README.md with project-specific guidance"
echo "  2. Create TODOs as needed: $SKILL_DIR/scripts/new-todo.sh \"Task title\""
echo "  3. Create first ADR: $SKILL_DIR/scripts/new-adr.sh \"Your decision\""
echo "  4. At session end: $SKILL_DIR/scripts/session-end.sh"
