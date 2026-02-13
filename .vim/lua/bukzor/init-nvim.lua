print(0)
require("bukzor.unload").unload_all() -- get a clean slate when/if reloading

-- source the basic settings from viml configs, first
local config_home = vim.fn.stdpath("config"):match("(.*)/")
print(1)
vim.cmd("source " .. config_home .. "/vim/init.vim")

if vim.fn.has("nvim-0.8.0") == 1 then
	require("bukzor.plugins").setup()
else
	vim.notify("WARN: lazy.nvim requires Neovim >= 0.8.0; skipping plugins!", vim.log.levels.WARN)
end
