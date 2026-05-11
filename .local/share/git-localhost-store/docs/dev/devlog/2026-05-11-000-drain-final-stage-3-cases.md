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

## Addendum — post-audit cleanup

Ran a wider audit on every `.git` under `~/` and every store under
`<repos>/`. The audit script is at
`trash/2026-05-11-migration/audit-classify.sh`. Findings of note:

- **0 legacy gitfiles** confirmed (Pass 1).
- **932 orphan stores**, of which **922 decode to `/tmp/...`** —
  working as designed (stores survive `/tmp` cleanup). The remaining
  10 are decommissioned vim plugins and test fixtures.
- **955 of 976 stores still reference `git-restore-repo`** in their
  installed hooks (from before the 2026-05-05 rename). Effective live
  exposure is **0**: those hooks short-circuit on
  `[ -L .git ] && exit 0`, and the dead-binary line is only reachable
  when `.git` is *not* a symlink — which requires either a legacy
  gitfile (count: 0) or a fresh `git init`, which installs CLEAN
  hooks from the global template (verified). The deferred sweep TODO
  is pure hygiene; nothing breaks if it's never done.

### Hidden 4th case: `claude-plugins-official`

`audit-gitfiles` only scans for gitfiles *under the workdir*. The
workdir at `~/.claude/plugins/marketplaces/claude-plugins-official/`
had **no `.git` at all** (neither symlink nor file nor directory),
while its store was sitting in canonical legacy-gitfile layout
(`core.bare = true`, top-level HEAD/refs, `worktrees/<name>/`
subdir with HEAD/index/FETCH_HEAD/ORIG_HEAD/logs). `git status` from
the workdir reported "not a git repository" — fully invisible to the
auditor.

Recovery: recreate the missing gitfile (`printf 'gitdir: %s\n' "$WT"
> "$WD/.git"`), then run `migrate-from-gitfile` normally. One pre-step
needed: the store had its own older `logs/HEAD` (204 B from Mar 4)
colliding with the worktree's newer (1485 B from Mar 24) — moved the
older one to trash so the newer one promotes cleanly. Migration
otherwise standard. Branch is 194 commits ahead of `origin/main` with
real uncommitted work — preserved.

Follow-up implication: `audit-gitfiles` could be augmented to also
report stores whose decoded workdir-path exists but has no `.git` —
that would have caught this case directly.

### Minor cleanups

All into `trash/2026-05-11-audit-cleanup/`:

- `~/.cache/uv/sdists-v9/.git` — empty/malformed gitfile in a uv
  internal cache. Removed.
- 28 `.git` gitfile stubs under
  `~/.local/share/{nvim,lazyvim}/mason/packages/lua-language-server/libexec/meta/3rd/*/`
  pointing at non-existent parent gitdirs. Vestigial submodule
  references left by an old clone. Removed.
- Two redundant orphan stores trashed:
  `-home-bukzor-.vim-pack-lazy-opt-ansi.nvim` (workdir has its own
  fresh `.git/` at the same HEAD) and
  `-home-bukzor-tmp-git--staging--problem` (a debugging fixture
  in `~/tmp/`).
