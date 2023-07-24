" common typos: try to make them work as if I typed it right

" Often I hold shift too long when issuing these commands.
command! -bang Q q<bang>
command! -bang Qall qall<bang>
command! -bang W w<bang>
command! -bang Wall wall<bang>
command! -bang WQ wq<bang>
command! -bang Wq wq<bang>
command! -bang Redraw redraw!
command! -bang -nargs=* Set set<bang> <args>
command! -bang -nargs=* E edit<bang> <args>
command! -bang -nargs=* Edit edit<bang> <args>
nmap Q: :q

" this one causes a pause whenever you use q, so I don't use it
" nmap q: :q

"never use Ex mode -- I never *mean* to press it
nnoremap Q <ESC>

"never use F1 -- I'm reaching for escape
noremap  <F1> <ESC>
noremap! <F1> <ESC>
lnoremap <F1> <ESC>
