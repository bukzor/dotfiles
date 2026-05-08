# Devlog: 2026-05-08 — migrate `~/` to symlink layout

## Focus

Resolve `fatal: not a git repository: …/.git/modules/.config/nvim-dap-lua/…/lazy`
errors that broke `git status` from `~/`. Root cause was the user's home
repo (`~/`) still on the legacy gitfile layout — submodule gitfiles
contain relative paths like `gitdir: ../../../../../../.git/modules/<X>`
which dereference `~/.git` as a directory. Since `~/.git` was a regular
file (gitfile), path traversal `<gitfile>/modules/...` failed.

## What Happened

### Investigation

- `~/.git` was a 90-byte gitfile pointing at
  `<store>/worktrees/bukzor` (legacy worktree-pointer layout).
- `<store>` (`~/.local/state/git-localhost-store/repos/-home-bukzor/`)
  had **two** worktrees, blocking the off-the-shelf
  `migrate-from-gitfile`:
    1. `bukzor` — backed `~/.git`
    2. `dotfiles.main` — backed
       `~/repo/github.com/bukzor/dotfiles.main/.git`
  The migration tool's `check_single_worktree` precondition refuses
  multi-worktree stores. Surveyed all stores: only `~/`'s had >1 entry.
- Decided to remove `dotfiles.main` rather than extend the tool. User
  didn't remember the worktree existed.

### dotfiles.main worktree analysis

Triple-checked safety before removing:

