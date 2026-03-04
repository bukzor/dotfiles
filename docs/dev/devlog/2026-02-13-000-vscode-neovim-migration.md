# Devlog: 2026-02-13 — VSCode + neovim migration

## Focus

Escape 19 years of accumulated vim/neovim configuration by migrating to VSCode
with vscode-neovim (headless neovim integration). Plan a sustainable path out
of the current hodgepodge of bespoke vim config, lazy.nvim, Mason, lspconfig,
LunarVim, LazyVim, and nvim-dap-lua configurations.

## Current State (what existed before this session)

Six overlapping editor configurations on the svelte-crostini branch:

| Layer | Location | Manager | Status |
|-------|----------|---------|--------|
| Legacy Vim | `.vimrc` + 19 `.vimrc.d/*.vim` | Vim 8 packages | Active, sourced by everything |
| Neovim primary | `.vim/lua/bukzor/` | lazy.nvim | Active, built on top of legacy |
| LazyVim | `.config/lazyvim/` | LazyVim distro | Half-configured starter |
| LunarVim | `.config/lvim/` | LunarVim distro | Minimal, mostly defaults |
| nvim-dap-lua | `.config/nvim-dap-lua/` | lazy.nvim | Debug-focused experiment |
| nvim-lazy | `.config/nvim-lazy/` | LazyVim distro | Another LazyVim variant |

Plus Mason-installed tools across `~/.local/share/{nvim,nvim-lazy,lazyvim,lvim}/mason/`,
git submodules for vim plugins, custom plugins in `pack/invented-here/`, and
ALE linting config predating the LSP setup.

The dotfiles repo has roots going back to 2006, with multiple root commits from
merged repos across machines (MacPro 2011, Yelp 2011, WSL Alpine 2023, etc.).

## What we did

### Phase 1: Install VSCode + vscode-neovim (completed)

- Created `setup/vscode.sh` — idempotent install script for Debian/Crostini
  - Adds Microsoft apt repo (deb822 format matching what VS Code auto-manages)
  - Installs `code` package and `asvetliakov.vscode-neovim` extension
  - Resolved a conflict between our `.list` file and VS Code's auto-generated
    `.sources` file — both pointed to the same repo with different `Signed-By`
    paths. Fix: use the same path (`/usr/share/keyrings/microsoft.gpg`) and
    format (deb822) that VS Code expects.

- Created `bin/nvim-vscode` symlink → `nvim.renamed` (sets `NVIM_APPNAME` from
  filename, same pattern as `nvim-lazy` and `nvim-dap-lua`)

- Configured vscode-neovim extension to use our wrapper:
  `"vscode-neovim.neovimExecutablePaths.linux": "/home/bukzor/bin/nvim-vscode"`

### Phase 2: Config strategy (completed, with course correction)

**First attempt:** Share `~/.vimrc.d/` between regular vim and vscode-neovim,
with `if exists('g:vscode') | finish | endif` guards in files where VSCode owns
the functionality (linting, LSP, clipboard, popup menus).

**Problem:** Existing vimrc.d files interacted badly with vscode-neovim.
- `put =expand(...)` with `<Cmd>` caused infinite paste loops
- Command-line flash from `:` mappings caused flaky repeated input
- The accumulated config surface was too large to safely audit

**Course correction:** Created `~/.vimrc.d.vscode/` as a separate, empty
directory. The `~/.config/nvim-vscode/init.lua` sources only from there.
New config is opt-in — add files as needed, rather than trying to share and
exclude.

### Side improvements to regular vim

- Renamed `plugins.vim` → `0010-plugins.vim` and `basics.vim` → `0020-basics.vim`
  to fix load ordering (gruvbox colorscheme was set before packloadall ran)
- Converted several mappings from `:cmd<CR>` to `<Cmd>cmd<CR>` to eliminate
  command-line flash (multiple-files.vim, finger-savers.vim, diffmode.vim)
- Added `filereadable()` guard to zlib plugin's `detect_zlib()` to handle
  vscode-neovim pseudo-buffers

## Decisions

### Separate vimrc.d.vscode/ instead of shared vimrc.d/ with guards

**Rationale:** The shared approach failed in practice. Vim-native config has
too many assumptions about the environment (menus exist, OSC52 works, ALE is
loaded, pack plugins are available) that interact unpredictably with
vscode-neovim's headless context. An empty slate with opt-in additions is safer
and faster to iterate on.

**Alternatives considered:**
- Shared vimrc.d/ with per-file guards — tried, too many subtle interactions
- No neovim config at all (pure VSCode) — loses vim motions, which is the
  whole point

### Keep terminal neovim for git vimdiff

**Rationale:** vscode-neovim does NOT support neovim's native diff mode.
`:diffthis`, `]c`/`[c` hunk navigation, `:diffget`/`:diffput` are all
non-functional because the headless neovim never renders split windows.
VSCode's built-in diff editor (`code --diff`) is a different UX. The existing
vimdiff setup (`.gitconfig.d/vimdiff.conf` + `diffmode.vim`) is ~90 lines,
has zero LSP/Mason dependencies, and works perfectly.

**Alternatives considered:**
- VSCode `code --diff` as git difftool — works but loses `:diffget`/`:diffput`,
  patience algorithm, whitespace toggle, and terminal-over-SSH capability

## Phases not yet completed

### Phase 2 (remaining): Port essentials to vimrc.d.vscode/

Audit `~/.vimrc.d/` for things that matter to editing motions (not
LSP/linting/completion) and port them one at a time:
- Keymaps: finger-savers, search, scrolling, typo corrections
- Options: scrolloff, hidden, autoread, timeouts
- Test each addition in isolation before adding the next

### Phase 3: Clean up the old world

- Archive experimental configs: `git rm` or move
  `.config/{lazyvim,lvim,nvim-dap-lua,nvim-lazy}` to a trash/archive branch
- Clean up Mason data dirs in `~/.local/share/`
- Strip `~/.vim/` and `~/.vimrc.d/` down to a minimal terminal-only config
  (basics + diffmode + gruvbox, no Mason/LSP/treesitter)
- Remove vim plugin git submodules that are no longer needed

### Phase 4: VSCode extensions for what neovim used to do

Replace Mason/lspconfig/null-ls with VSCode extensions:
- Python: Pylance (pyright under the hood)
- Rust: rust-analyzer extension
- Terraform: HashiCorp Terraform extension
- Formatting: Prettier, Black, or built-in format-on-save

## Conventions Established

- `~/.vimrc.d.vscode/*.vim` — vscode-specific vim config, opt-in only
- `~/.config/nvim-vscode/init.lua` — sources vimrc.d.vscode/, nothing else
- `bin/nvim-vscode` → `nvim.renamed` — same APPNAME-from-filename pattern
- `setup/vscode.sh` — idempotent installer, teal PS4 prompt, set -x by default
- Numeric prefix on vimrc.d files (`0010-`, `0020-`) to control load order

## Open Questions

- How well does vscode-neovim handle macros and complex dot-repeat?
- Will the `if exists('g:vscode')` guards in linting/lsp/copy-paste/default-mappings
  cause issues for regular vim? (Should be harmless but untested — remove if not)
- Is `code-server` (brew) worth having as a fallback for remote/headless use?

## References

- [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) — headless neovim in VSCode
- [Diff editor switch sides - Issue #1373](https://github.com/vscode-neovim/vscode-neovim/issues/1373)
- [Diff navigation regression - Issue #1027](https://github.com/vscode-neovim/vscode-neovim/issues/1027)
