# Subtask Management

## Overview

Subtasks are tracked in `.claude/todo.md` using standard markdown checkbox syntax. This file is git-controlled, persistent across sessions, and directly editable by the user via vim.

**TodoWrite tool is disabled** - never attempt to use it.

## Convention

When you encounter these markers anywhere in `.claude/todo.md`, take the specified action:

- `todo push: DESCRIPTION` - Append `- [ ] DESCRIPTION` to the end of the file
- `todo pop:` - Find the first `- [ ]` item and change it to `- [x]`
- `todo list:` - Read and display the entire file contents
- `todo clear:` - Remove all lines containing `- [x]` (completed items)

## Format

Standard markdown checkboxes:
- `- [ ]` indicates pending tasks
- `- [x]` indicates completed tasks

## Benefits

- **Zero-token overhead**: Markers are processed when reading the file (already in context)
- **Persistent**: Survives across all Claude Code sessions
- **Git-controlled**: User gets automatic notification of changes via git diff
- **Dual-access**: User can edit directly in vim, Claude edits via Read/Edit tools
- **Single source of truth**: No competing todo systems

## Usage Pattern

Complex multi-step tasks should add their own `todo push:` markers to `.claude/todo.md`. Work through tasks by marking them complete with `todo pop:` as you finish each one.
