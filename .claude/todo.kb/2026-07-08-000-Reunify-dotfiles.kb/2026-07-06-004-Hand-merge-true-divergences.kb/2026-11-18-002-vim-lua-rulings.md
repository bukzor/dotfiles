---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "vim": the 2026-11-18 rulings
  - ./2026-11-11-003-vim-lua-and-plugins.md  # Open Questions 1-5
  - ./2026-11-18-000-mason-and-rust-analyzer-history.md  # Open Questions 1-2, Final report
  - ./2026-11-11-004-vimrc-into-vimrc-d.md  # Open Question 4: undotree and surround
---

# Vim lua: apply the rulings, converge the last four conflicts

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 3, "vim")

## Problem Statement

These are the last four main ↔ svelte conflicts. Apply the rulings recorded
in the parent's "vim" item, and land each file byte-identical on both
branches:

- `.vim/lua/bukzor/lsp.lua`: svelte's file plus `PATH = "append",` in
  `setup_mason`, on both branches.
- `.vim/lua/bukzor/plugins.lua`: svelte's file plus undotree (with its
  `<Leader>u` mapping) and vim-surround, both from main's 2023 `.vimrc`, on
  both branches. Check that `<Leader>u` isn't already taken, including in
  which-key.
- `.vim/lazy-lock.json`: svelte's file on main. Lazy adds the two new
  plugins' entries on penguin's next run, so don't add them by hand.
- `.vim/pack/invented-here/start/diffmode/plugin/diffmode.vim`: svelte's
  file on main.

Host step: run `rustup component add rust-analyzer` here, then show that
`~/.cargo/bin/rust-analyzer --version` works.

When you finish, `git merge-tree --allow-unrelated-histories origin/main
origin/svelte-crostini` should report zero conflicts. Report the count.

**Scope (only these files):** the four paths above, in both workspaces;
this handoff file.

## Steps

- [x] author `lsp.lua` (+`PATH = "append"`) and `plugins.lua` (+undotree, surround); check `<Leader>u`
- [x] land all four on svelte, then main; push
- [x] host: `rustup component add rust-analyzer`; `~/.cargo/bin/rust-analyzer --version`
- [x] prove: path diffs empty; `merge-tree` conflict count

## Decisions

- `<Leader>u` was free: no hit in tracked `.vim/`, `.vimrc.d/`, `.config/vim/`, which-key or
  aerial. The mapping lives in undotree's lazy spec as `keys` with a `desc`, so which-key labels it
  from the keymap and `which-key.lua` needs no edit; `cmd = "UndotreeToggle"` keeps the typed
  command working before the key is first pressed.
- vim-surround is a bare spec (eager): it is tiny, and its `ys`/`cs`/`ds` maps must exist at startup.
- `PATH = "append"` carries a two-line comment naming the need (unit 000's finding), so a later
  reader doesn't drop it again as unit 003 once recommended. The brief asked for the line alone.

## Open Questions

## Final report

- Landed: svelte `dc852c3` (`lsp.lua`, `plugins.lua`; the other two already were svelte's), main
  `28b8631` (all four, byte-identical to `dc852c3`). Both pushed.
- `git diff origin/main origin/svelte-crostini` on the four paths: empty. `git merge-tree
  --allow-unrelated-histories origin/main origin/svelte-crostini` (`28b8631` x `dc852c3`):
  **0 conflicts**.
- Checks: both `.lua` files parse under vim 9's `+lua` `loadfile` (a broken file fails it);
  `lazy-lock.json` parses (`jq`, 18 entries); `diffmode.vim` sources under `vim -u NONE`. nvim is not
  on this host: lazy loading, the undotree/surround installs, the which-key label and mason's PATH
  order are unrun. `lazy-lock.json` gains the two new entries on penguin's next nvim run.
- Host: `rustup component add rust-analyzer` done; `~/.cargo/bin/rust-analyzer --version` prints
  `rust-analyzer 1.89.0 (29483883 2025-08-04)`.
- Host gap, outside scope: since the main switchover, live `~/.ssh/config.d/github.sshconfig` sets
  `IdentityFile ~/.ssh/sentry-github`, absent here, so a plain `git fetch` fails (publickey). I ran
  git with `GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'`. Belongs in 006's host-fixes brief.
- Scratch: `~/trash/vim-lua-rulings-002/`.
