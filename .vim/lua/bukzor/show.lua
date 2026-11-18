local M = {}

function M.show(t)
  local x={}
  for key, val in pairs(t) do
    table.insert(x, key)
  end
  table.sort(x)
  for _, key in pairs(x) do
    print(key, ":", type(t[key]))
  end
  print('---')
end

print("_G", "===========================")
M.show(_G)

return M
