## Git Usage

### Committing files

Preferred method - specify paths directly:

```bash
git commit -m "commit message" path/to/file1 path/to/file2
```

This commits the specified files from the working tree, ignoring any staged changes. This is cleaner than staging files first with `git add`.
