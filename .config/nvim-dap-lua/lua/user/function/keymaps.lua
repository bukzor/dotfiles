local M = {}

---@alias KeyMap {
---   [1]: string | string[],  # mode
---   [2]: string,  # lhs
---   [3]: string | fun()  # rhs
---   [4]: table<string, string>?  # opts
--- }

---@param keymaps KeyMap[]
function M.set(keymaps)
  for _, keymap in pairs(keymaps) do
    vim.keymap.set(unpack(keymap))
  end
end

---@param keymaps KeyMap[]
function M.del(keymaps)
  for _, keymap in pairs(keymaps) do
    modes, lhs, rhs, opts = unpack(keymap)
    vim.keymap.del(modes, lhs, opts)
  end
end


return M
