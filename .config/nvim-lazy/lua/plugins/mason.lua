return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "pyright",
        "shellcheck",
        "rust_analyzer",
        "jsonls", -- json
        "jsonnet_ls", -- jsonnet
      },
    },
  },
}
