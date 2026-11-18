---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Open Questions: GitHub ssh, Nix
  - ./2026-11-18-001-config-references-missing-on-main.md  # Open Questions 2-4
---

# buck-win10 host fixes after the switch

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **GitHub ssh.** `.ssh/config.d/github.sshconfig` exists only on main. It
   pins `IdentityFile ~/.ssh/sentry-github`, a key from a past employer that
   this host doesn't have. Remove the pin on main so ssh falls back to its
   default keys. Prove it: `ssh -T git@github.com` authenticates with no
   `GIT_SSH_COMMAND`. If the file then does nothing at all, delete it.
2. **Nix.** Port svelte's `.config/sh/env.d/400-nix.sh` to main, unchanged.
   If it doesn't work on this host (the Nix install path differs), say why
   under Open Questions, and land nothing. Prove it: a new login shell has
   `nix` and `direnv` on PATH. Compare against the old `.zshenv` saved in
   `~/trash/switch-to-main/clobbered/`.
3. **`init.templateDir`.** Find out what git-localhost-store is (look for
   it under `~/repo/`, and in `.gitconfig`'s history on both branches). If
   it's the user's own tool with a cheap install, install it here.
   Otherwise, record the facts and your recommendation under Open
   Questions; `.gitconfig` is shared, so don't edit it.
4. **Host installs:** `pnpm add -g prettier`, then show that
   `prettier-markdown` works on a sample.

Commits push main (and svelte, if anything shared changes), then `git -C ~
pull --ff-only`. Until item 1 lands, use unit 001's ssh workaround.

**Scope (only these):** `.ssh/config.d/github.sshconfig` and
`.config/sh/env.d/400-nix.sh` on main; host-local installs; `git pull` in
`~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
