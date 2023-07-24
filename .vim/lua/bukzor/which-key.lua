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

  wk.register(
    {
      A = nil,
      ["K"] = { vim.lsp.buf.hover, "Hover" },
      ["<C-K>"] = { vim.lsp.buf.signature_help, "Signature Help" },
      ["<leader>"] = {
        q = { "<cmd>TroubleToggle document_diagnostics<cr>", "Quickfix List" },
        e = { vim.diagnostic.open_float, "Error Detail" },
        a = { vim.lsp.buf.code_action, "Code Actions" },
        l = {
          name = "Language Server",
          i = { "<cmd>TroubleToggle document_diagnostics<cr>", "Info (doc)" },
          I = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Info (workspace)" },
          r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
          s = { vim.lsp.buf.document_symbol, "Symbol (doc)" },
          S = { vim.lsp.buf.workspace_symbol, "Symbol (workspace)" },
          ---nnoremap <Leader>lS  :LspStatus<CR>
          R = { vim.lsp.buf.rename, "Rename Variable" },
          w = {
            name = "Workspace",
            a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
            r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
            l = { function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end
            , "List Folders" },
          },
        },
      },
      ["["] = {
        name = "Previous",
        d = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
        e = { vim.diagnostic.goto_next, "Prev Error" },
      },
      ["]"] = {
        name = "Next",
        d = { vim.diagnostic.goto_next, "Next Diagnostic" },
        e = { vim.diagnostic.goto_next, "Next Error" },
      },
      g = {
        name = "Goto",
        d = { vim.diagnostic.definition, "Definition" },
        D = { vim.diagnostic.declaration, "Declaration" },
        t = { vim.lsp.buf.type_definition, "Type Declaration" },
        i = { vim.lsp.buf.implementation, "Implementation" },
        -- p = {  -- nvim lsp doesn't seem to have a "peek"
        --   name = "Peek",
        --   nnoremap <Leader>lpD :LspPeekDeclaration<CR>
        --   nnoremap <Leader>lpi :LspPeekImplementation<CR>
        -- }
      },
    },
    { mode = { "n", "v" } }
  )
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
