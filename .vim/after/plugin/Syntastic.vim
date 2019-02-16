set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_loc_list_height = 5

let g:syntastic_rst_sphinx_args = "-n"
let g:syntastic_rst_checkers = ["sphinx"]

noremap <Leader>sc :w\|SyntasticCheck<CR>

let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "active_filetypes": ["bzl", "sh"],
    \ "passive_filetypes": ["python"] }
