" display options {
    syntax on               "syntax coloring is a first-cut debugging tool
    scriptencoding utf-8
    " FIXME: set up personal termcaps
    if empty(&t_8f)         "24bit color escapes; see ':help xterm-true-color'.
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    if has('termguicolors')
        set termguicolors   "use 24bit color schemes in the terminal
    endif
    colorscheme tomorrownight "change to taste. try `desert' or `evening'

    set number
    set wrap                "wrap long lines
    set display+=lastline   "show huge lines even when they don't completely fit
    set scrolloff=3         "keep three lines visible above and below
    set sidescrolloff=10    "keep cursor away from left and right edge, too
    set ruler showcmd       "give line, column, and command in the status line
    set colorcolumn=80      "often I want to know when/if I've exceeded 80 columns
    set laststatus=2        "always show the status line
                            "make filename-completion more terminal-like
    set wildmode=longest:full
    set wildmenu            "a menu for resolving ambiguous tab-completion
                            "files we never want to edit
    set wildignore=*.pyc,*.sw[pno],.*.bak,.*.tmp

    " Make whitespace characters look nice when shown.
    set listchars=tab:→\ ,extends:»,precedes:«,nbsp:␠,trail:␠
    set list

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
    set statusline +=%2n:           " buffer number
    set statusline +=%<             " truncation point
    set statusline +=%f\            " relative path to file
    set statusline +=%#Error#%m     " modified flag [+], highlighted as error
    set statusline +=%r             " readonly flag [RO]
    set statusline +=%##%y          " filetype [ruby], reset color
    set statusline +=%=             " split point for left and right justification
    set statusline +=%P\ \          " percentage through buffer
    set statusline +=row:\ %3l      " current line number
    set statusline +=/%-3L\         " number of lines in buffer
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

    "use jj to escape insert mode
    inoremap jj <ESC>

    "don't clobber the buffer when pasting in visual mode
    vmap P p
    vnoremap p pgvy

    " send any copied lines to the clipboard, too
    vnoremap y y:call SendViaOSC52(getreg('"'))<cr>
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
    map <c-c> y
    "ctrl+Y to redo
    map <c-y> <c-r>
    imap <c-y> <c-o><c-r>
    imap <c-r> <c-o><c-r>
    "ctrl+Z to undo
    "map <c-z> u            "this clobbers UNIX ctrl+z to background vim
    imap <c-z> <c-o>u
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

    "tab switching: ctrl+left/right
    nnoremap <C-PageUp> :tabp<CR>
    nnoremap <C-PageDown> :tabN<CR>

    "paste the filename
    noremap <Leader>pf :<C-U>put =expand(v:count ? \"#\" . v:count : \"%\")<CR>
" }

"indentation options {
    set expandtab                       "use spaces, not tabs
    set softtabstop=2 shiftwidth=2      "2-space indents


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
        silent! set diffopt+=hiddenoff
        silent! set diffopt+=algorithm:patience
    endif
" }

" { Finger-savers:
nnoremap bd :bn \| bd#<CR>
" }

" { from http://www.bestofvim.com/tip/diff-diff/
    nnoremap <Leader>df :call DiffToggle()<CR>

    function! DiffToggle()
        if &diff
            diffoff
        else
            diffthis
        endif
    :endfunction

    nnoremap <Leader>dw :call DiffToggleWhitespace()<CR>

    function! DiffToggleWhitespace()
       if &diffopt =~ 'iwhite'
         set diffopt-=iwhite
       else
         set diffopt+=iwhite
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
set modeline
" vim:et:sts=4:sw=4
