local M = {}

-- mason is in charge of installing various tools
M.mason_install = {
  -- lspconfig configures many language servers
  -- full list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  lspconfig = {
    "rust_analyzer", -- rust
    "lua_ls", -- lua
    "pyright", -- python
    -- FIXME: none of these are valid
    --- "jq", -- jq
    --- "jqls", -- jq
    --- "jqlsp", -- jq
    --- "jq-ls", -- jq
    --- "jq-lsp", -- jq
    --- "jq_ls", -- jq
    --- "jq_lsp", -- jq
    "jsonls", -- json
    "jsonnet_ls", -- jsonnet
    "tflint", -- terraform
    "terraformls", -- terraform-ls: terraform
    "tsserver", -- typescript
    "vimls", --vim
    "clangd", -- c/c++
    "gopls", -- golang
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
    "shellcheck", -- .sh
    "fish", -- .fish
    "zsh", -- .zsh
    "dotenv_linter", -- .env
    "editorconfig_checker", -- .editorconfig
    "gitlint", -- git commit messages
    --"commitlint",  -- needs configuration
    "glslc", -- GLSL
    "tfsec", -- terraform
    "gofmt", -- golang
  },
}

M.au_format = "BukzorLspFormat"
M.au_loclist = "BukzorLspLocList"
M.lsp_attached = nil
M.lsp_formatting = nil
M.ensure_installed_by = nil

function M.log(...)
  require("mason-core.log").fmt_trace(...)
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
    log_level = vim.log.levels.INFO,
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
  -- https://github.com/neovim/nvim-lspconfig/tree/master#suggested-configuration
  vim.keymap.set("n", "<leader>ll", vim.diagnostic.open_float)
  vim.keymap.set("n", "[l", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]l", vim.diagnostic.goto_next)
  vim.keymap.set("n", "ge", vim.diagnostic.goto_next)
  vim.keymap.set("n", "gE", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<leader>lw", M.show_loclist)

  M.setup_loclist_update()
end

function M.on_attach(client, bufnr)
  require("lsp-inlayhints").on_attach(client, bufnr)
  M.autoformat(client, bufnr)

  -- prevent jittery rendering by just always showing the sign column
  vim.opt_local.signcolumn = "yes:1"

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
  vim.bo[bufnr].formatexpr = ""

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("i", "<c-x><c-s>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
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
  mason_lspconfig.setup({
    ensure_installed = M.mason_install["lspconfig"],
  })
  mason_lspconfig.setup_handlers({ M.mason_lspconfig_handler })
end

function M.mason_lspconfig_handler(server_name) -- default handler (optional)
  M.lsp_attached[server_name] = "lspconfig"
  M.log("lspconfig handler: %s", server_name)
  require("lspconfig")[server_name].setup({
    on_attach = M.on_attach,
  })
end

function M.setup_mason_null_ls()
  -- https://github.com/jay-babu/mason-null-ls.nvim#example-config
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code
  --require("null-ls").setup()
  require("null-ls").setup({ on_attach = M.autoformat })
  require("mason-null-ls").setup({
    ensure_installed = M.mason_install["null-ls"],
    automatic_installation = true,
    -- pending https://github.com/jay-babu/mason-null-ls.nvim/pull/64
    handlers = { M.null_ls_handler },
  })
end

function M.null_ls_handler(source, types)
  -- `types` is a list with "diagnostics" "formatting" etc.
  local configured_by = M.lsp_attached[source]
  if configured_by ~= nil then
    M.log("null-ls handler: %s already configured: %s", source, configured_by)
    return
  end

  -- initially copied from mason-null-ls.automatic_setup
  local null_ls = require("null-ls")
  vim.tbl_map(function(type)
    local builtin = null_ls.builtins[type][source]
    if builtin == nil then
      M.log("null-ls handler: unknown: %s %s", source, type)
    else
      null_ls.register(builtin)
      M.lsp_attached[source] = "null-ls"
      M.log("null-ls handler: configured: %s %s", source, type)
    end
  end, types)
end

function M.autoformat(client, bufnr)
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

function M.setup_loclist_update()
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = M.au_loclist,
    callback = M.update_loclist_if_visible,
  })
end

return M
