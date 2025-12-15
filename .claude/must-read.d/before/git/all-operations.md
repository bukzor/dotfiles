## Git Operations

### Repository Targeting

Use `git -C <directory>` to specify the repository -- never `cd <directory> && git`:

```bash
git -C /path/to/project status
git -C /path/to/project diff HEAD~1
```

### Path Scoping

Always scope operations to specific paths. Use `.` for current directory:

```bash
git status -s .
git diff .
git log --oneline -10 .
git commit <path...> -m "message"
```

Other paths:
```bash
git status -s path/to/file
git diff path/to/directory/
git commit path1 path2 path3 -m "message"
```

### Index Hygiene

The index may contain staged changes unrelated to current work. Treat index modification as destructive.

- Stage changes with `git add` before committing
- Use `git commit-staged` to commit only staged changes at specific paths
- Never use `git commit -- paths` - it commits from working copy, not the index
