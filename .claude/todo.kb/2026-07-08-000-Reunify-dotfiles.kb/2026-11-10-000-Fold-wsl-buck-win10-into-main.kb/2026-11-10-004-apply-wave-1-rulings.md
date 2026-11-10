---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # the user's ruling, under "commit or park"
  # wave-1 Open Questions; each item below cites one by unit:number
  - ./2026-11-10-000-wsl-shell-settings.md
  - ./2026-11-10-001-misc-config-review.md
  - ./2026-11-10-002-untracked-triage.md
  - ./2026-11-10-003-claude-dir-uncommitted.md
---

# Apply the user's rulings on wave 1's Open Questions

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 2, "commit or park")

## Problem Statement

Wave 1's units left Open Questions; the user has ruled (the parent's
`[!@bukzor]` block). Apply each ruling, so `~` ends with no uncommitted or
unparked state. "To trash" means `mv` into `~/trash/fold-004/`, never `rm`.

- 000:1–3 (`PNPM_HOME`, npm-global `PATH`, `RBENV_ROOT`, `run-time.sh`):
  dropped. Nothing to do: they live only in retired files that main deletes
  at the merge. Confirm svelte gained none of them.
- 000:4, 001 `.zkbd/xterm-256color-:0`: to trash.
- 000:5: `bin/command-not-found-hook` must not depend on `has`/`~/.sh_lib`;
  test `[ -x /usr/libexec/command-not-found ]` (and the brew fallback's own
  binary) directly. Commit on wsl, and add the hook to svelte (svelte's
  `rc.d/command-not-found.sh` from `f74b93f` already expects it). Smoke-test
  the not-found path once in a throwaway shell: unit 000 hit an infinite
  fork when the hook was missing.
- 001 `.zkbd/xterm-256color-alpine-linux-musl`: replace with a relative
  symlink to `xterm-256color-alpine-linux`; commit on wsl.
- 001 empty submodule checkouts (`.config/kitty/kitty-gruvbox-theme`,
  `.themes/gruvbox-dark-gtk`): `git -C <sub> reset --hard` in each, after
  confirming the inner HEAD equals the superproject's recorded gitlink.
- 001 gh: blank `browser:` in `.config/gh/config.yml` on wsl; svelte's
  `git_protocol` becomes `ssh` (user ruling).
- 001 delta: revert wsl `a60d2a6` (`git revert`), so the live `.gitconfig`
  loses it too.
- 002 `docs/games/deadlock/`: move the two `.txt` files to
  `~/claude/deadlock/docs/games/` (create the dir); trash the `.swp`. Do not
  commit in that repo: a peer session may be working there. List the move
  in your Final report so it can be passed on.
- 002 `project/family-bug-tracker/`: to trash (user ruling); then `rmdir
  project` if empty.
- 002 `router-debug/`: move to `~/claude/router-debug/` (already ignored
  there via `/claude/`).
- 003 `settings.json`: `Bash(sudo:*)` goes into `permissions.ask` on svelte
  (out of `deny`) and into `~/.claude/settings.json`'s `ask` on wsl. Touch
  no other key: the reconcile step takes svelte's file later.

Settle and report: anything here that turned out not to be as described.

**Scope (only these files):**
- in `~`: `setup/wsl.help`, `.zkbd/`, `bin/command-not-found-hook`,
  `.config/kitty/kitty-gruvbox-theme`, `.themes/gruvbox-dark-gtk`,
  `.config/gh/config.yml`, `.gitconfig`, `docs/games/`, `project/`,
  `router-debug/`, `.claude/settings.json`
- in the svelte workspace: `bin/command-not-found-hook`,
  `.config/gh/config.yml`, `.claude/settings.json`
- write-only, uncommitted: `~/claude/deadlock/docs/games/`, `~/claude/router-debug/`
- this handoff file
