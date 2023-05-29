let g:ale_completion_enabled = 1
let g:ale_completion_delay = 500
let g:ale_completion_autoimport = 1

" Use ALE's function for omnicompletion.
set omnifunc=ale#completion#OmniFunc

" dynamic help {
  let g:ale_set_balloons = has('gui_running') ? 'hover' : 0
  set completeopt=menu,menuone,popup,noselect,noinsert
  let g:ale_floating_preview = 1
" }
