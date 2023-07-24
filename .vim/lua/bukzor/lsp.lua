local M = {}

-- see ~/.local/state/nvim/mason.log
local mason_log_level = vim.log.levels.DEBUG;

-- mason is in charge of installing various tools
M.mason_install = {
  -- lspconfig configures many language servers
  -- full list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  lspconfig = {
    "rust_analyzer", -- rust
    "lua_ls",        -- lua
    "pyright",       -- python
    -- FIXME: none of these are valid
    --- "jq", -- jq
    --- "jqls", -- jq
    --- "jqlsp", -- jq
    --- "jq-ls", -- jq
    --- "jq-lsp", -- jq
    --- "jq_ls", -- jq
    --- "jq_lsp", -- jq
    "jsonls",      -- json
    "jsonnet_ls",  -- jsonnet
    "tflint",      -- terraform
    "terraformls", -- terraform-ls: terraform
    "tsserver",    -- typescript
    "vimls",       --vim
    "clangd",      -- c/c++
    "gopls",       -- golang
  },
  -- null-ls adapts CLI tools to the LSP protocol
  -- full list: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  ["null-ls"] = {
    -- python
    "black",
    "isort",
    -- most web-related files: js ts css html json jsonc markdown yaml
    "prettierd",
    -- shell
    "shellcheck",    -- .sh
    "fish",          -- .fish
    "zsh",           -- .zsh
    "dotenv_linter", -- .env
    "gitlint",       -- git commit messages
    --"commitlint",  -- needs configuration
    "glslc",         -- GLSL
    "tfsec",         -- terraform
    "gofmt",         -- golang
  },
}

M.au_format = "BukzorLspFormat"
M.au_loclist = "BukzorLspLocList"
M.lsp_attached = nil
M.lsp_formatting = nil
M.ensure_installed_by = nil

function M.log(...)
  require("mason-core.log").fmt_debug(...)
end

function M.init()
  vim.api.nvim_create_augroup(M.au_format, { clear = true })
  vim.api.nvim_create_augroup(M.au_loclist, { clear = true })
  vim.api.nvim_create_augroup("END", { clear = true })
  M.lsp_attached = {}
  M.lsp_formatting = {}
end

function M.setup()
  M.unload()
  M.init()

  M.setup_mason()
  M.setup_lspconfig()
  M.setup_mason_lspconfig()
  M.setup_mason_null_ls()
end

function M.unload()
  local err
  _, err = pcall(vim.api.nvim_del_augroup_by_name, M.au_format)
  if err ~= nil and not vim.startswith(err, "Vim:E367: No such group: ") then
    error(err)
  end

  _, err = pcall(vim.api.nvim_del_augroup_by_name, M.au_loclist)
  if err ~= nil and not vim.startswith(err, "Vim:E367: No such group: ") then
    error(err)
  end
  local _, _, null_ls_config = pcall(require, "null-ls.config")
  if null_ls_config ~= nil then
    null_ls_config.reset() -- otherwise it refuses to be configured
    require("lsp-inlayhints").reset()
  end
  M.lsp_attached = {}
  M.lsp_formatting = {}
end

function M.setup_mason()
  require("mason").setup({
    log_level = mason_log_level,
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

function M.show_loclist()
  vim.diagnostic.setloclist({ open = false })
  vim.cmd("bo lw 5")
end

function M.setup_lspconfig()
  vim.cmd(":runtime plugin/lspconfig.lua") -- surely there's a better way?
end

function M.on_attach_lspconfig(client, bufnr)
  require("lsp-inlayhints").on_attach(client, bufnr)
  M.on_attach_autoformat(client, bufnr)

  -- prevent jittery rendering by just always showing the sign column
  vim.opt_local.signcolumn = "yes:1"

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
  vim.bo[bufnr].formatexpr = ""
end

function M.setup_mason_lspconfig()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = M.mason_install["lspconfig"],
  })
  mason_lspconfig.setup_handlers({
    M.mason_lspconfig_handler
  })
end

function M.mason_lspconfig_handler(server_name) -- default handler (optional)
  M.lsp_attached[server_name] = "lspconfig"
  M.log("lspconfig handler: %s", server_name)
  local setup = {
    on_attach = M.on_attach_lspconfig,
  }
  if server_name == "rust_analyzer" then
    setup["settings"] = {
      ["rust-analyzer"] = { diagnostics = { disabled = { "inactive-code" } } }
    }
  end

  require("lspconfig")[server_name].setup(setup)
end

function M.setup_mason_null_ls()
  -- https://github.com/jay-babu/mason-null-ls.nvim#example-config
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code
  require("null-ls").setup({ on_attach = M.on_attach_autoformat })
  require("mason-null-ls").setup({
    ensure_installed = M.mason_install["null-ls"],
    automatic_installation = true,
    -- pending https://github.com/jay-babu/mason-null-ls.nvim/pull/64
    handlers = { M.null_ls_handler },
  })
end

function M.null_ls_handler(source, types)
  -- `types` is a list with "diagnostics" "formatting" etc.
  local configured = M.lsp_attached[source]
  if configured then
    M.log("null-ls handler: %s already configured: %s", source, configured)
  else
    local null_ls = require("null-ls")
    vim.tbl_map(function(type)
      -- initially copied from mason-null-ls.automatic_setup
      null_ls.register(null_ls.builtins[type][source])
      M.lsp_attached[source] = "null-ls"
      M.log("null-ls handler: configured: %s %s", source, type)
    end, types)
  end
end

function M.on_attach_autoformat(client, bufnr)
  if M.lsp_formatting[bufnr] ~= nil then
    M.log(
      "formatting: %s: %s (dup: %s)",
      bufnr,
      client.name,
      M.lsp_formatting[bufnr]
    )
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = M.au_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = M.au_format,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = "format on save: " .. client.name,
    })
    M.lsp_formatting[bufnr] = client.name
    M.log("formatting: %s: %s ", bufnr, M.lsp_formatting[bufnr])
  else
    M.log("formatting: no support: %s", client.name)
  end
end

function M.update_loclist_if_visible()
  local loclist = vim.fn.getloclist(0, { winid = 0 })
  if loclist.winid ~= 0 then
    vim.diagnostic.setloclist()
  end
end

return M
