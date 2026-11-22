if exists("$VIMDEBUG")
  set verbose=2
endif

" relative to this file, not $HOME, so a checkout elsewhere (CI) loads itself
for s:vimfile in glob(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/.vimrc.d/*.vim', 0, 1)
  exe "source" fnameescape(s:vimfile)
endfor

set verbose=0
