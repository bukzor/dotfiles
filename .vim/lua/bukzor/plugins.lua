local M = {}

M.au_attach = "BukzorLspAttach"
M.au_format = "BukzorLspFormat"
M.au_other = "BukzorLspOther"

function M.setup()
  vim.api.nvim_create_augroup(M.au_attach, { clear = true })
  vim.api.nvim_create_augroup(M.au_format, { clear = true })
  vim.api.nvim_create_augroup(M.au_other, { clear = true })

  M.setup_mason()
  M.setup_lspconfig()
  M.setup_mason_lspconfig()
  M.setup_null_ls()

  vim.api.nvim_create_augroup("END", { clear = true })
end
function M.setup_mason()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

function M.setup_lspconfig()
  -- https://github.com/neovim/nvim-lspconfig/tree/master#suggested-configuration
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = M.au_attach,
    callback = M.on_attach_lsp,
    desc = "lsp key bindings",
  })
end

function M.on_attach_lsp(ev)
  vim.api.nvim_clear_autocmds({ group = M.au_attach, buffer = ev.buf })

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

function M.setup_mason_lspconfig()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup({})
    end,
  })
end

function M.setup_null_ls_handler(source, types)
  -- same as mason-null-ls.automatic_setup, but without memoize =.=
  -- DELETEME: pending https://github.com/jay-babu/mason-null-ls.nvim/pull/62
  local null_ls = require("null-ls")
  if not null_ls.is_registered(source) then
    vim.tbl_map(function(type)
      null_ls.register(null_ls.builtins[type][source])
    end, types)
  end
end

function M.setup_null_ls()
  -- https://github.com/jay-babu/mason-null-ls.nvim#example-config

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code
  require("null-ls").setup({ on_attach = M.on_attach_null_ls })
  require("mason-null-ls").setup({
    ensure_installed = { "stylua", "jq", "blackd-client", "pyright" },
    automatic_installation = true,
    handlers = { M.setup_null_ls_handler },
    -- once they unmemoize:
    --handlers = { require("mason-null-ls").default_setup },
  })
end

function M.on_attach_null_ls(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = M.au_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = M.au_format,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = "null-ls format on save",
    })
  end
end

function M.unload()
  vim.api.nvim_del_augroup_by_name(M.au_attach)
  vim.api.nvim_del_augroup_by_name(M.au_format)
  require("null-ls.config").reset() -- otherwise it refuses to be configured
end

return M
