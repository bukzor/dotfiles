vim.list_extend(
  lvim.plugins,
  {
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      event = "LspAttach",
      opts = {},
    }
  }
)
