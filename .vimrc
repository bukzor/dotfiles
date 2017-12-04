" display options {
    syntax on               "syntax coloring is a first-cut debugging tool
    colorscheme tomorrownight "change to taste. try `desert' or `evening'

    set wrap                "wrap long lines
    set display+=lastline   "show huge lines even when they don't completely fit
    set scrolloff=3         "keep three lines visible above and below
    set ruler showcmd       "give line, column, and command in the status line
    set laststatus=2        "always show the status line
                            "make filename-completion more terminal-like
    set wildmode=longest:full
    set wildmenu            "a menu for resolving ambiguous tab-completion
                            "files we never want to edit
    set wildignore=*.pyc,*.sw[pno],.*.bak,.*.tmp
" }

" searching {
    set incsearch           "search as you type
    set hlsearch            "highlight the search
    set ignorecase          "ignore case
    set smartcase           " ...unless the search uses uppercase letters

    "Use case-sensitive search for the * command though.
    :nnoremap * /\<<C-R>=expand('<cword>')<CR>\>\C<CR>
    :nnoremap # ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>
" }

" statusline {
" compare the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline =                " clear!
set statusline +=%<             " truncation point
set statusline +=%2n:           " buffer number
set statusline +=%f\            " relative path to file
set statusline +=%#Error#%m     " modified flag [+], highlighted as error
set statusline +=%r             " readonly flag [RO]
set statusline +=%##%y          " filetype [ruby], reset color
set statusline +=%=             " split point for left and right justification
set statusline +=row:\ %3l      " current line number
set statusline +=/%-3L\          " number of lines in buffer
set statusline +=(%3P)\         " percentage through buffer
set statusline +=col:\ %3v\     " current virtual column number (visual count)
" }

" movement options {
    "enable mouse in normal, visual, help, prompt modes
    "I skip insert/command modes because it prevents proper middle-click pasting
    "TODO: can we get paste to work even with mouse enabled?
    set mouse=nvrh

    " Moving up/down moves visually.
    " This makes files with very long lines much more manageable.
    nnoremap j gj
    nnoremap k gk
    " Moving left/right will wrap around to the previous/next line.
    set whichwrap=b,s,h,l,<,>,~,[,]
    " Backspace will delete whatever is behind your cursor.
    set backspace=indent,eol,start

    "Bind the 'old' up and down. Use these to skip past a very long line.
    nnoremap gj j
    nnoremap gk k
" }

" general usability {
    "turn off the annoying "ding!"
    set visualbell

    "allow setting extra option directly in files
    "example: "vim: syntax=vim"
    set modeline

    "don't clobber the buffer when pasting in visual mode
    vmap P p
    vnoremap p pgvy
" }

" windows-style mappings {
    "ctrl+S to save.
    "NOTE: put this in ~/.bashrc for it to work properly in terminal vim:
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
    "ctrl+V to paste, in visual mode
    vmap <c-v> "+P
" }

" common typos {
    " Often I hold shift too long when issuing these commands.
    command! -bang Q q<bang>
    command! -bang Qall qall<bang>
    command! -bang W w<bang>
    command! -bang Wall wall<bang>
    command! -bang WQ wq<bang>
    command! -bang Wq wq<bang>
    command! -bang Redraw redraw!
    command! -nargs=* Set set <args>
    nmap Q: :q

    " this one causes a pause whenever you use q, so I don't use it
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

    "window switching: ctrl+[hjkl]
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-H> <C-W>h
    nnoremap <C-L> <C-W>l
    nnoremap <C-Q> <C-W>q

    "tab switching: ctrl+left/right
    nnoremap <C-PageUp> :tabp<CR>
    nnoremap <C-PageDown> :tabN<CR>
" }

"indentation options {
    set expandtab                       "use spaces, not tabs
    set softtabstop=4 shiftwidth=4      "4-space indents


    set shiftround                      "always use a multiple of 4 for indents
    set smarttab                        "backspace to remove space-indents
    set autoindent                      "auto-indent for code blocks
    "DONT USE: smartindent              "it does stupid things with comments

    "smart indenting by filetype, better than smartindent
    filetype on
    filetype indent on
    filetype plugin on
" }

"extra filetypes {
    au BufNewFile,BufRead *.js.tmpl set filetype=javascript
    au BufNewFile,BufRead *.css.tmpl set filetype=css
    au BufNewFile,BufRead *.pxi set filetype=pyrex
    au BufNewFile,BufRead *.md set filetype=markdown
    au BufNewFile,BufRead *.proto set filetype=proto
" }

" tkdiff-like bindings for vimdiff {
    if &diff
        "next match
        nnoremap m ]cz.
        "previous match
        nnoremap M [cz.
        "refresh the diff
        nnoremap R :w\|set nodiff\|set diff<cr>
        "quit, both panes
        nnoremap q :qall<cr>

        "show me the top of the "new" file
        autocmd VimEnter * normal lgg

        set diffopt+=iwhite
    endif
" }

" use patience algorithm for improved diffs {
    " lifted from :help diff-diffexpr
    ""set diffexpr=MyDiff()
    function! MyDiff()
        let opt = ""
        " not supported by git-diff
        "if &diffopt =~ "icase"
            "let opt = opt . "-i "
        "endif

        if &diffopt =~ "iwhite"
            let opt = opt . "-w "
        endif
        if
        \   getfsize(v:fname_in) <= 6 &&
        \   getfsize(v:fname_new) <= 6 &&
        \   readfile(v:fname_in, 0, 1)[0] ==# 'line1' &&
        \   readfile(v:fname_new, 0, 1)[0] ==# 'line2'
            " don't run twice:
            " https://stackoverflow.com/a/15884198/146821
            call writefile(["1c1", "< line1", "---", "> line2"], v:fname_out)
        else
            "silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
            silent execute "!git-diff--ed " . opt . v:fname_in . " " . v:fname_new .
                \  " > " . v:fname_out
            redraw!
        endif
    endfunction
"

" { from http://www.bestofvim.com/tip/diff-diff/
    nnoremap <Leader>df :call DiffToggle()<CR>

    function! DiffToggle()
        if &diff
            diffoff
        else
            diffthis
        endif
    :endfunction
" }
"
nnoremap <Leader>gd :e %:h<CR>

" Pathogen: {
    " keep plugins nicely bundled in separate folders.
    " http://www.vim.org/scripts/script.php?script_id=2332
    runtime autoload/pathogen.vim
    if exists('g:loaded_pathogen')
        call pathogen#infect()    "load the bundles, if possible
        Helptags                  "plus any bundled help
        runtime bundle_config.vim "give me a chance to configure the plugins
    endif
" }

" extra, local settings {
if filereadable($HOME . "/.vimrc.extra")
    source $HOME/.vimrc.extra
endif
if filereadable($HOME . "/private-dotfiles/.vimrc")
    source $HOME/private-dotfiles/.vimrc
endif
" }


set exrc
set secure
" vim:et:sts=4:sw=4
