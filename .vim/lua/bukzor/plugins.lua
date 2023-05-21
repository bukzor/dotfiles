local M = {}

M.treesitter_dir = vim.fn.stdpath("config") .. "/tree-sitters"

function M.setup()
  require("bukzor.unload").unload_all()
  require("bukzor.lsp").setup()
  require("bukzor.tree-sitter").setup()
end

return M
