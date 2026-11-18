set scrolloff=3         "keep three lines visible above and below
set sidescrolloff=8     "keep cursor away from left and right edge, too

set display+=lastline   "show huge lines even when they don't completely fit

set sidescroll=20       "use zL/zR to move quickly sideways

set whichwrap+=<,>,h,l  " allow moving the cursor left/right to other lines

" j/k move by screen line, so long wrapped lines stay navigable;
" gj/gk take over moving by file line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
