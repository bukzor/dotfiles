# Devlog: 2026-05-08 — batch-migrate remaining legacy stores

## Focus

Drain the audit-gitfiles backlog (18 candidates) by extending
`migrate-from-gitfile` to handle the post-cutover in-place case and
common per-worktree state files.

## Survey

Of 18 candidates:

- **17 in-place**: gitfile already points at the encoded target path
  under `<store>`. Standard tool would fail
  `check_target_store_does_not_exist`.
- **1 with stale gitfile from a workdir move**:
  `~/claude/amazon-searches` — gitfile points at the
  `-home-bukzor-claude-empty` store. Per commit `1210b52`, the workdir
  was moved from `~/claude/empty/` to `~/claude/amazon-searches/`
  without updating the gitfile or relocating the store.
- **None with submodule gitdirs**: the home-dir migration's
  `core.worktree` rewriting story (devlog 2026-05-08-000) doesn't apply
  to any candidate here. Deferred.

Worktree-dir contents varied beyond the original 5-name allowlist
(`commondir`, `gitdir`, `HEAD`, `index`, `refs`):

- 13/18: `COMMIT_EDITMSG`, `logs/HEAD`
- 3/18: `ORIG_HEAD`
- 1/18: `FETCH_HEAD` (and it conflicts with `<store>/FETCH_HEAD`)
- 1/18: `REBASE_HEAD` (stale — no rebase-merge/rebase-apply dir)
- 5/18: `index.commit-staged.<pid>` files (junk left by pre-commit
  hook's index-swap dance)
- 1/18: `filter-repo/` directory (from `git filter-repo`)

## Tool changes (`migrate.py`)

1. **In-place case**: `check_target_store_does_not_exist` returns None
   when `plan.new_store == plan.layout.store`. `migrate()` skips
   `relocate_store` in that branch.
2. **Promote ephemeral state**: `WORKTREE_PROMOTABLE` now includes
   `COMMIT_EDITMSG`, `ORIG_HEAD`, `FETCH_HEAD`, `REBASE_HEAD`, `logs`.
   The old single-purpose `mv HEAD; mv index` is replaced with a loop;
   `logs` is special-cased to merge `<wt>/logs/HEAD` into
   `<store>/logs/` without touching the shared `logs/refs/heads/*`.
3. **Conflict detection**: new `check_no_promote_collisions`
   precondition — refuses to migrate if a promotable file would
   overwrite an existing one in the store. (HEAD and index are
   exempted; their store counterparts are intentionally overwritten.)
4. **Junk discard**: `index.commit-staged.<pid>` files are matched by
   regex and removed during `promote_worktree_state`.
5. **REBASE_HEAD demoted**: removed from `IN_PROGRESS_MARKERS`. The
   reliable signals of an active rebase are the `rebase-merge/` and
   `rebase-apply/` directories; `REBASE_HEAD` lingers across successful
   completion.

## Stage 1: 5 simple repos

`volta`, `lazy.nvim`, `LazyVim`, `litellm`, `pytest-pyright` — only the
5 canonical worktree files, no extras. Migrated with the in-place patch
alone, no other code changes needed. All passed first try.

## Stage 2: 10 repos with ephemeral state

`tmp/test-{git-localhost,pipe-index,untracked}`, three under
`repo/github.com/bukzor/`, `bukzor.garden` (stale REBASE_HEAD),
`scratch.vim-work`, `private.evan-family`, `claude/research.home-office`,
`claude/founder-os`. All passed in one batch with the extended tool.

## Edge case: `/home/bukzor/empty` is mode 555

The workdir is intentionally read-only (kept as a degenerate test
fixture). `swap_gitlink_atomic` failed at `ln -s …/.git.new` because the
directory rejected the write. The store-side mutations had already
completed, so manually `chmod u+w`, ran the symlink swap, restored
mode. Did not add an auto-chmod step to the tool — only one candidate
exhibits this and the failure is loud and obvious.

## Stage 3: 2 hard cases left

Not migrated; deferred to a separate session:

- **`~/repo/github.com/bukzor/bukzor-agent-skills`**: `<wt>/FETCH_HEAD`
  and `<store>/FETCH_HEAD` both exist (different fetches), and the
  worktree contains an unknown `filter-repo/` directory left by `git
  filter-repo`. The tool's `check_no_promote_collisions` and
  `check_no_unexpected_worktree_files` will both fail loudly. User
  needs to decide which FETCH_HEAD wins and what to do with the
  `filter-repo/` state cache.
- **`~/claude/amazon-searches`**: gitfile points at
  `-home-bukzor-claude-empty/worktrees/empty/`, the leftover from a
  pre-rename workdir at `~/claude/empty/`. The standard migration
  would land at the wrong encoded path. Either rename-the-store-then-
  migrate, or rebuild from origin.

## Backups

`~/trash/legacy-store-backups/<encoded>.tar.zst` for all 16 migrated
stores. Total ~520 MB compressed (mostly `litellm` at 476 MB). Delete
when comfortable that everything works.

## Status

`audit-gitfiles` reports 2 remaining (the Stage 3 cases). 16/18 done.

## Loose ends

- The in-place migration test (`testing.kb/migrate-in-place.md`)
  exercises the new branch via XDG override. The standard
  `migrate-from-legacy-layout.md` test still covers the
  store-needs-relocation branch.
- Submodule `core.worktree` rewriting is still on the TODO. None of
  the 16 we just migrated needed it. The rewrite logic from
  devlog 2026-05-08-000 (manual `~/` migration) hasn't been folded
  into the tool yet.
