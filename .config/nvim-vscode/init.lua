-- nvim-vscode: neovim config for use inside VSCode via vscode-neovim
-- Uses a separate, minimal ~/.vimrc.d.vscode/ instead of the full ~/.vimrc.d/
-- to avoid interactions between vim-native config and VSCode.

for _, f in ipairs(vim.fn.glob(vim.fn.expand("~/.vimrc.d.vscode/*.vim"), false, true)) do
  vim.cmd("source " .. f)
end
