" multiple files : be smarter about multiple buffers / vim instances

"quick buffer switching with TAB, even with edited files
set hidden
nmap <TAB> :bn<CR>
nmap <S-TAB> :bp<CR>
set autoread            "auto-reload files, if there's no conflict
set shortmess+=IA       "no intro message, no swap-file message
set shortmess-=F        "allow for debugging echo

"replacement for CTRL-I, (also known as <TAB>, see above)
noremap <C-P> <C-I>

"window switching: ctrl+[hjkl]
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

if has('nvim')
  "bindings for switching windows while in :terminal
  tnoremap <C-W> <C-\><C-N><C-W>
  tnoremap <C-H> <C-\><C-N><C-W>h
  tnoremap <C-J> <C-\><C-N><C-W>j
  tnoremap <C-K> <C-\><C-N><C-W>k
  tnoremap <C-L> <C-\><C-N><C-W>l
  tnoremap <ESC><ESC> <C-\><C-N>
  augroup MyTermMappings
    autocmd!
    autocmd TermOpen * nnoremap <buffer> o i
    autocmd TermOpen * nnoremap <buffer> O i
  augroup END
endif

"tab switching: ctrl+pageup/pagedown
nnoremap <C-PageUp> :tabp<CR>
nnoremap <C-PageDown> :tabN<CR>
