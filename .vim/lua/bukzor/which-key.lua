-- requirements/features:
--   1. to load this config: :luafile %
--   1. loading the config un-does any deleted config

M = {}

function M.init()
  M.reset()
  M.config()
  return M
end

function M.reset()
  local reload = require("plenary.reload").reload_module
  reload("which-key")
  local wk = require("which-key")
  return wk
end

function M.config()
  local wk = M.reset()

  -- TODO steal from:
  --    https://www.lunarvim.org/docs/beginners-guide/keybinds-overview

  -- which-key v3 spec is flat (children don't inherit parent lhs).
  -- This helper prepends `prefix` to each child's lhs so we can write
  -- groups without repeating the prefix on every line.
  local function group(prefix, name, children)
    local spec = { mode = { "n", "v" }, { prefix, group = name } }
    for _, c in ipairs(children) do
      c[1] = prefix .. c[1]
      spec[#spec + 1] = c
    end
    wk.add(spec)
  end

  wk.add({
    mode = { "n", "v" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature Help" },
    { "<leader>q", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Quickfix List" },
    { "<leader>e", vim.diagnostic.open_float, desc = "Error Detail" },
    { "<leader>a", vim.lsp.buf.code_action, desc = "Code Actions" },
  })

  group("<leader>l", "Language Server", {
    { "i", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Info (doc)" },
    { "I", "<cmd>Trouble diagnostics toggle<cr>", desc = "Info (workspace)" },
    { "r", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
    { "s", vim.lsp.buf.document_symbol, desc = "Symbol (doc)" },
    { "S", vim.lsp.buf.workspace_symbol, desc = "Symbol (workspace)" },
    { "R", vim.lsp.buf.rename, desc = "Rename Variable" },
  })

  group("<leader>lw", "Workspace", {
    { "a", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" },
    { "r", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" },
    { "l", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, desc = "List Folders" },
  })

  local function diag_prev() vim.diagnostic.jump({ count = -1 }) end
  local function diag_next() vim.diagnostic.jump({ count = 1 }) end
  local function err_prev() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end
  local function err_next() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end
  local function warn_prev() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN }) end
  local function warn_next() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN }) end

  group("[", "Previous", {
    { "d", diag_prev, desc = "Prev Diagnostic" },
    { "e", err_prev, desc = "Prev Error" },
    { "w", warn_prev, desc = "Prev Warning" },
  })

  group("]", "Next", {
    { "d", diag_next, desc = "Next Diagnostic" },
    { "e", err_next, desc = "Next Error" },
    { "w", warn_next, desc = "Next Warning" },
  })

  group("g", "Goto", {
    { "d", vim.lsp.buf.definition, desc = "Definition" },
    { "D", vim.lsp.buf.declaration, desc = "Declaration" },
    { "t", vim.lsp.buf.type_definition, desc = "Type Declaration" },
    { "i", vim.lsp.buf.implementation, desc = "Implementation" },
    -- p (peek): nvim lsp has no peek equivalents
    --   <Leader>lpD :LspPeekDeclaration
    --   <Leader>lpi :LspPeekImplementation
  })
end

---TODO:
---augroup lsp_stuff
---  autocmd!
---  autocmd BufEnter,CursorHold,InsertLeave lua vim.lsp.codelens.refresh()
---  autocmd CursorHold  lua vim.lsp.buf.document_highlight()
---  autocmd CursorHoldI lua vim.lsp.buf.document_highlight()
---  autocmd CursorMoved lua vim.lsp.buf.clear_references()
---  autocmd User lsp_buffer_enabled call g:OnLspBufferEnabled()
---augroup END

return M.init()
