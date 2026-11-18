" search
set hlsearch            "highlight matches
set incsearch           "show matches while the pattern is typed
set ignorecase          "match even if captilization doessn't
set smartcase           "unless the pattern isn't just lowercase

"...but * and # match case exactly (they obey ignorecase, never smartcase)
nnoremap * /\<<C-R>=expand('<cword>')<CR>\>\C<CR>
nnoremap # ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>
