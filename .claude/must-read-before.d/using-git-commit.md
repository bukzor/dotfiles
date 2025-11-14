## Git Usage

### Committing files

Preferred method - specify paths directly:

```bash
git commit -m "commit message" path/to/file1 path/to/file2
```

This commits the specified files from the working tree, ignoring any staged changes. This is cleaner than staging files first with `git add`.

### Fixing incomplete commits

When changes should have been part of an existing commit originally:

Before fixing, verify:
- You authored the commit: `git log -1 --format='%an %ae'`
- It hasn't been pushed to main/master
- Never amend other developers' commits

Use `git commit --amend` for the last commit, `git commit --fixup SHA` for older commits.
