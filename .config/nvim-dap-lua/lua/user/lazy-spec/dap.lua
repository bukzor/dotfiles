--  1. debugger: edit the source code, set breakpoints
--  2. debug-ee: run `:lua require'osv'.launch()`; it prints a port number
--  3. debugger: launch the debugging session; give the port number at prompt
--  4. debug-ee: run the debugged code; it will pause at breakpoint; control it
--    from debugger

-- You will also need a comptabile DAP client
local dap_lazyspec = {
  "mfussenegger/nvim-dap",
  ---@type KeyMaps[]
  keymaps = {},
}
local osv_lazyspec = {
    "jbyuki/one-small-step-for-vimkind",
    config = function()
      dap = require('dap') -- global
      osv = require('osv') -- global

      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "SignColumn" })
      dap.set_log_level('TRACE')
      dap.adapters.nlua = function(callback, config)
        print("DAP CONFIG:", vim.inspect(config))
        local adapter = {
          type = "server",
          host = config.host,
          port = config.port,
        }
        if config.start_neovim then
          local dap_run = dap.run
          dap.run = function(c)
            adapter.port = c.port
            adapter.host = c.host
          end
          osv.run_this()
          dap.run = dap_run
        end
        callback(adapter)
      end
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Run this file",
          start_neovim = {},
        },
        { -- https://github.com/jbyuki/one-small-step-for-vimkind/tree/main#configuration
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = '127.0.0.1',
          port = function()
            local val = tonumber(vim.fn.input('Port: '))
            return val
          end,
        },
      }
    end,
  }

dap_lazyspec.dependencies = {
  { "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  -- virtual text for the debugger
  { "theHamsta/nvim-dap-virtual-text", opts = {}},
  -- which key integration
  { "folke/which-key.nvim",
    optional = true,
    opts = { defaults = { ["<leader>d"] = { name = "+debug" } } },
  },
  -- mason.nvim integration
  { "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "telescope.nvim",
    },
  },
  osv_lazyspec,
}


local keymaps = require("user.function.keymaps")



function dap_lazyspec.init()
  dap = require('dap') -- global
  dap_widgets = require('dap.ui.widgets') -- global
  telescope = require('telescope') -- global
  osv = require('osv') -- global

  ---@type KeyMap[]
  dap_lazyspec.keymaps = {
    -- https://github.com/jbyuki/one-small-step-for-vimkind/tree/main#configuration
    {'n', '<leader>db', dap.toggle_breakpoint, { desc="Breakpoint" }},
    {'n', '<leader>dc', dap.continue, { desc="Continue" }},
    {'n', '<leader>dn', dap.step_over, {desc="Next"}},
    {'n', '<leader>ds', dap.step_into, {desc="Step"}},
    {'n', '<leader>dr', dap.step_out, {desc="Return"}}, -- "return"
    {'n', '<Leader>dR', dap.repl.open, {desc="REPL"}},
    {'n', '<leader>dK', dap_widgets.hover, {desc='Hover'}},
    {'n', '<leader>dL', "<Cmd>lua osv.server = osv.launch{log=true}<CR>", {desc='Launch'}},
    {'n', '<leader>dd', dap_start, {desc='DAP start'}},

    -- https://github.com/mfussenegger/nvim-dap/blob/897c433/doc/dap.txt#L501
    {'n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end},
    {"n", "<leader>dg", dap.run_last, {desc='run last'}},
    {{'n', 'v'}, '<Leader>dh', dap_widgets.hover, {desc='widget: hover'}},
    {{'n', 'v'}, '<Leader>dp', dap_widgets.preview, {desc='widget: preview'}},
    {'n', '<Leader>dF', function() dap_widgets.centered_float(dap_widgets.frames) end, {desc='widget: frames'}},
    {'n', '<Leader>dS', function() dap_widgets.centered_float(dap_widgets.scopes) end, {desc='widget: scopes'}},
    {'n', '<Leader>dE', function() dap_widgets.centered_float(dap_widgets.sessions) end, {desc='widget: sessions'}},


    -- https://dotfyle.com/plugins/jbyuki/one-small-step-for-vimkind
    -- https://github.com/yutkat/dotfiles/blob/main/.config/nvim/lua/rc/pluginconfig/nvim-dap.lua
    {"n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, {desc='Breakpoint*'}},
    -- telescope
    {"n", "<leader>dH", "<Cmd>lua telescope.extensions.dap.commands{}<CR>"},
    {"n", "<leader>dC", "<Cmd>lua telescope.extensions.dap.configurations{}<CR>"},
    {"n", "<leader>dP", "<Cmd>lua telescope.extensions.dap.list_breakpoints{}<CR>"},
    {"n", "<leader>dV", "<Cmd>lua telescope.extensions.dap.variables{}<CR>"},
    {"n", "<leader>dq", "<Cmd>lua dap.disconnect{}<CR>"},
  }
  keymaps.set(dap_lazyspec.keymaps)
end

function dap_lazyspec.deactivate()
  keymaps.del(dap_lazyspec.keymaps)
  dap_lazyspec.keymaps = {}
end

function fordebug()
  print("OHAI")
end


return dap_lazyspec
