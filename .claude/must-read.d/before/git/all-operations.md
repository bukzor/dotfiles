## Git Operations

### Repository Targeting

Use `git -C <directory>` to specify the repository -- never `cd <directory> && git`:

```bash
git -C /path/to/project status
git -C /path/to/project diff HEAD~1
```

### Path Scoping

Scope operations to specific paths:

```bash
git status <path>
git diff <path>
git log <path>
git commit <path...> -m "message"
```

### Index Hygiene

The index may contain staged changes unrelated to current work. Treat index modification as destructive.

- Avoid `git add` for tracked files -- commit paths directly
- `git add` only for untracked files that must be committed
- When committing, specify paths to bypass the index
