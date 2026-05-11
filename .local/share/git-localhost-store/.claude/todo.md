# Active TODOs

See todo.d/ for detailed context on each item.

- [x] Migrate `~/` to symlink layout — submodule path resolution now works
  - [x] All steps complete; `~/.git` is a symlink → `<store>`; `git status` works from `~/` and from the `lazy` submodule
  - [x] Side-effect fix: 7 of 12 submodule gitdirs had relative `core.worktree` whose `../` count assumed logical traversal through `~/.git`. After symlink resolution the paths landed in the wrong place. Rewrote those 7 to absolute paths using `realpath --no-symlinks` from the logical gitdir. (5 remaining stale gitdirs have no on-disk workdir — left untouched.)
- [x] Improve `migrate-from-gitfile` to handle in-place migration (target store == source store, post-cutover) — done in devlog 2026-05-08-001. 16 of 18 backlog candidates migrated.
- [x] Stage-3 hard cases (devlog 2026-05-11-000): all three migrated (incl. `claude-plugins-official`, recovered post-audit). `audit-gitfiles` empty.
- [x] Final audit + cleanup (devlog 2026-05-11-000 addendum): mason/uv bogus gitfile stubs removed, 2 redundant orphan stores trashed.
- [ ] Fold submodule `core.worktree` absolute-path rewriting into the migration tool. Manual logic from devlog 2026-05-08-000 not yet codified; none of the migrated candidates needed it but the next submodule-bearing legacy repo will.
- [ ] Audit submodule absolute paths for portability — current values hardcode `/home/bukzor/...`. Acceptable for personal dotfiles; problematic if dotfiles ever ship to another user/host.
- [ ] [2026-05-05-000-audit-and-sweep-stale-hooks.md](todo.d/2026-05-05-000-audit-and-sweep-stale-hooks.md) - Audit and rewrite hooks in already-migrated stores that hardcode the old `bin/git-restore-repo` path. Audit on 2026-05-11 found 955 affected stores but effective live exposure is 0 (hooks short-circuit on `.git`-is-symlink; the dead-binary line is unreachable in current state). Pure hygiene.
- [ ] [2025-11-21-001-guardrails-ambiguous-references.md](todo.d/2025-11-21-001-guardrails-ambiguous-references.md) - Consider adding guardrails for ambiguous reference resolution
