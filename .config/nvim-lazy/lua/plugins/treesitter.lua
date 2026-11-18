return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "lua",
        "rust",
        "python",
        "terraform",
        "vim",
        "query", -- tree-sitter query.scm files
        "bash",
      })
    end,
  },
}
