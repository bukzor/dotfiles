" Finger-savers for (my) common operations

let mapleader = '\'

" buffer delete, but without closing the window
nnoremap <Leader>bd :bn \| bd#<CR>
" goto directory
nnoremap <Leader>fd :e %:h<CR>
" chmod executable
nnoremap <Leader>fx :!set -x; chmod 755 %<CR>
" paste the filename
nnoremap <Leader>fp :<C-U>put =expand(v:count ? \"#\" . v:count : \"%\")<CR>
" git add
nnoremap <Leader>ga :!git add %<CR>
