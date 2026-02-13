local colorschemes = {
  gruvbox = 'morhetz/gruvbox',
  tokyonight = 'folke/tokyonight.nvim',
}
local colorscheme, other = 'gruvbox', 'tokyonight'
--local colorscheme, other ='tokyonight', 'gruvbox'

function colorscheme_init(plugin)
  vim.cmd.colorscheme(plugin.colorscheme)
end


return {
  {
    colorschemes[colorscheme],
    -- DEBUGME: why fuckup when lazy:true ?
    lazy = true,
    enabled = true,
    priority = 99999,
    init = colorscheme_init,
    colorscheme = colorscheme,
  },
  {
    colorschemes[other],
    enabled=false,
  },
}
