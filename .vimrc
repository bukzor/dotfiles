" display options {
    syntax on               "syntax coloring is a first-cut debugging tool
    colorscheme murphy      "change to taste. try `desert' or `evening'

    set wrap                "wrap long lines
    set scrolloff=3         "keep three lines visible above and below
    set ruler showcmd       "give line, column, and command in the status line
    set laststatus=2        "always show the status line
                            "make filename-completion more terminal-like
    set wildmode=longest:full
    set wildmenu            "a menu for resolving ambiguous tab-completion
                            "files we never want to edit
    set wildignore=*.pyc,*.sw[pno],.*.bak,.*.tmp

    set incsearch           "search as you type
    set hlsearch            "highlight the search
    set ignorecase          "ignore case
    set smartcase           " ...unless the search uses uppercase letters
" }

" movement options {
    "enable mouse in normal, visual, help, prompt modes
    "I skip insert/command modes because it prevents proper middle-click pasting
    "TODO: can we get paste to work even with mouse enabled?
    set mouse=nvrh

    "move around more like a normal editor
    nnoremap j gj
    nnoremap k gk
    set whichwrap=b,s,h,l,<,>,[,]
    set backspace=indent,eol,start

    "bindings for the 'old' up and down
    noremap gj j
    noremap gk k
" }

" windows-style mappings {
    "ctrl+S to save.
    "NOTE: put this in ~/.cshrc for it to work properly in terminal vim:
    "       stty -ixon -ixoff
    map <c-s> :update<cr>
    imap <c-s> <c-o><c-s>
    "ctrl+A to select all
    noremap <c-a> ggVG
    imap <c-a> <esc><c-a>
    "ctrl+C to copy
    map <c-c> "+y
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
    "ctrl+V to paste
    map <c-v> "+gP
    imap <c-v> <c-o>"+gP
    vmap <c-v> "+P

    "replace <CTRL-V> with <CTRL-B>
    inoremap <c-b> <c-v>
" }

" common typos {
    "mapping a sequence starting with ':' causes a pause whenever : is typed
    "if that's too annoying, remove these
    nmap :Q :q
    nmap :W :w
    nmap :WQ :wq
    nmap Q: :q

    " this one causes a pause whenever you use q
    " nmap q: :q

    "never use Ex mode -- I never *mean* to press it
    nnoremap Q <ESC>

    "never use F1 -- I'm reaching for escape
    noremap  <F1> <ESC>
    noremap! <F1> <ESC>
    lnoremap <F1> <ESC>
" }

" multiple files {
    " be smarter about multiple buffers / vim instances
    "quick buffer switching with TAB, even with edited files
    set hidden
    nmap <TAB> :bn<CR>
    nmap <S-TAB> :bp<CR>
    set autoread            "auto-reload files, if there's no conflict
    set shortmess+=IA       "no intro message, no swap-file message

    "replacement for CTRL-I, also known as <tab>
    noremap <C-P> <C-I>

    "window switching
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-H> <C-W>h
    nnoremap <C-L> <C-W>l
    nnoremap <C-Q> <C-W>q
" }

" cursor highlight {
    set cursorline      " highlight my current line
    hi clear CursorLine " Using bold text, not the default
    hi CursorLine term=bold cterm=bold gui=bold

    set cursorcolumn    " ... and my current column
    hi clear CursorColumn    
    hi CursorColumn term=bold cterm=bold gui=bold
" }

" general usability {
    "turn off the annoying "ding!"
    set visualbell

    "cd to the file you're editing
    "set autochdir "vim 7.0

    "set extra option directly in files
    "example: "vim: syntax=vim"
    set modeline

    "don't clobber the buffer when pasting in visual mode
    vmap P p
    vnoremap p "_dP

    "reformat XML quickly
    nmap =x :%s/> *</>\r</g<enter>=G=gg<c-o><c-o>
" }

"indentation options {
    "TODO: conditional for @work
    set expandtab                       "use spaces, not tabs
    set softtabstop=4 shiftwidth=4      "4-space indents

    set shiftround                      "always use a multiple of 4 for indents
    set smarttab                        "backspace to remove space-indents
    set autoindent                      "auto-indent for code blocks
    "NOT: smartindent                   "it does stupid things with comments

    "smart indenting by filetype, better than smartindent
    filetype on
    filetype indent on
    filetype plugin on
" }

"extra filetypes {
    au BufNewFile,BufRead *.js.tmpl set filetype=javascript
    au BufNewFile,BufRead *.css.tmpl set filetype=css
    au BufNewFile,BufRead *.pxi set filetype=pyrex
" }

" bindings for vimdiff {
    if &diff
        "next match
        nnoremap m ]cz.
        "previous match
        nnoremap M [cz.
        "refresh the diff
        nnoremap R :w\|set nodiff\|set diff<cr>
        "quit, both panes
        nnoremap q :qall<cr>
    endif
" }

" plugins {
    " pre-config {
        " CSapprox: reproduce gvim colors in terminal vim..
        let g:CSApprox_verbose_level = 0 "don't complain
    " }

    " Pathogen: keep plugins nicely bundled in separate folders.
    "       http://www.vim.org/scripts/script.php?script_id=2332
    runtime autoload/pathogen.vim
    if exists('g:loaded_pathogen')
        call pathogen#infect()  "load the bundles, if possible
        Helptags                "plus any bundled help
    endif
    runtime! plugin/**/*.vim    "Load em up!

    " post-config {
    if !exists('g:CSApprox_loaded')
        " CSApprox didn't load.
        " Fall back to pre-compiled color scheme, if possible.
        silent! execute 'colorscheme' colors_name.'-approx'
    endif
    " }
" }

" Location-specific settings. {
    if filereadable("/nail/scripts/aliases.sh")
        " At work!
        set noexpandtab
        set tabstop=4
    endif
" }

" vim:expandtab:
