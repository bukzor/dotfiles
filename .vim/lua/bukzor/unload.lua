local M = {}

function M.unload_all()
  -- find all bukzor.* modules, call their `unload` functions, then removed them
  -- from the registry of module objects (i.e. `packages.loaded`)
  table.sort(package.loaded)
  for name, module in pairs(package.loaded) do
    if vim.startswith(name, "bukzor.") then
      package.loaded[name] = nil
      if type(module) == "table" and vim.is_callable(module.unload) then
        module.unload()
      end
    end
  end
end

return M