- Working tree clean (`git status -uno` empty).
- HEAD = `refs/heads/main` = `origin/main` = `b0e16c34` — fully synced.
- No worktree-local refs.
- Shared stash on `<common>/refs/stash` — preserved across removal.
- One dangling reflog commit `9f29c15` ("fixup! ADR: pnpm add -g as
  sole authority for global npm tooling"). Verified its blobs are
  byte-identical with those reachable from `refs/remotes/origin/svelte-crostini`
  (published). The dangling fixup is therefore redundant and discardable.

Removed `dotfiles.main` workdir + `<store>/worktrees/dotfiles.main/`.

### Migration steps (manual surgery)

The standard tool would still have failed `check_target_store_does_not_exist`
since `<store>` is already at the encoded target path post-cutover.
Performed the migration's logical equivalent by hand:

1. Tarballed `<store>/` to `~/trash/backup-home-bukzor-20260508-172652.tar.zst`
   (272 MB compressed).
2. Confirmed no in-progress ops (`MERGE_HEAD`, `rebase-merge/`, …).
3. Installed `template-repo/hooks/{pre-commit,post-index-change,reference-transaction}`
   into `<store>/hooks/` (now safe — `dotfiles.main` was the previous
   blocker).
4. `mv -f <store>/worktrees/bukzor/HEAD <store>/HEAD` (identical content,
   effective no-op).
5. `mv -f <store>/worktrees/bukzor/index <store>/index` (new file at root).
6. `rm -r <store>/worktrees/bukzor` and `rmdir <store>/worktrees/`.
7. `sed -i 's/^\tbare = true$/\tbare = false/' <store>/config`. Used
   sed instead of `git config -f` because step 6 had broken the gitfile
   chain (`~/.git` still pointed at the no-longer-existent
   `<store>/worktrees/bukzor`), and `git config` did repo discovery
   that traversed the broken pointer.
8. **Atomic gitfile→symlink swap** (user did this directly while
   reviewing the transient broken state):
   `ln -s <store> ~/.git.new && mv -Tf ~/.git.new ~/.git`.

### Submodule `core.worktree` rewrite

Post-swap, `git status` from `~/` produced a new error:
`fatal: cannot chdir to '../../../../../../../../.config/.../lazy'`.
Cause: each submodule's `<gitdir>/config` had a relative
`core.worktree` whose `../` count assumed logical traversal through
`~/.git` (when it was a gitfile or a real directory). Once `~/.git`
became a symlink, git resolved the gitdir to its physical location
under `<store>/modules/<X>/`, and the same `../` count then climbed out
of `<store>/...` into nonsense paths.

Surveyed 12 submodule gitdirs under `<store>/modules/`. Rewrote
`core.worktree` to absolute paths using
`realpath --no-symlinks <logical-gitdir>/<relative-worktree>`:

- 7 fixed (workdirs exist on disk):
  `.vim/bundle/{gruvbox,vim-sensible}`,
  `.config/nvim-dap-lua/lua/plenary`,
  `.config/nvim-dap-lua/pack/submodule/start/lazy` (the original
  trigger), `home/bukzor/.themes/Gruvbox-GTK`,
  `.themes/Gruvbox-GTK`, `.claude/skills/anthropic-skills`.
- 5 left (workdirs absent — stale gitdirs from removed plugins):
  `.vim/bundle/{asyncomplete-lsp.vim,asyncomplete.vim,vim-lsp}`,
  `.vim/pack/github/start/{ale,vim-lsp-settings}`. Git won't try to
  enumerate these since their workdirs don't exist.

### Verification

- `cd ~ && git status` works — shows the real working state on
  `svelte-crostini`.
- `cd ~/.config/nvim-dap-lua/pack/submodule/start/lazy && git status`
  works — `On branch main`.

## Decisions Made

### Manual surgery, not tool extension

The migration tool would have refused on two preconditions:
multi-worktree (until `dotfiles.main` was removed) and
`target-store-already-exists` (since the store was already at the
target path post-cutover). Extending the tool was tempting but
out-of-scope; this case is a one-off (no other store had multiple
worktrees, and the in-place migration only affects post-cutover
stores). Filed as TODO instead.

### Discard `9f29c15`, don't preserve to a branch

Triple-verified its blobs are byte-identical with
`refs/remotes/origin/svelte-crostini`'s tracked content. The published
branch is the canonical preservation; the dangling reflog commit added
nothing.

### Absolute paths in submodule `core.worktree`, not fixed-relative

Could have computed the correct `../` count for each (relative to the
realpath of the gitdir under `<store>/modules/<X>/`). Chose absolute
because:

- Robust to future store relocations (won't need re-rewriting).
- Doesn't depend on git's resolve-symlinks-or-not behavior.
- The dotfiles already hardcode `/home/bukzor` extensively; this is
  consistent.

Trade-off filed: portability TODO if these dotfiles ever ship to a
different user/host.

## Open Questions / Loose Ends

- **Order-of-operations flaw**: removed `<store>/worktrees/bukzor/` in
  step 6 before the swap in step 8, leaving a transient window where
  `git status` from anywhere under `~/` failed because `~/.git` pointed
  at a path that no longer existed. User raised alarm. The fix is the
  swap itself — no data was at risk — but the plan should have either
  done the swap immediately after step 6 or kept the old worktree subdir
  intact until just before the swap. Note for any future
  `migrate-from-gitfile` improvements: keep the gitfile chain valid at
  all intermediate points if possible.
- **5 stale submodule gitdirs** — leftover from removed plugins. Could
  be removed for tidiness; not blocking.
- **Future submodule additions**: when `git submodule add` is run with
  `~/.git` as a symlink, what does git store in `core.worktree`?
  Untested. May or may not need similar post-add rewrites.
- **Backup**: `~/trash/backup-home-bukzor-20260508-172652.tar.zst` (272 MB)
  retains the pre-migration state. Delete when comfortable.
- **Old gitfile content**: not preserved (user did the swap directly,
  bypassing the cp-to-trash step I had planned). Trivially recreatable
  — `gitdir: <store>/worktrees/bukzor` — and the target path doesn't
  exist anymore so it's only useful as a forensic artifact.

## Next Session

`audit-gitfiles` to assess remaining legacy stores. The migration tool
likely handles those (most should be single-worktree). For ones at the
post-cutover XDG state path, the in-place-migration improvement would
apply.
