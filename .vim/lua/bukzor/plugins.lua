# TODO: https://claude.ai/chat/ad3f7522-2780-4e67-ac6b-f4217de8c4df
local M = {}

M.LAZY_HOME = vim.fs.normalize(vim.fn.stdpath("config") .. "/pack/lazy/start")

function M.setup()
  M.bootstrap()
  M.config()
end

function M.bootstrap()
  -- https://github.com/folke/lazy.nvim#-installation
  local lazypath = M.LAZY_HOME .. "/lazy.nvim"
  if not vim.loop.fs_stat(lazypath .. "/.git/") then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local hour = 60 * 60

function M.config()
  local lsp = require("bukzor.lsp")
  lsp.unload()
  lsp.init()

  ---@type LazyConfig
  local lazy_config = {
    root = M.LAZY_HOME,
    dev = {
      path = vim.fs.normalize(
        vim.fn.stdpath("config") .. "/pack/invented-here/start"
      ),
    },
    install = {
      colorscheme = {
        "ellisonleao/gruvbox.nvim",
        "gruvbox",
        "habamax",
        "slate",
      },
      missing = true, -- automatically install what's missing
    },
    checker = {
      enabled = true,
      frequency = 7 * 24 * hour, -- once a week
    },
    performance = {
      reset_packpath = false, -- cooperate with vim-plug and local packs
      rtp = {
        reset = false,        -- cooperate with vim-plug and local packs
      },
    },
  }

  ---@type LazySpec
  local lazy_spec = {
    -- the plugin framework
    {
      "folke/lazy.nvim",
      opts = {},
    },

    -- helpfully show keystrokes
    {
      "folke/which-key.nvim",
      opts = {},
    },

    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },

    -- syntax highlighting (using treesitter)
    {
      "nvim-treesitter/nvim-treesitter",
      config = require("bukzor.tree-sitter").setup,
      build = ":TSUpdate",
    },

    -- https://github.com/williamboman/mason-lspconfig.nvim#vim-plug
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate", -- :MasonUpdate updates registry contents
      config = lsp.setup_mason,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        -- https://github.com/bukzor-sentryio/mason-lspconfig.nvim#setup
        --"neovim/nvim-lspconfig",
        -- https://github.com/folke/neoconf.nvim#-setup
        "folke/neoconf.nvim",
      },
      config = lsp.setup_mason_lspconfig,
    },

    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        -- https://github.com/bukzor-sentryio/mason-lspconfig.nvim#setup
        "williamboman/mason-lspconfig.nvim",
      },
      config = lsp.setup_lspconfig,
    },
    { -- https://github.com/folke/neoconf.nvim#-setup
      "folke/neoconf.nvim",
      cmd = "Neoconf",
      opts = {},
    },

    -- advanced neovim-lua lsp autoconfiguration
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- https://github.com/folke/lazydev.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {                                        -- optional completion source for require statements and module annotations
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },

    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "nvim-lua/plenary.nvim",
        "nvimtools/none-ls.nvim",
      },
      config = lsp.setup_mason_null_ls,
    },

    -- LSP code outline
    {
      "stevearc/aerial.nvim",
      config = require("bukzor.aerial").setup,
    },

    -- show LSPs' hints inline
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {},
    },

    --- avante: AI support
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this if you want to always pull the latest change
      opts = {
        -- add any opts here
      },

      config = function(self, opts)
        --print(vim.inspect(self))
        require("avante_lib").load()
        require("avante").setup(opts)
      end,

      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",

      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        --"zbirenbaum/copilot.lua", -- for providers='copilot'
        --"HakonHarnes/img-clip.nvim", -- support for image pasting
      },
    },
    --- avante optional deps
    -- { -- for providers='copilot'
    --   "zbirenbaum/copilot.lua",
    --   opts = {},
    -- },
    -- { -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
  }

  require("lazy").setup(lazy_spec, lazy_config)
end

return M
