# Commit Command

Commit changes for the work just completed.

## Dirty-Index Safety

The repository may have staged changes unrelated to current work. Treat index modification as destructive—avoid `git add` for tracked files.

## Required: Path Scoping

All git commands MUST specify paths to scope operations:

```bash
git status <path>
git diff <path>
git commit <path...> -m "message"
```

## Inferring Commit Boundaries

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

## Triage Untracked Files

**ASK before assuming.** Present untracked files to the user and confirm disposition:
- **Scratch/test files**: Remove (`rm`)
- **Tool internals**: Gitignore (e.g., `plans/`, `hooks/`, `*.log`)
- **Legitimate new files**: Commit

Do not attempt to commit untracked files without explicit confirmation.

## Workflow

1. **Identify scope**: Determine which paths contain the changes to commit
2. **Check status**: `git status <path>` to see what changed
3. **Triage untracked files** (see above)
4. **Handle untracked files to commit**:
   - Update `.gitignore` if files should be ignored
   - `git add <untracked-file>` only for new files that must be committed (untracked files cannot be committed by path alone)
5. **Commit with paths**: Commit tracked files directly by path, bypassing the index:

```bash
bash <<'BASH'
git commit path/to/file1 path/to/dir/ -m "Descriptive commit message"
BASH
```

The heredoc prevents shell escaping failures in commit messages. This commits the working tree state of specified paths, ignoring any staged changes.

## Commit Message

- Focus on the "why" over the "what"
- End with the standard footer:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Recovery: Accidental Index Inclusion

If a commit accidentally includes staged files from the dirty index (e.g., via `--amend`):

```bash
git reset --soft HEAD^
git commit -C ORIG_HEAD -- <intended-paths...>
```

This preserves the original commit message while scoping to the correct paths. The unrelated files remain staged in the index.
