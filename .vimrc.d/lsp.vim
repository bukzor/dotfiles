" VSCode owns LSP and completion
if exists('g:vscode') | finish | endif

let g:ale_completion_enabled = 1
let g:ale_completion_delay = 500
let g:ale_completion_autoimport = 1

" Use ALE's function for omnicompletion.
set omnifunc=ale#completion#OmniFunc

" dynamic help {
  let g:ale_set_balloons = has('gui_running') ? 'hover' : 0
  set completeopt+=menu
  set completeopt-=preview
  set completeopt+=menuone
  try
    set completeopt+=popup
    set completeopt+=noselect
    set completeopt+=noinsert
  catch /.*/
  endtry
  let g:ale_floating_preview = 1
" }

if has('nvim')
  " detach all LSP clients from this buffer, and clear its diagnostics
  command! LspDetach lua for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    \ vim.lsp.buf_detach_client(0, c.id) end; vim.diagnostic.reset(nil, 0)
endif
