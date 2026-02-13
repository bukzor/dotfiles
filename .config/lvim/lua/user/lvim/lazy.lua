lvim.builtin.lazy = {
  opts = {
    install = {
      colorscheme = { "gruvbox-material", "tokyonight-night", "desert" },
    },
  },
}

print("LVIM PLUGINS", vim.inspect(lvim.plugins))
lvim.plugins = {
  { import = "user.lazy-specs" },
}
