local M = {}

M.treesitter_dir = vim.fn.stdpath("config") .. "/tree-sitters"

function M.setup()
  require("bukzor.lsp").setup()
  vim.opt.runtimepath:append(M.treesitter_dir)
  require("nvim-treesitter.configs").setup({
    -- A directory to install the parsers into.
    -- If this is excluded or nil parsers are installed
    -- to either the package dir, or the "site" dir.
    -- If a custom path is used (not nil) it must be added to the runtimepath.
    parser_install_dir = M.treesitter_dir,

    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "rust", "python", "terraform" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  })
  require("nvim-treesitter").setup()
end

return M
