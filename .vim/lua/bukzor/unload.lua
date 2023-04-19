local M = {}

function M.unload()
  -- find all bukzor.* modules, call their `unload` functions, then removed them
  -- from the registry of module objects (i.e. `packages.loaded`)
  for name, module in vim.spairs(package.loaded) do
    if vim.startswith(name, "bukzor.") then
      if module.unload ~= M.unload and vim.is_callable(module.unload) then
        module.unload()
      end
      package.loaded[name] = nil
    end
  end
end

return M
