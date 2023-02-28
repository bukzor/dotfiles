set nocursorline
set nocursorcolumn
set nowrap  " wrapping makes cursorcolumn terribly ugly
set diffopt+=followwrap
set cursorlineopt=number,screenline


function! CursorLineEnter() abort
  set cursorline cursorcolumn
endfunction

function! CursorLineLeave() abort
  if &cursorbind
    set cursorline nocursorcolumn
  else
    set nocursorline nocursorcolumn
  endif
endfunction

augroup cursorline_stuff
  autocmd!

  au User DiffModeEnter,DiffModeExit call CursorLineEnter()
  au WinEnter * call CursorLineEnter()
  au WinLeave * call CursorLineLeave()
augroup END

