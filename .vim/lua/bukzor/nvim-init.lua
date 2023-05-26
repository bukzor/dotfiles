require("bukzor.unload").unload() -- get a clean slate when/if reloading

-- source the basic settings from viml configs, first
local config_home = vim.fs.dirname(vim.fn.stdpath("config"))
vim.cmd("source " .. config_home .. "/vim/init.vim")

require("bukzor.plugins").setup()
