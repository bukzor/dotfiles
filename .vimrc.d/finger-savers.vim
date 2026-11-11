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

" claude quote: reformat a pasted transcript as a markdown blockquote --
" the whole buffer by default, or just the selection
command! -range=% ClaudeQuote <line1>,<line2>!colrm 1 2 | prettier-markdown | sed '/./s/^/> /'
nnoremap <Leader>cq <Cmd>ClaudeQuote<CR>
xnoremap <Leader>cq :ClaudeQuote<CR>
