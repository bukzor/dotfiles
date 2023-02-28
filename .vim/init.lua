local join = function(...) return table.concat({...}, "/") end
local xdg = function(arg)
  local path = vim.fn.stdpath(arg)
  return vim.fn.substitute(path, "/nvim$", '', '')
end

local astro_src = join(xdg("data"), "astronvim")
vim.opt.runtimepath:append(astro_src)
astronvim_installation = {home = astro_src}

local astro_init = loadfile(join(astro_src, 'init.lua'))
if astro_init then
  astro_init()
else
  vim.api.nvim_err_writeln("Could not load AstroNvim's init.lua")
end
