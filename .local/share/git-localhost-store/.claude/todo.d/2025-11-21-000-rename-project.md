# Rename Project: git-localhost-store → git-restore-repo

**Priority:** High
**Complexity:** Medium
**Context:** docs/devlog/2025-11-21.md

## Rationale

The primary user-facing command is now `git-restore-repo`. The project name should match to:
- Improve discoverability
- Reduce confusion (name matches what you actually run)
- Follow convention (project named after main command)

## What Needs Changing

### 1. XDG Paths

**Current:**
- `${XDG_DATA_HOME:-$HOME/.local/share}/git-localhost-store`
- `${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos`

**New:**
- `${XDG_DATA_HOME:-$HOME/.local/share}/git-restore-repo`
- `${XDG_STATE_HOME:-$HOME/.local/state}/git-restore-repo/repos`

**Files to update:**
- `bin/git-restore-repo` (line 9: REPOS_ROOT, line 12: OBJECT_STORE)
- `template-repo/hooks/post-index-change` (line 6: STORE_HOME)
- `template-repo/hooks/pre-commit` (line 6: STORE_HOME)
- `README.md` (all references)
- `CLAUDE.md` (all references)
- `TESTING.md` (all references)
- `docs/adr/2025-11-21-000-*.md` (references in consequences)
- `docs/devlog/2025-11-21.md` (references throughout)

### 2. Git Config

**Documentation to update in README.md:**

**Current:**
```bash
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"
```

**New:**
```bash
git config --global init.templateDir "$HOME/.local/share/git-restore-repo/template-repo"
```

### 3. Documentation

Update all narrative references from "git-localhost-store system" to "git-restore-repo system"

### 4. Repository Location

The actual repository directory would move from:
- `/home/bukzor/.local/share/git-localhost-store/`

To:
- `/home/bukzor/.local/share/git-restore-repo/`

But this is a git worktree checkout, so we need to update the parent repo's worktree configuration.

## Migration Considerations

### Backward Compatibility

**Existing installations will break** if users:
1. Have existing repos using old path
2. Have git config pointing to old path

**Options:**

**A) Hard cut (RECOMMENDED):**
- Update everything to new paths
- Document in README that existing users need to:
  1. Update git config
  2. Re-run setup for existing repos
  3. OR symlink old path to new path temporarily

**B) Support both paths:**
- Check both old and new locations
- Adds complexity, delays inevitable migration

**Recommendation:** Hard cut with clear migration guide.

### Migration Guide Draft

For existing users, add to README.md:

```markdown
## Upgrading from git-localhost-store

If you previously installed as git-localhost-store:

1. Update git config:
   ```bash
   git config --global init.templateDir "$HOME/.local/share/git-restore-repo/template-repo"
   ```

2. Move the installation:
   ```bash
   mv ~/.local/share/git-localhost-store ~/.local/share/git-restore-repo
   mv ~/.local/state/git-localhost-store ~/.local/state/git-restore-repo
   ```

3. Existing repos will continue to work (they store absolute paths to the old location)

4. OR create a compatibility symlink:
   ```bash
   ln -s ~/.local/share/git-restore-repo ~/.local/share/git-localhost-store
   ln -s ~/.local/state/git-restore-repo ~/.local/state/git-localhost-store
   ```
```

## Testing Checklist

After renaming:

- [ ] Fresh installation works
- [ ] `git restore-repo` command works
- [ ] Hook-triggered setup works (git add)
- [ ] Recovery scenario works (rm -rf → restore)
- [ ] All paths in error messages show new name
- [ ] Documentation renders correctly (no broken links)

## Implementation Steps

1. Update all file references (paths, docs)
2. Test in fresh location
3. Add migration guide to README.md
4. Update ADR/devlog if needed
5. Commit with clear message about breaking change
6. Consider tagging last commit before rename as "v0.1-git-localhost-store"

## Open Questions

- Should we add a deprecation warning if old paths exist?
- Should we provide a migration script?
- Tag the pre-rename commit for users who want old behavior?
