# TODO: Extract core logic to git-restore-repo

## Idea

Extract the worktree setup logic from `post-init` hook into a standalone `bin/git-restore-repo` script. This provides:

1. **Explicit command**: Users can run `git restore-repo` instead of `touch foo && git add foo` to trigger setup
2. **Better discoverability**: Named as a git command (`git-restore-repo`)
3. **Reusability**: Same logic for both hook-triggered and manual setup
4. **Cleaner separation**: Hooks become thin wrappers

## Workflow Examples

**Convert existing repo:**
```bash
cd ~/existing-repo
git restore-repo  # Converts to use localhost store
```

**Recover after rm -rf:**
```bash
mkdir ~/deleted-repo && cd ~/deleted-repo
git restore-repo  # Direct recovery
```

## Tasks

- [ ] Create `bin/git-restore-repo` with core logic from `post-init`
  - [ ] Move all worktree setup logic (git_is_empty, mv .git, config, etc.)
  - [ ] Keep PS4 export and trace output
  - [ ] Handle both new repo and recovery cases
  - [ ] Move index preservation logic
  - [ ] Move deleted files restoration logic

- [ ] Simplify `hooks/post-init` to call `git-restore-repo`
  - [ ] Check if .git is directory: `[ -d .git ]`
  - [ ] Call: `git-restore-repo`
  - [ ] That's it!

- [ ] Update `hooks/post-index-change` and `hooks/pre-commit` similarly
  - [ ] Both just need: `[ -d .git ] && git-restore-repo`

- [ ] Update README.md
  - [ ] Document `git restore-repo` command
  - [ ] Show explicit setup example
  - [ ] Note it's auto-triggered by git add/commit

- [ ] Test both paths
  - [ ] Manual: `git restore-repo` in fresh repo
  - [ ] Automatic: `git add` in fresh repo
  - [ ] Recovery: `rm -rf && mkdir && git restore-repo`

## Notes

- `git-restore-repo` should be in `bin/` and symlinked or in PATH
- Could add `--help` flag for documentation
- Consider making idempotent (safe to run multiple times)
