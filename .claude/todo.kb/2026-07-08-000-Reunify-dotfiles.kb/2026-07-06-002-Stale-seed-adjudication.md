---
managed-by: Skill(llm-subtask)
status: open
---

# Stale-seed adjudication

**Priority:** Medium
**Complexity:** Low-Medium
**Branch:** svelte-crostini (2/9 resolved here; 7/9 escalated — see below)
**Context:** classifier "diverged" verdicts where svelte's copy is untouched since import

## Problem Statement

9 "diverged" files have svelte-side content dating to the initial import (2025-10-22)
or the 2023 seed — svelte never touched them, but their blobs match no main ancestor
(the seed likely came from an arch-svelte-lineage working tree with uncommitted
changes). main's 2025-08-20 pass is presumptively ahead, but each needs an eyeball
to confirm the svelte seed holds nothing unique before taking main's side.

**Correction, 2026-07-11:** the "main is presumptively ahead" premise, checked by
actually reading each diff (not just dates/diffstat), held for only 2 of 9. The
other 7 each hide svelte-unique content that a blind take-main would silently
delete — the classifier's last-touch-date heuristic missed content that moved
(vimrc → `.vimrc.d/*.vim`, actively maintained) or diverged for good reason
(crostini-specific settings, a submodule this very session depends on). See
../2026-07-06-004-Hand-merge-true-divergences.md for the escalated 7, each with
findings recorded so 004 doesn't re-derive them.

## Implementation Steps

- [x] unit tests first: `stale-seed-adjudication_check.sh` (repo root) — smoke-tests
      gh/pnpm still start after their files changed. kitty's check deferred to 004
      alongside its file (not yet changed here).
- [x] eyeball diff and adjudicate each (commit on svelte in live `~` if main wins;
      escalate to todo 004 if genuinely mixed):
    - [x] .config/kitty/kitty.conf — **escalated to 004.** Not a stale-seed case at
          all: svelte's is a genuine 3-line minimal config (`linux_display_server
          x11`, crostini-specific); main's 2251-line file is the real default-dump
          *with* live customization (font, gruvbox theme via a main-only submodule,
          ligatures, scrollback, a keybind) mixed in. Taking main's side verbatim
          would drop the x11 setting and depends on a submodule svelte doesn't have.
    - [x] .vimrc — **escalated to 004.** Svelte's 9-line file is a deliberate loader
          for `.vimrc.d/*.vim` (19 files, actively edited as recently as 2026-05-12)
          — not untouched, just refactored. main's 526-line file is monolithic and
          last touched 2025-08-20, predating svelte's most recent modular-config
          work. Needs a real diff of main's content against the 19 files, not a
          take-main.
    - [x] .vim/init.lua — **escalated to 004, but svelte's side already wins.**
          The symlink targets differ by name (svelte: `init-nvim.lua`, main:
          `nvim-init.lua`) *and* content: svelte's was rewritten 2026-05-05 ("nvim
          0.11 modernization"), main's dates to 2023-05-25 and is stale. 004 needs
          to pick the final filename when converging; no take-main here.
    - [x] .config/pnpm/rc — **resolved, took main's side** (`prefix=~/prefix/pnpm`,
          replacing svelte's 3-line `global-dir`/`global-bin-dir`/`store-dir`
          form). Aside: neither form is actually read by pnpm 11 on this host —
          `strace` showed it only opens `~/.config/pnpm/config.yaml` (YAML, not
          this ini-style `rc`), and `pnpm bin -g` resolves to
          `~/.local/share/pnpm/bin`, unrelated to either. Both variants are dead
          config; took main's for brevity per "subtract." Real fix (if still
          wanted) is a new `.claude/ideas.kb` entry, out of scope here.
    - [x] .gitmodules — **escalated to 004.** Genuinely mixed, not stale-seed:
          svelte added a submodule 2026-07-09 (`.claude/sessions.kb` →
          bukzor.claude-sessions, load-bearing for session-start right now) plus
          vim-plugin submodules main lacks; main has different submodules (scratch
          at a different remote, gruvbox-dark-gtk theme, kitty-gruvbox-theme —
          feeds kitty.conf above —, gcloud-data). Needs a union, not a side pick.
    - [x] .config/gh/config.yml — **escalated to 004.** Looked like a clean
          1-alias addition (main adds `"pr co": pr checkout`), but svelte also has
          a `markdown-preview: '!grip "$@"'` alias main lacks (matches the
          untracked `.grip/` sitting in svelte's working tree — actively used).
          Union is trivial (3 aliases, no conflict) but needs a commit on *both*
          branches to land byte-identical, which is out of 002's svelte-only scope.
    - [x] .config/gh/.gitignore — **resolved, took main's side.** Comment-only
          diff ("this "config" has secrets =.=" → "contains auth"), no content
          divergence, no main-side edit needed.
    - [x] .config/gcloud/.gitignore — **escalated to 004.** main's version is a
          real improvement (separates secrets/cache/config more thoroughly, adds
          `application_default_credentials.json`, `*credential*`, `cache/`,
          `logs/`) but drops 5 patterns svelte still has for gcloud's transient
          sentinel/prompt files (`config_sentinel`, `gce`,
          `.last_opt_in_prompt.yaml`, `.last_survey_prompt.yaml`,
          `.metricsUUID`) — a union, not a take-main, and (like config.yml) needs
          a matching main-side commit to converge byte-identical. Also: svelte
          currently tracks `.config/gcloud/configurations/config_default`
          (contents: `account = buck.evan@sentry.io`, not a secret) which main's
          policy says shouldn't be tracked — flagged for 004 to `git rm --cached`
          alongside the merge.
    - [x] .ssh/.gitignore — **escalated to 004.** Security-adjacent, checked
          content of every main-only file it would newly matter for: all are
          public keys (`ssh-rsa`/`ssh-dss` prefixed) or non-secret ssh client
          config — no secret leak risk found. But main's `!*.pub.*` pattern is
          *narrower* than svelte's `!*.pub` and wouldn't auto-track svelte's
          existing plain `*.pub` naming convention (`id_ed25519.pub`,
          `id_ed25519_abby-tablet.pub`) — a silent regression if taken verbatim.
          Also interacts with task 003's main-only `.ssh/` audit (authorized_keys,
          config, config.d/, current/, 7× id_rsa.pub.*) — 004 should coordinate
          with that finding rather than resolve in isolation.

## Success Criteria

- [x] each file either byte-identical across branches or moved to todo 004 with a note

## Notes

Caution: `.gitmodules` and gh/gcloud configs may encode crostini-vs-macos differences
that are *correct* per-machine — if so, the merged version needs guards or a
machine-local mechanism, which is a todo-004-style resolution. (Confirmed true for
`.gitmodules`, `.ssh/.gitignore`, `.config/gcloud/.gitignore` above.)
