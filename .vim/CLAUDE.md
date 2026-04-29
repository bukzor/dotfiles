--- # workaround: anthropics/claude-code#13003
depends:
- Skill(llm-subtask)
---

# bukzor's vim/neovim config

## What this is

This directory holds **both** vim and neovim configuration. They share the same
files because `~/.config/nvim` is a symlink to `~/.vim`. Watch out:

- `git -C ~/.vim status` and `git -C ~/.config/nvim status` show the same repo.
- `readlink -f` on any path under `~/.config/nvim/` resolves to `~/.vim/`.
- Tools like `lazy.nvim` notice this and emit duplicate "found packages" warnings; that's expected.

The repo is part of `bukzor/dotfiles` on GitHub (the `~/.vim` subtree).

## Layout

```
init.lua              -> lua/bukzor/init-nvim.lua  (symlink; the nvim entry point)
lua/bukzor/           -- modular Lua config
  init-nvim.lua       -- entry: unload + source vim init.vim + bootstrap plugins
  plugins.lua         -- lazy.nvim spec
  lsp.lua             -- mason / mason-lspconfig / null-ls / inlayhints wiring
  which-key.lua       -- keymap descriptions
  tree-sitter.lua     -- treesitter config
  aerial.lua          -- code outline
  unload.lua          -- supports `:luafile %` reloads (clears state cleanly)

pack/lazy/opt/        -- managed by lazy.nvim (plugin checkouts)
pack/invented-here/start/ -- home-grown vim plugins
pack/github/start/    -- vim plugins NOT managed by lazy
plugged/              -- legacy vim-plug residue (not actively used)

lazy-lock.json        -- lazy.nvim lockfile
```

VimL settings live in `~/.vimrc.d/` (sourced from `~/.config/vim/init.vim`),
not in this repo's `lua/` tree.

## Current Work

Check `.claude/todo.md` and `.claude/todo.kb/` for active efforts.
Load `Skill("llm-subtask")` for maintenance.
