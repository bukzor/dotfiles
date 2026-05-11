# Speculative Ideas

Possible future improvements whose trigger conditions may never fire.
Each has a documented recipe so it's quick to execute *if* needed.
Don't pre-do them.

Analogue of `~/.claude/ideas.kb/` but kept as a flat file — these are
small and few.

## Ideas

- **Fold submodule `core.worktree` rewrite into `migrate.py`.**
  Trigger: a future submodule-bearing legacy gitfile repo runs
  through `migrate-from-gitfile` and post-migration `git status`
  fails with `cannot chdir to '../../../...'`. Recipe: devlog
  `2026-05-08-000`. Rationale to defer: 0 of the 18 migrated
  candidates needed it; codify after the *next* occurrence, when
  recurrence justifies generalization.

- **Extend `bin/audit-gitfiles` to find no-`.git` workdirs.**
  Trigger: another workdir loses its `.git` while the store remains
  (the `claude-plugins-official` shape from 2026-05-11). Recipe:
  walk `<repos>/`, decode each name, flag those whose decoded
  workdir-path exists but lacks a `.git`. Reference script at
  `trash/2026-05-11-migration/audit-classify.sh` (gitignored;
  rescue from there if needed).

- **Re-run absolute-path rewrite on home-dir migration.**
  Trigger: moving home directory, changing username, or shipping
  these dotfiles to a different user/host (symptom: every home
  submodule fails with `cannot chdir`). Recipe: devlog
  `2026-05-08-000` — same `realpath --no-symlinks` loop with the
  new prefix. Scriptable on demand.
