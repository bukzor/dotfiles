local M = {}

M.treesitter_dir = vim.fn.stdpath("data") .. "/tree-sitters"

-- TODO:
local function todo_jinja2()
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.zimbu = {
    install_info = {
      url = "~/projects/tree-sitter-zimbu", -- local path or git repo
      files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
      -- optional entries:
      branch = "main", -- default branch in case of git repo if different from master
      generate_requires_npm = false, -- if stand-alone parser without npm dependencies
      requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
    },
    filetype = "zu", -- if filetype does not match the parser name
  }
end

function M.setup()
  vim.opt.runtimepath:append(M.treesitter_dir)
  -- nvim-treesitter's TSConfig type lists `modules` as required, but it's an
  -- internal/legacy slot users aren't meant to populate. The plugin's own docs
  -- omit it. Disabling here is the upstream-recommended workaround, not a
  -- general license to silence missing-fields elsewhere.
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = {
      "lua",
      "rust",
      "python",
      "terraform",
      "vim",
      "query", -- tree-sitter query.scm files
      "bash",
      "markdown",
      "markdown_inline",
      "latex",
    },

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
