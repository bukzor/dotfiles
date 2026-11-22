" status bar
set display+=lastline   "show huge lines even when they don't completely fit
set scrolloff=3         "keep three lines visible above and below
set sidescrolloff=8     "keep cursor away from left and right edge, too
set ruler showcmd       "give line, column, and command in the status line
set laststatus=2        "always show; reduce flicker on open/close split

" prefix buffer number (for :b N, N<C-^>); nvim's default statusline is
" non-empty (diagnostics, progress), so extend it rather than replace it
if empty(&statusline)  " vim: spell out the builtin default
  set statusline=%<%f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
endif
if &statusline !~# '^%n: '  " idempotent under re-source
  let &statusline = '%n: ' . &statusline
endif
