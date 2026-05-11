# Devlog: 2026-05-11 — drain final Stage-3 cases

## Focus

Finish the legacy-gitfile migration backlog: two repos left from
`2026-05-08-001`'s Stage-3 deferral. `audit-gitfiles` should report
empty when done. No tool changes — exercise the existing tool with
careful pre-steps.

## Findings (devlog corrections)

The 2026-05-08-001 entry described the two cases inaccurately on
inspection:

- **`bukzor-agent-skills` FETCH_HEAD "conflict"**: `<wt>/FETCH_HEAD`
  and `<store>/FETCH_HEAD` are byte-identical (`diff` returns 0). Not
  a real content conflict; just a duplicate the tool's
  `check_no_promote_collisions` would still trip over.
- **`bukzor-agent-skills` `filter-repo/`**: not in the actual workdir
  (workdir is clean of unknowns). The directory sits in the
  worktree-state subdir (`<store>/worktrees/bukzor-agent-skills/`)
  *and* at the store root (`<store>/filter-repo/`); the two differ,
  with the worktree-side being the newer/populated state from a
  `git filter-repo` run on 2026-03-02. The store-side has
  mostly-empty stub files from an earlier run.
- **`claude/amazon-searches` "rebuild from origin"**: not an option —
  the repo has no `origin` remote. Purely local; rename-the-store-
  then-migrate is the only path.
- **`~/claude/empty/`**: still exists (mode 555 read-only, fresh
  `git init` with no commits/refs). The naming overlap with the
  misnamed store `-home-bukzor-claude-empty` is coincidental — that
  empty dir's `.git` is a real directory, not coupled to the store.

## bukzor-agent-skills

Workdir clean of unknowns, 1 commit ahead of `origin/main`, modified
files in flight. Pre-steps (all into
`trash/2026-05-11-migration/agent-skills/`):

1. `cp -a` of the entire store as `store.before/` (2.2 MB).
2. `mv <wt>/FETCH_HEAD` → `removed-pre-steps/` (identical to the store
   copy, drop the duplicate so the promote-collision check passes).
3. `mv <wt>/filter-repo` → `removed-pre-steps/filter-repo.wt`
   (resolves `check_no_unexpected_worktree_files`).
4. `mv <store>/filter-repo` → `removed-pre-steps/filter-repo.store`
   (cleanup; not seen by the tool, but stale scratch).

Then `migrate-from-gitfile` clean — in-place branch (`new_store ==
layout.store`). `audit-gitfiles` dropped to 1.

## claude/amazon-searches

Workdir dirty (`deleted: to-toon` plus untracked search outputs),
2 commits on `main`, no origin remote. The gitfile pointed at the
pre-rename store `-home-bukzor-claude-empty/worktrees/empty/`. Plan:
rename the store to the correct encoded path, rename the worktree
subdir, rewrite the gitfile, then in-place migrate.

Pre-steps (all into `trash/2026-05-11-migration/amazon-searches/`):

1. `cp -a` of the store as `store.before/` (84 KB).
2. `cp -a` of `.git` (the gitfile) as `gitfile.before`.

Surgery:

3. `mv -T <store>/-home-bukzor-claude-empty
       <store>/-home-bukzor-claude-amazon--searches`.
4. `mv -T <new-store>/worktrees/empty
       <new-store>/worktrees/amazon-searches`.
5. Atomic rewrite of `<wd>/.git` to
   `gitdir: <new-store>/worktrees/amazon-searches` via tmp + `mv -Tf`.

The worktree-side `gitdir` file already pointed at
`/home/bukzor/claude/amazon-searches/.git` — no change needed.

`migrate-from-gitfile` ran clean. `index.commit-staged.30107` junk was
discarded by the existing regex. In-place branch (no relocate step).
`audit-gitfiles` is now empty.

## Verification

- `bukzor-agent-skills`: `.git` is symlink, `git status` shows the
  1-ahead-of-origin state with the same modified files; log readable.
- `amazon-searches`: `.git` is symlink, `git status` preserves the
  `deleted: to-toon` change and untracked files; log shows both
  commits (`5b07343`, `a39fb0c`).

## Status

`audit-gitfiles` reports empty. 18/18 legacy-layout repos migrated.

## Loose ends (unchanged from prior sessions)

- Submodule `core.worktree` rewrite still not codified into
  `migrate.py`. None of the 18 needed it. The next submodule-bearing
  legacy repo would hit it.
- Stale-hooks sweep (`git-restore-repo` → `git-localhost-store` path
  in already-migrated stores) still deferred to fire-on-fire.
- Portability of the `/home/bukzor/...` absolute paths in the home
  repo's submodule configs still flagged for future.

## Backups

`trash/2026-05-11-migration/{agent-skills,amazon-searches}/` holds
full pre-migration store snapshots plus the four pre-step removals
from `agent-skills`. Delete when comfortable. The repo-local
`trash/` is gitignored.
