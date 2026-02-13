function dap_start()
  osv = require("osv")
  if not osv.is_running() then
    osv.server = osv.start_server("127.0.0.1", 0, true)
    osv.wait_attach()
  else
    print("already running:", vim.inspect(osv.server))
  end
end

if vim.env.DEBUG == "nvim" then
  vim.env.DEBUG = "1"  -- avoid infinite descent!
  vim.opt.rtp:prepend({
    vim.fn.stdpath("data") .. "/lazy/one-small-step-for-vimkind",
    --vim.fn.stdpath("data") .. "/lazy/nvim-dap",
  })
  dap_start()
end
