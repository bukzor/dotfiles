---Import a module, but without any of require's caching behavior. This is best
---  used with data-only modules.
---@param modname string
function just_load(modname)
  local module = vim.loader.find(modname)
  if table.getn(module) < 1 then
    error("module not found: " .. modname)
  elseif table.getn(module) < 1 then
    error(string.format(
      "multiple modules found!? (for module %s): %s",
      modname,
      vim.inspect(module)
    ))
  end
  local modpath = module[1].modpath
  assert(type(modpath) == "string", vim.inspect(module))
  return dofile(modpath)
end


just_load("user.globals")
just_load("user.debug") -- start debugging if DEBUG=nvim


vim.cmd("source $HOME/.vimrc")  -- do the old vim stuff first
local lazy = just_load("user.lazy-spec.lazy")
lazy.system.setup()
