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

  require("lazy").setup({
    root = M.LAZY_HOME,
    dev = {
      path = vim.fs.normalize(
        vim.fn.stdpath("config") .. "/pack/invented-here/start"
      ),
    },
    install = {
      colorscheme = { "gruvbox", "habamax", "slate" },
      missing = true, -- automatically install what's missing
    },
    checker = {
      enabled = true,
      frequency = 7 * 24 * hour, -- once a week
    },
    performance = {
      reset_packpath = false, -- cooperate with vim-plug and local packs
      rtp = {
        reset = false, -- cooperate with vim-plug and local packs
      },
    },

    spec = {
      -- the plugin framework
      "folke/lazy.nvim",

      -- helpfully show keystrokes
      "folke/which-key.nvim",

      -- advanced LSP for nvim lua:
      "folke/neoconf.nvim",
      "folke/neodev.nvim",
      {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
          -- https://github.com/folke/neoconf.nvim#-setup
          "folke/neoconf.nvim",
          -- https://github.com/bukzor-sentryio/mason-lspconfig.nvim#setup
          "williamboman/mason-lspconfig.nvim",
        },
        config = lsp.setup_lspconfig,
      },

      {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
          "williamboman/mason.nvim",
          "nvim-lua/plenary.nvim",
          "jose-elias-alvarez/null-ls.nvim",
        },
        config = lsp.setup_mason_null_ls,
      },

      -- LSP code outline
      {
        "stevearc/aerial.nvim",
        config = require("bukzor.aerial").setup,
      },

      -- show LSPs' hints inline
      "lvimuser/lsp-inlayhints.nvim",
    },
  })
end

return M
