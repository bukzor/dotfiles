---A reloadable definition *of* the lazy.nvim plugin, itself.
local M


local system = {
  ---@type LazySpec
  spec = { import = 'user.lazy-spec' },

  ---@type LazyConfig
  opts = {
    install = { colorscheme = {
      'gruvbox',
      'desert',
    } },
    performance = { cache = { enabled = false } },
    ui = { size = { width = 0.5, height = 0.45 }},
  },

  setup=function()
    M.debug.show_count('setup')

    ---- -- avoid deactivation error due to lack of lazy.command["deactivate"]
    ---- --    Failed to deactivate plugin lazy.nvim
    ---- --    .../lazy/lua/lazy/init.lua:119: attempt to call a nil value
    ---- lazy.deactivate = noop
    local lazy = require("lazy")
    lazy.setup(M.system.spec, M.system.opts)
  end,
}

local debug = {
  -- debug bookkeeping:
  count = {
    id = os.clock(),
  },

  show_count = function(key)
    oldval = M.debug.count[key] or 0
    M.debug.count[key] = oldval + 1
    -- print(string.format(
    --   ">>> lazy callback: %s: %s",
    --   key,
    --   vim.inspect(M.debug.count, {newline="", indent=" "})
    -- ))
  end,
}

local reload = {
  callback = function()
    M.debug.show_count('reload')
    ---- local Config = require("lazy.core.config")
    ---- local Loader = require("lazy.core.loader")
    ---- for _, plugin in pairs(Config.plugins) do
    ----   Loader.deactivate(plugin)
    ----   --Loader.reload(plugin)
    ---- end
    ---- --Config.plugins = {}
    ---- 
    ---- Config.setup(M.system.opts)
    Loader.startup()  -- ensure all nonlazy or init'd plugins are loaded
  end,

  hook = function()
    M.debug.show_count('reload.hook')

    M.reload.augroup = vim.api.nvim_create_augroup("user.lazy-spec.lazy", { clear = true })

    -- otherwise lazy won't init or reconfigure when "reloading" plugin specs:
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyReload",
      callback = M.reload.callback,
      group=M.reload.augroup,
    })

    vim.api.nvim_create_autocmd("ColorSchemePre", {
      callback = function(event)
        print("ColorSchemePre(2):", vim.inspect(event, {newline=""}))
      end,
      group=M.reload.augroup,
    })
  end,
}

---@type LazyPlugin
M = {
  'folke/lazy.nvim',
  -- declarative configuration of lazy.nvim: (no side-effects here)

  deactivate=function()
    M.debug.show_count('deactivate')

    ---- -- convince lazy.nvim to allow reloading it
    ---- vim.g.lazy_did_setup = nil
    ---- vim.go.loadplugins = true

    return M
  end,

  system = system,
  debug = debug,
  reload = reload,
}

return M
