---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.kb/2026-11-18-003-vimrc-d-rulings.md  # Open Questions 1-2
  - ./2026-11-18-004-ignores-and-gitmodules.md  # Open Questions 1-4
  - ./2026-11-18-005-buck-win10-host-fixes.md  # Open Question 1
---

# Pre-merge follow-ups from the vimrc.d, ignores and host-fixes units

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments").
Unless an item says "on main" only, land each change byte-identical on
both branches.

1. **Dead vim files, main only:** delete `.vim/autoload/plug.vim` and
   `.vim/autoload/bukzor/mason.vim`. First confirm nothing calls them.
2. **`<C-K>` clash:** `which-key.lua` binds `<C-K>` to signature help, which
   in nvim overrides `multiple-files.vim`'s `<C-K>` (window above). Move
   signature help to a free key, preferring one nvim's defaults or LSP
   conventions already suggest, and check that it is free.
3. **Penguin's public key under main's naming:** svelte tracks
   `.ssh/id_ed25519.pub`, whose comment is `bukzor@chromebook`. Main names
   per-host keys `id_*.pub.<name>`, and this host's plain `id_ed25519.pub`
   is an untracked symlink to its own named key. So:
   - Rename svelte's file to `.ssh/id_ed25519.pub.bukzor.chromebook`.
   - In `.ssh/.gitignore`, ignore the plain `/id_*.pub` names, which are
     per-host links.

   Before the rename, add this step to the parent plan's penguin checklist
   (the coordinator allows this one edit outside your scope): "after
   pulling, `ln -s id_ed25519.pub.bukzor.chromebook ~/.ssh/id_ed25519.pub`".
   Pulling the rename deletes penguin's plain file.
4. **`data/gcloud-private`, main only:** drop the gitlink. Its commit is on
   no remote anyone can find.
5. **pnpm:** port svelte's `.config/pnpm/config.yaml` to main, unchanged.
   Then find out why pnpm is not on main's login PATH here, and fix it in
   whatever svelte file already handles that, if one exists. Prove it:
   `pnpm --version` in a clean `bash -l`.
6. **Junk in `~`:** move `apk.dot*`, `install.sh`, `rustup.sh`,
   `package-lock.json` and `.themes/gruvbox-dark-gtk/` into
   `~/trash/home-junk/`. Leave `willy-practice.txt` and `package.json`
   alone.

Afterwards: push, `git -C ~ pull --ff-only`, `git -C ~ status --short`,
and confirm merge-tree still reports 0 conflicts.

**Scope (only these):** the paths named above in both workspaces; that
one line in the parent plan; moves within `~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
