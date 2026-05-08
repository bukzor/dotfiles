# Active TODOs

See todo.d/ for detailed context on each item.

- [x] Migrate `~/` to symlink layout — submodule path resolution now works
  - [x] All steps complete; `~/.git` is a symlink → `<store>`; `git status` works from `~/` and from the `lazy` submodule
  - [x] Side-effect fix: 7 of 12 submodule gitdirs had relative `core.worktree` whose `../` count assumed logical traversal through `~/.git`. After symlink resolution the paths landed in the wrong place. Rewrote those 7 to absolute paths using `realpath --no-symlinks` from the logical gitdir. (5 remaining stale gitdirs have no on-disk workdir — left untouched.)
- [ ] Improve `migrate-from-gitfile` to handle in-place migration (target store == source store, post-cutover) AND in-place absolute-`core.worktree` rewrite for submodule gitdirs — needed for batch-migrating remaining legacy repos
- [ ] Audit submodule absolute paths for portability — current values hardcode `/home/bukzor/...`. Acceptable for personal dotfiles; problematic if dotfiles ever ship to another user/host.
- [ ] [2026-05-05-000-audit-and-sweep-stale-hooks.md](todo.d/2026-05-05-000-audit-and-sweep-stale-hooks.md) - Audit and rewrite hooks in already-migrated stores that hardcode the old `bin/git-restore-repo` path
- [ ] [2025-11-21-001-guardrails-ambiguous-references.md](todo.d/2025-11-21-001-guardrails-ambiguous-references.md) - Consider adding guardrails for ambiguous reference resolution
