---@type LazyPluginSpec[]
return {

  {
    "sainnhe/gruvbox-material",
    init = function()
      vim.schedule(function()
        vim.cmd.colorscheme("gruvy")
      end)
    end,
  },
  {   -- https://github.com/ellisonleao/gruvbox.nvim
    "ellisonleao/gruvbox.nvim",
  },
  {   -- https://github.com/RishabhRD/gruvy
    -- "RishabhRD/gruvy", -- pending https://github.com/RishabhRD/gruvy/pull/2
    "bukzor-sentryio/gruvy",
    branch = 'patch-1',
    dependencies = { "lush.nvim" },
  },
  -- https://github.com/rktjmp/lush.nvim
  { 'rktjmp/lush.nvim' }
}
