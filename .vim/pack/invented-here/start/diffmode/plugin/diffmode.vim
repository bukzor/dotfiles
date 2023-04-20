" from http://www.bestofvim.com/tip/diff-diff/
function! DiffToggle() abort
    if &diff
        diffoff
    else
        diffthis
    endif
endfunction

function! DiffToggleWhitespace() abort
   if &diffopt =~ 'iwhiteall'
     set diffopt-=iwhiteall
   else
     set diffopt+=iwhiteall
   endif
endfunction


function! DiffEvent() abort
  if &diff
    doautocmd User DiffModeEnter
  else
    doautocmd User DiffModeExit
  endif
endfunction

function! DiffModeEnter()
  "next match
  nnoremap <buffer> m ]cz.
  "previous match
  nnoremap <buffer> M [cz.
  "refresh the diff
  nnoremap <buffer> R :w\|set nodiff\|set diff<cr>
endfunction

function! DiffModeExit() abort
  silent nnoremap <buffer> m :cn<cr>
  silent nnoremap <buffer> M :cN<cr>
  silent! nunmap <buffer> R
endfunction

augroup diff_mode_plugin
  autocmd!

  if &diff  " only run for vimdiff
    "show me the top of the "new" file
    au VimEnter * normal lgg
    "quit, both panes
    nnoremap q :qall<cr>
  endif

  " adjust vimdiff defaults
  set diffopt+=iwhiteall
  silent! set diffopt+=hiddenoff
  silent! set diffopt+=algorithm:patience

  au VimEnter,OptionSet * call DiffEvent()
  au User DiffModeEnter call DiffModeEnter()
  au User DiffModeExit call DiffModeExit()

  nnoremap <Leader>df :call DiffToggle()<CR>
  nnoremap <Leader>dw :call DiffToggleWhitespace()<CR>

  " diff bindings that are fine always-on
  "next diff
  nnoremap <buffer> ]d ]cz.
  "previous diff
  nnoremap <buffer> [d [cz.
augroup END
