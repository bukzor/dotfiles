# Documentation Maintenance Procedures

## After Every Session

1. Update .claude/todo.md (see subtask skill)
2. Create/update devlog entry
3. Update CLAUDE.md "Last Session" link
4. Update relevant design docs if decisions made

```bash
git add .claude/todo.md docs/dev/devlog/YYYY-MM-DD.md
git commit-staged .claude/todo.md docs/dev/devlog/YYYY-MM-DD.md -- -m "Update tasks and devlog"
```

## After Milestone Completion

1. Update development-plan.md
2. Update .claude/todo.md for next milestone
3. Create devlog summary entry
4. Archive/resolve any design-incubators

## Monthly

1. Review and prune stale design-incubators
2. Consolidate related devlog entries into design docs
3. Update README/HACKING if APIs changed
