"display options {
    syntax on               "syntax coloring is a first-cut debugging tool
    colorscheme evening     "you might want to change this to your taste

    set wrap                "wrap long lines
    set scrolloff=3         "keep three lines visible above and below
    set ruler showcmd       "give line, column, and command in the status line
    set laststatus=2        "always show the status line
                            "make filename-completion more terminal-like
    set wildmode=list:longest           
                            "files we never want to edit 
    set wildignore=*.pyc,*.swp,.*.bak,.*.tmp            

    set incsearch           "search as you type
    set hlsearch            "highlight the search
    set ignorecase          "ignore case
    set smartcase           " ...unless the search uses uppercase letters
" }

" movement options {
    "move around more like a normal editor
    noremap j gj
    noremap k gk
    set whichwrap=b,s,h,l,<,>,[,]
    set backspace=indent,eol,start

    "bindings for the 'old' up and down
    noremap gj j
    noremap gk k

    " space / shift-space scroll in normal mode, like a web browser
    noremap <S-space> <C-b>
    noremap <space> <C-f>
" }

"windows-style mappings {
    "ctrl+S to save. 
    "NOTE: put this in ~/.cshrc for it to work properly in terminal vim:
    "       stty -ixon -ixoff
    map <c-s> :update<cr>
    imap <c-s> <c-o><c-s>
    "ctrl+A to select all
    noremap <c-a> ggVG
    imap <c-a> <esc><c-a>
    "ctrl+C to copy
    map <c-c> y
    "ctrl+V to paste
    map <c-v> gP
    imap <c-v> <c-o>gP
    vmap <c-v> P
    "ctrl+Y to redo
    map <c-y> <c-r>
    imap <c-y> <c-o><c-r>
    imap <c-r> <c-o><c-r>
    "ctrl+Z to undo 
    "map <c-z> u            "this clobbers UNIX ctrl+z to background vim
    imap <c-z> <c-o>u
    "ctrl+Q to save/quit
    map <c-q> :update\|q<cr>
    imap <c-q> <c-o><c-q>

" }

" common typos {
    nmap :Q :q
    nmap q: :q
    nmap Q: :q
    nmap :W :w
    nmap :WQ :wq
" }

" general usability {
    "never use Ex mode
    nmap Q <ESC>            

    "turn off the annoying "ding!"
    set visualbell

    "cd to the file you're editing
    set autochdir "vim 7.0

    "quick buffer switching with TAB, even with edited files
    set hidden
    nmap <TAB> :bn<CR>
    nmap <S-TAB> :bp<CR>
" }


"indentation options {
    set expandtab                       "use spaces, not tabs
    set softtabstop=4 shiftwidth=4      "4-space indents
    set shiftround                      "always use a multiple of 4 for indents
    set smarttab                        "backspace to remove space-indents
    set autoindent                      "auto-indent for code blocks
    "set smartindent                    "too many problems with this

    "smart indenting by filetype, better than smartindent
    filetype on       
    filetype indent on
    filetype plugin on
" }

" visual-mode usability {
    "sticky shifting in visual mode
    vnoremap < <gv
    vnoremap > >gv

    "don't clobber the buffer when pasting in visual mode
    vmap P p
    vnoremap p "_dP
" }

"nonstandard, personal preferences {
    "escape insert mode with just 'jj'
    inoremap jj <Esc>

    "replace <CTRL-I> (also known as <TAB>) with <CTRL-P>
    noremap <C-P> <C-I>

    "python files shouldn't use tabs
    au BufReadPost *.py retab

    "highlight lines over the width limit
    "highlight OverLength ctermbg=DarkRed guibg=#444444
    "match OverLength /\%81v.\+/

" }
