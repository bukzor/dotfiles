# Documentation Maintenance Procedures

## After Every Session

1. Update .claude/todo.md (see subtask skill)
2. Create/update devlog entry
3. Update CLAUDE.md "Last Session" link
4. Update design docs if architectural changes made

```bash
git add .claude/todo.md docs/dev/devlog/YYYY-MM-DD.md
git commit-staged .claude/todo.md docs/dev/devlog/YYYY-MM-DD.md -- -m "Update tasks and devlog"
```

## After Major Milestone

1. Update .claude/todo.md for next phase
2. Create devlog summary entry
3. Distill learnings into docs/dev/design/

## Monthly

1. Consolidate related devlog entries into design docs
2. Update README/HACKING if APIs changed
