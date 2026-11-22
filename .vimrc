" supports Vim >= 8.2.3995 and the latest stable nvim; see
" docs/dev/adr/2026-11-22-000-vim-and-nvim-support-floor.md
if exists("$VIMDEBUG")
  set verbose=2
endif

" relative to this file, not $HOME, so a checkout elsewhere (CI) loads itself
for s:vimfile in glob(fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/.vimrc.d/*.vim', 0, 1)
  exe "source" fnameescape(s:vimfile)
endfor

set verbose=0
