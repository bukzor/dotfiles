local M = {}

M.au_attach = "BukzorLspAttach"
M.au_format = "BukzorLspFormat"

function M.setup()
  vim.api.nvim_create_augroup(M.au_attach, { clear = true })
  vim.api.nvim_create_augroup(M.au_format, { clear = true })
  vim.api.nvim_create_augroup("END", { clear = true })

  M.setup_mason()
  M.setup_lspconfig()
  M.setup_mason_lspconfig()
  M.setup_null_ls()
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
  vim.keymap.set("n", "<leader>ll", vim.diagnostic.open_float)
  vim.keymap.set("n", "[l", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]l", vim.diagnostic.goto_next)
  vim.keymap.set("n", "ge", vim.diagnostic.goto_next)
  vim.keymap.set("n", "gE", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<leader>lw", vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = M.au_attach,
    callback = M.on_attach_lsp,
    desc = "lsp key bindings",
  })
end

function M.on_attach_lsp(ev)
  --print("LSP EV:", ev)
  vim.api.nvim_clear_autocmds({ group = M.au_attach, buffer = ev.buf })

  -- prevent jittery rendering by just always showing the sign column
  vim.opt_local.signcolumn = "yes:1"

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.bo[ev.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
  vim.bo[ev.buf].formatexpr = ""

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = ev.buf }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)

  ---TODO:
  ---" Get current document diagnostics information.
  ---nnoremap <Leader>li :LspDocumentDiagnostics<CR>
  ---nnoremap <Leader>lS :LspStatus<CR>
  ---nnoremap <Leader>lpd :LspPeekDefinition<CR>
  ---nnoremap <Leader>lD :LspDeclaration<CR>
  ---nnoremap <Leader>lpD :LspPeekDeclaration<CR>
  ---nnoremap <Leader>lpi :LspPeekImplementation<CR>
  ---" Go to the type definition of the word under the cursor, and open in the current window.
  ---nnoremap <Leader>lt :LspTypeDefinition<CR>
  ---nnoremap <Leader>lpt :LspPeekTypeDefinition<CR>
  ---" View type hierarchy of the symbol under the cursor.
  ---nnoremap <Leader>lT :LspTypeHierarchy<CR>
  ---" Gets a list of possible commands that can be applied to a file so it can be fixed.
  ---nnoremap <Leader>la :LspCodeAction<CR>
  ---nnoremap <Leader>lr :LspReferences<CR>
  ---augroup lsp_stuff
  ---  autocmd!
  ---  autocmd BufEnter,CursorHold,InsertLeave lua vim.lsp.codelens.refresh()
  ---  autocmd CursorHold  lua vim.lsp.buf.document_highlight()
  ---  autocmd CursorHoldI lua vim.lsp.buf.document_highlight()
  ---  autocmd CursorMoved lua vim.lsp.buf.clear_references()
  ---  autocmd User lsp_buffer_enabled call g:OnLspBufferEnabled()
  ---augroup END
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

function M.setup_null_ls()
  -- https://github.com/jay-babu/mason-null-ls.nvim#example-config

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code
  require("null-ls").setup({ on_attach = M.on_attach_null_ls })
  require("mason-null-ls").setup({
    ensure_installed = { "stylua", "jq", "blackd-client", "pyright" },
    automatic_installation = true,
    -- pending https://github.com/jay-babu/mason-null-ls.nvim/pull/64
    handlers = { require("mason-null-ls").default_setup },
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
