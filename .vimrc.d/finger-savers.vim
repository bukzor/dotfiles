" Finger-savers for (my) common operations

let mapleader = '\'

" buffer delete, but without closing the window
nnoremap <Leader>bd <Cmd>bn \| bd#<CR>
" goto directory
nnoremap <Leader>fd <Cmd>e %:h<CR>
" chmod executable
nnoremap <Leader>fx <Cmd>!chmod 755 %<CR>
" paste the filename
nnoremap <Leader>fp :<C-U>put =expand(v:count ? \"#\" . v:count : \"%\")<CR>
" git add
nnoremap <Leader>ga <Cmd>!git add %<CR>
