vim.list_extend(
  lvim.plugins,
  {
  { "jbyuki/one-small-step-for-vimkind" },
  { "mfussenegger/nvim-dap" },
}}


require("dap")
lvim.builtin.dap.on_config_done_callbacks = {}
lvim.builtin.dap.on_config_done = function(dap)
  for _, callback in lvim.builtin.on_config_done_callbacks do
    callback(dap)
  end
end
