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

if &diff  " only run for vimdiff
    "quit, both panes
    nnoremap q :qall<cr>
endif

augroup diff_mode_plugin
  autocmd!

  if &diff  " only run for vimdiff
    "show me the top of the "new" file
    au VimEnter * normal lgg
  endif

  au VimEnter,OptionSet * call DiffEvent()
  au User DiffModeEnter call DiffModeEnter()
  au User DiffModeExit call DiffModeExit()
augroup END
