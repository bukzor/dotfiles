local M = {}

M.treesitter_dir = vim.fn.stdpath("data") .. "/tree-sitters"

function M.setup()
  vim.opt.runtimepath:append(M.treesitter_dir)
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = {},
    ---  "lua",
    ---  "rust",
    ---  "python",
    ---  "terraform",
    ---  "vim",
    ---  "query", -- tree-sitter query.scm files
    ---  "bash",
    ---},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    -- A directory to install the parsers into.
    -- Remember to run vim.opt.runtimepath:append()!
    parser_install_dir = M.treesitter_dir,

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      disable = function(lang, buf)
        if vim.tbl_contains({ "badlang" }, lang) then
          return true
        end

        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats =
            pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

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
