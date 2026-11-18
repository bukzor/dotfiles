---@type LazyPluginSpec
return {
  "nvim-tree/nvim-tree.lua",
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
  end,
  opts = {
    hijack_netrw = true,
    disable_netrw = true,
    hijack_directories = {
      enable = true
    },
    actions = {
      change_dir = {
        enable = false
      }
    }
  }


}
