---
cost-benefit-sweh:
  timebox:
    "@value": 0.75
    rationale: |
      mv + grep references + replace + verify. Mechanical. Beyond
      45 min, a reference is hiding in an unexpected place and
      deserves a longer-form audit.
  benefit-2w:
    "@value": 3.0
    rationale: |
      Unblocks both Task.extract-sessions-kb-to-private-repo (~3h)
      and Task.move-skill-triggers-to-must-read-kb (~2h) by clearing
      the git-commit prerequisite. Highest ROI item in the backlog.
---

# Task: Rename must-read-before.d to must-read.d/before

## Objective

Restructure `~/.claude/must-read-before.d/` to `~/.claude/must-read.d/before/` to enable the new `must-read.d/after/` pattern for reactive/troubleshooting documentation.

Steps:

- [ ] Rename `~/.claude/must-read-before.d` → `~/.claude/must-read.d/before`
- [ ] Grep for all references to the old path under `~/.claude`, `~/claude`, `~/repo/github.com/bukzor`
- [ ] Update operational references (CLAUDE.md, commands frontmatter, skills, ADRs reflecting current state, outstanding todos, self-references)
- [ ] Verify: structure listing matches expectation, grep returns no stale references

## Steps

### 1. Rename the directory

```bash
mv ~/.claude/must-read-before.d ~/.claude/must-read.d/before
```

### 2. Find all references to the old path

```bash
grep -r "must-read-before.d" ~/.claude ~/claude ~/repo/github.com/bukzor 2>/dev/null
```

### 3. Update references

**Update ALL references** including ADRs, commands, skills, and outstanding todos.

Replacement patterns:
| Old | New |
|-----|-----|
| `must-read-before.d/` | `must-read.d/before/` |
| `must-read-before.d` (no trailing slash) | `must-read.d/before` |
| `../must-read-before.d/` | `../must-read.d/before/` |

**Special case - CLAUDE.md ls command:**
```
# Old
ls -RF ~/.claude/must-read-before.d

# New (shows both before/ and after/)
ls -RF ~/.claude/must-read.d
```

**File categories to update:**
- `~/.claude/CLAUDE.md` - main instructions
- `~/.claude/commands/*.md` - slash commands with `depends:` front matter (use relative paths)
- `~/.claude/skill-categories/CLAUDE.md`
- `~/.claude/skills/*/SKILL.md`
- `~/.claude/docs/adr/*.md` - ADRs (update to reflect current state)
- `~/.claude/skills/*/.claude/todo.d/*.md` - outstanding todos only
- Any files under `must-read.d/before/` that self-reference

### 4. Verify

```bash
# Confirm structure
ls -RF ~/.claude/must-read.d/

# Confirm no stale references remain
grep -r "must-read-before.d" ~/.claude ~/claude ~/repo/github.com/bukzor 2>/dev/null
```

Should return no matches.

## Notes

- The `must-read.d/after/` directory already exists with one file: `proc-transport-endpoint-not-connected.md`
- Preserve all subdirectory structure within before/ (git/, lazy-loading/, using-claude-code-tool/)
