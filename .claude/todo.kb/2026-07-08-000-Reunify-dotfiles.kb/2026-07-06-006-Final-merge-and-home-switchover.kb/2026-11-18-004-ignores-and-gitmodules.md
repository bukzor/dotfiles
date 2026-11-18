---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # Open Questions: security, untracked noise, proposed entries
  - ../2026-07-06-004-Hand-merge-true-divergences.kb/2026-11-11-005-kitty-themes-submodules.md  # Open Questions: the two private gitlinks
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "git config": the allow-by-default ignore ruling
---

# Ignores for `~` on main; `.gitmodules` entries for the private gitlinks

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **Security first.** Ignore `private-dotfiles/` before anything else.
   This host has keys and credentials there, untracked, in a public repo.
   Push that alone.
2. **Untracked noise.** The switch unit proposed ignore entries for about
   35.6k untracked paths in `~`. Apply them, keeping the scheme the user
   ruled: allow by default, so ignore what is machine state or
   tool-managed, and let real config stay visible as untracked. An entry
   that would hide something that looks like hand-written config goes
   under Open Questions instead. Use the `.gitignore` nearest the noise
   when one exists there.
3. **Private gitlinks.** Add `.gitmodules` entries for main's
   `data/gcloud-private` and `docs/private`, pointing at their private
   remotes (find the URLs from history, or from a local clone's config).
   No `init`.

Every ignore file and `.gitmodules` change lands byte-identical on both
branches. Then `git -C ~ pull --ff-only`, and report `git -C ~ status
--short | wc -l` before and after, plus what is left.

Same ssh workaround as unit 001.

**Scope (only these files):** `.gitignore` files and `.gitmodules`, in
both workspaces; `git pull` in `~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
