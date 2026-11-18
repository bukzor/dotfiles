local keymaps = require("user.function.keymaps")

local M = {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
}

function M.init()
  local builtin = require('telescope.builtin')

  ---@type KeyMap[]
  M.keymaps = {
    {'n', '<leader>ff', builtin.find_files},
    {'n', '<leader>fg', builtin.live_grep},
    {'n', '<leader>fb', builtin.buffers},
    {'n', '<leader>fh', builtin.help_tags},
  }
  keymaps.set(M.keymaps)
end

function M.deactivate()
  keymaps.del(M.keymaps)
  M.keymaps = {}
end

return M
