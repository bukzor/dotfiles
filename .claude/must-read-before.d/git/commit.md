---
requires:
  - ./all-operations.md
---

## Git Commit

### Inferring Commit Boundaries

Use mtime to understand the temporal structure of uncommitted changes:

```bash
git status -s <path> | awk '{print $2}' | xargs --replace find {} -type f -print0 | xargs -0 ls -lt --time-style=full-iso
```

This reveals work sessions and natural commit boundaries. Apply when:
- Changes span multiple days or sessions
- Multiple unrelated files appear in status
- Conversation context doesn't clearly indicate which changes to commit

Group into single-topic commits by:
1. **Time clustering**: Files modified within minutes likely belong together
2. **Logical grouping**: Files in the same feature/directory often form one commit
3. **Chronological order**: Commit oldest changes first to preserve history

### Untracked Files

**ASK before assuming.** Present untracked files to the user and confirm disposition:
- **Unrelated work**: Leave as-is (not this commit's concern)
- **Scratch/test files**: Remove (`rm`)
- **Tool internals**: Gitignore (e.g., `plans/`, `hooks/`, `*.log`)
- **Legitimate new files**: Commit

Do not commit untracked files without explicit confirmation.

### Amend Safety

Before amending, verify:
- You authored the commit: `git log -1 --format='%an %ae'`
- It hasn't been pushed to main/master
- Never amend other developers' commits

Use `git commit --amend` for the last commit, `git commit --fixup SHA` for older commits.

### Commit Message Format

Use heredoc to prevent shell escaping failures:

```bash
bash <<'BASH'
git \
  -C <directory> \
  commit \
    path/to/file1 \
    path/to/dir/ \
  -m "Short summary usable as PR title

Describe the change in more detail, usable as PR description.
Focus on why over what.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>" \
;
BASH
```

### Recovery: Accidental Index Inclusion

If a commit accidentally includes staged files from the dirty index:

```bash
git reset --soft HEAD^
git commit -C ORIG_HEAD -- <intended-paths...>
```

This preserves the original commit message while scoping to the correct paths.

### For llm-collab-docs Projects

If project CLAUDE.md has `depends: skills/llm-collab-docs`, before committing:
- Update `.claude/todo.md` with completed/new tasks
- Create or update devlog entry documenting the session

Include these in the commit.
