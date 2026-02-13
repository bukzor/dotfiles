lvim.plugins = {
  {
    "folke/lazy.nvim",
    tag = "stable"
  },
  {
    "neovim/nvim-lspconfig",
    commit = "f7922e5",
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
    lazy = true
  },
  {
    "folke/tokyonight.nvim",
    commit = "1ee1101",
    lazy = true
  },
  {
    "lunarvim/lunar.nvim",
    commit = "08bbc93",
    lazy = false
  },
  {
    "Tastyep/structlog.nvim",
    commit = "45b26a2",
    lazy = true
  },
  {
    "nvim-lua/plenary.nvim",
    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
    commit = "267282a",
    lazy = true
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    commit = "776b509",
    config = "<function 4>",
    dependencies = { "telescope-fzf-native.nvim" },
    enabled = true,
    lazy = true
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    commit = "9bc8237",
    enabled = true,
    lazy = true
  },
  {
    "hrsh7th/nvim-cmp",
    commit = "51f1e11",
    config = "<function 5>",
    dependencies = { "cmp-nvim-lsp", "cmp_luasnip", "cmp-buffer", "cmp-path", "cmp-cmdline" },
    event = { "InsertEnter", "CmdlineEnter" }
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    commit = "44b16d1",
    lazy = true
  },
  {
    "saadparwaiz1/cmp_luasnip",
    commit = "1809552",
    lazy = true
  },
  {
    "hrsh7th/cmp-buffer",
    commit = "3022dbc",
    lazy = true
  },
  {
    "hrsh7th/cmp-path",
    commit = "91ff86c",
    lazy = true
  },
  {
    "hrsh7th/cmp-cmdline",
    commit = "8ee981b",
    enabled = false,
    lazy = true
  },
  {
    "L3MON4D3/LuaSnip",
    commit = "c4d6298",
    config = "<function 6>",
    dependencies = { "friendly-snippets" },
    event = "InsertEnter"
  },
  {
    "rafamadriz/friendly-snippets",
    commit = "377d454",
    cond = true,
    lazy = true
  },
  {
    "folke/neodev.nvim",
    commit = "3de41fe",
    lazy = true
  },
  {
    "windwp/nvim-autopairs",
    commit = "ae5b41c",
    config = "<function 7>",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    enabled = true,
    event = "InsertEnter"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSUninstall", "TSUpdate", "TSUpdateSync", "TSInstallInfo", "TSInstallSync",
      "TSInstallFromGrammar" },
    commit = "31f608e",
    config = "<function 8>",
    event = "User FileOpened"
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "9bff161",
    lazy = true
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    commit = "920868d",
    config = "<function 9>",
    enabled = true,
    event = "User DirOpened"
  },
}
