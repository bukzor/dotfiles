local orig_require = require
local M = {}

function M.find(modname) {
  if vim.loader then
    -- neovim
    return vim.loader.find(modname)
  else
    return package.searchpath(modname, package.path)
  end
}

function M.load(modname)

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

function M.unload()
  -- find all bukzor.* modules, call their `unload` functions, then removed them
  -- from the registry of module objects (i.e. `packages.loaded`)
  for name, module in vim.spairs(package.loaded) do
    if vim.startswith(name, "bukzor.") then
      package.loaded[name] = nil
      if type(module) == "table" and vim.is_callable(module.unload) then
        module.unload()
      end
    end
  end
end

function M.reload()
  -- find all bukzor.* modules, call their `unload` functions, then removed them
  -- from the registry of module objects (i.e. `packages.loaded`)
  for name, module in vim.spairs(package.loaded) do
    if vim.startswith(name, "bukzor.") then
      package.loaded[name] = nil
      if type(module) == "table" and vim.is_callable(module.unload) then
        module.unload()
      end
    end
  end
end

return M
