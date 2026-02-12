---
requires:
  - ./all-operations.md
---

## Git Commit

### Tools

Two local commands you must use for commits:

- **`git commit-staged`** — commits staged state at specified paths
- **`git commit-files`** — stages from working tree, then commits (equivalent to
  `git add` + `git commit-staged`)

> Maintained at `~/repo/github.com/bukzor/git-partial.prototyping/`. Beta
> quality.

### Why

In a polyrepo with parallel agents, the index contains staged changes from other
work. Standard `git commit` would include those unrelated changes. These tools
commit only specified paths, ignoring other staged state.

### General Case: git commit-staged

Commits whatever is staged at the specified paths:

```bash
git commit-staged paths... -- -m "message"
```

Works regardless of how changes got staged — by you, another agent, or prior
work. Commits exactly the staged state at those paths, nothing more.

**Dry-run first:**

```bash
git commit-staged -n paths...
```

Arguments after `--` pass through to `git commit`:

- `--amend`, `--fixup`, `-C` (message reuse)
- GPG signing (`-S`)
- Commit hooks

### Common Case: git commit-files

When you want to commit your working tree edits (the typical "I edited files,
now commit them" workflow):

```bash
git commit-files paths... -- -m "message"
```

Stages from working tree, then commits. Lists paths once instead of twice.

**Dry-run:**

```bash
git commit-files -n paths...
```

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
2. **Logical grouping**: Files in the same feature/directory often form one
   commit
3. **Chronological order**: Commit oldest changes first to preserve history

### Untracked Files

**Prefer asking** when disposition is unclear. Use judgment for obvious cases.

- **Unrelated work**: Leave as-is
- **Scratch files**: `mv trash/` (prefer over `rm`)
- **Build artifacts**: Gitignore
- **Legitimate new files**: Commit

### History Rewriting (Amend, Rebase, Force-Push)

Behavior depends on the repo's `git-caution` level.

1. Check CLAUDE.md frontmatter for `git-caution: solo|personal|shared`
2. If absent, infer:
   - Repo owned by `bukzor` (remote URL or filesystem path) → `personal`
     - Record `git-caution: personal` in CLAUDE.md frontmatter
   - Otherwise → `shared`

| Level      | Amend                | Force-push                              | Main branch                    |
| ---------- | -------------------- | --------------------------------------- | ------------------------------ |
| `solo`     | Freely               | Freely                                  | Is the working branch          |
| `personal` | Freely               | `--force-with-lease`                    | Prefer clean, user's call      |
| `shared`   | Own unpushed commits | Own branches only, `--force-with-lease` | Never without explicit request |

Reflog makes all local operations recoverable.

**Amending your own commits from this session needs no verification.** Verify
authorship (`git log -1 --format='%an %ae'`) only when context is ambiguous
(session start, unfamiliar repo, shared branch).

Use `git commit-staged paths... -- --amend --no-edit` for the last commit,
`git commit-staged paths... -- --fixup SHA` for older commits.

### Commit Message Format

Use heredoc to prevent shell escaping failures:

```bash
bash <<'BASH'
git -C <directory> add path/to/file1 path/to/dir/
git -C <directory> commit-staged \
  path/to/file1 \
  path/to/dir/ \
  -- \
  -m "Short summary usable as PR title

Describe the change in more detail, usable as PR description.
Focus on why over what.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
BASH
```

### Recovery: Accidental Index Inclusion

If a commit accidentally includes staged files from the dirty index:

```bash
git reset --soft HEAD^
git commit-staged <intended-paths...> -- -C ORIG_HEAD
```

This preserves the original commit message while scoping to the correct paths.

### Before Committing

- Review the full diff
  - Verify it matches intent
  - Catch your own mistakes
  - Notice if other agents' changes got mixed in
- Double-check docs still accurate after code changes
- If (CLAUDE.md depends on) `Skill(llm-subtask)`: update todo files
- If `Skill(llm-collab)`: update devlog if session-notable

Include doc/todo updates in the commit.
