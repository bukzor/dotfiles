function! g:LogPluginPaths(label) abort
  silent echo "RUNTIMEPATH(" .. a:label .. "):\n   "
    \ substitute(&runtimepath, ",", "\n    ", "g")
  silent echo "   PACKPATH(" .. a:label .. "):\n   "
    \ substitute(&packpath, ",", "\n    ", "g")
endfunction

function! g:VimReset() abort
  " get vim back to a blank-slate state, as if we just started
  messages clear
  set background=dark
  highlight clear       " Uses the current value of 'background' to decide which default colors to use.
  syntax clear          " The command also deletes the 'b:current_syntax' variable
  syntax on
endfunction  " VimReset

command! VimReset call g:VimReset()
VimReset

if !exists("$VIMHOME")
  let $VIMHOME=split(&rtp, ',')[0]
endif
let g:plug_home = $VIMHOME .. '/pack/plugged/start'

" plugins {
  call bukzor#plug#bootstrap()
  " https://github.com/junegunn/vim-plug#readme
  call plug#begin()
    " the only color scheme
    Plug 'morhetz/gruvbox'

    " sensible behavior for zoom (AKA ctrl-w_o, AKA :only)
    Plug 'troydm/zoomwintab.vim'
    """ " have location list follow the cursor
    """ Plug 'elbeardmorez/vim-loclist-follow'
    """ let g:loclist_follow = 1

    "syntaxen
    Plug 'vim-python/python-syntax'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'hashivim/vim-terraform'
    Plug 'puppetlabs/puppet-syntax-vim'

    " migrated from pathogen
    Plug 'ConradIrwin/vim-bracketed-paste'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'will133/vim-dirdiff'
    Plug 'tpope/vim-sensible'
  call plug#end()
  call bukzor#plug#lazy_sync()
" } plugins

" display options {
    set synmaxcol=3000      "extra-long lines lose highlighting, for speed
    if has('termguicolors')
        set termguicolors   "use 24bit color schemes in the terminal
    endif
    set shortmess+=IA       "no intro message, no swap-file message
    set background=dark
    colorscheme gruvbox "change to taste. try `desert' or `evening'

    set number
    set norelativenumber
    set wrap                "wrap long lines
    " this makes vim's column-counting go weird:
    """set linebreak           "but not in the middle of a word, if possible

    set display+=lastline   "show huge lines even when they don't completely fit
    set scrolloff=3         "keep three lines visible above and below
    set sidescrolloff=8     "keep cursor away from left and right edge, too
    "set ruler showcmd       "give line, column, and command in the status line
    set colorcolumn=80      "often I want to know when/if I've exceeded 80 columns
    set colorcolumn+=+1,+2  "visual inidicator of maximum column
    set laststatus=2        "always show the status line
    "set laststatus=3        "global status line
                            "make filename-completion more terminal-like
    set wildmode=longest:full
    set wildmenu            "a menu for resolving ambiguous tab-completion
                            "files we never want to edit
    set wildignore=*.pyc,*.sw[pno],.*.bak,.*.tmp
    set updatetime=1000     "CursorHold (show type) after 1s (down from 4s)

    " Make whitespace characters look nice when shown.
    set listchars=tab:→·,extends:»,precedes:«,nbsp:␠,trail:␠
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
    set modelines=2

    "use jj to escape insert mode
    inoremap jj <ESC>

    "don't clobber the buffer when pasting in visual mode
    vmap P p
    vnoremap p pgvy

    " send any copied lines to the clipboard, too
    vnoremap y y:call SendViaOSC52(getreg('"'))<cr>
    vnoremap <C-c> y:call SendViaOSC52(getreg('"'))<cr>
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
    noremap <c-s-a> <c-a>
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
    set shortmess-=F        "allow for debugging echo

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

    "tab switching: ctrl+pageup/pagedown
    nnoremap <C-PageUp> :tabp<CR>
    nnoremap <C-PageDown> :tabN<CR>
" }

"indentation options {
    set expandtab                       "use spaces, not tabs
    set softtabstop=2 shiftwidth=2      "2-space indents

    set shiftround                      "always use a multiple of 4 for indents
    set smarttab                        "backspace to remove space-indents
    set autoindent                      "auto-indent for code blocks
    "DONT USE: smartindent              "it does stupid things with comments

    " smart indenting by filetype, better than smartindent
    filetype on
    filetype indent on
    filetype plugin on
" }

"extra filetypes {
function! g:RegexFiletype(regex, ft) abort
  if did_filetype()
    return
  endif
  if getline(1) =~# a:regex
    exec "set ft=" . a:ft
  endif
endfunction

augroup extra_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.js.tmpl     set filetype=javascript
    autocmd BufNewFile,BufRead *.css.tmpl    set filetype=css
    autocmd BufNewFile,BufRead *.pxi         set filetype=pyrex
    autocmd BufNewFile,BufRead *.md          set filetype=markdown
    autocmd BufNewFile,BufRead *.proto       set filetype=proto
    autocmd BufNewFile,BufRead *.hcl         set filetype=terraform
    autocmd BufNewFile,BufRead .envrc        set filetype=bash
    autocmd BufNewFile,BufRead *.tfvars      set filetype=terraform
    autocmd BufNewFile,BufRead *.scm         set filetype=lisp
    autocmd BufNewFile,BufRead *.wgsl        set filetype=wgsl

    autocmd BufNewFile,BufRead *    call g:RegexFiletype('\<jq\>', 'jq')

    autocmd FileType go set ts=2
augroup end
" }

" { Finger-savers:
    let mapleader = '\'
    " buffer delete
    nnoremap <Leader>bd :bn \| bd#<CR>
    " goto directory
    nnoremap <Leader>fd :e %:h<CR>
    " chmod executable
    nnoremap <Leader>fx :!set -x; chmod 755 %<CR>
    " paste the filename
    nnoremap <Leader>fp :<C-U>put =expand(v:count ? \"#\" . v:count : \"%\")<CR>
    " git add
    nnoremap <Leader>ga :!git add %<CR>
" }

" { nvim provider opt-out
  " we're not going to use this stuff:
  let g:loaded_perl_provider = 0
  let g:loaded_node_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_python3_provider = 0
" }

" Vim 8 Packages {
    " Load all plugins now.
    " Plugins need to be added to runtimepath before helptags can be generated.
    packloadall
    " Load all of the helptags now, after plugins have been loaded.
    " All messages and errors will be ignored.
    if v:vim_did_enter
      silent! helptags ALL
    else
      au VimEnter * silent! helptags ALL
    endif
" }

hi! link LspReference CursorColumn
hi! link LspReferenceText Search
hi! link LspReferenceRead CurSearch
hi! link LspReferenceWrite IncSearch
hi! link DiagnosticError GruvboxYellow
hi! link DiagnosticWarn GruvboxGreen
hi! link DiagnosticInfo GruvboxBg4
hi! link DiagnosticHint GruvboxBg3
hi! link DiagnosticOk GruvboxBg2
hi! link DiagnosticSignError GruvboxYellowSign
hi! link DiagnosticSignWarn GruvboxGreenSign
hi! link NvimInternalError GruvboxRedBold

" stolen from gruvbox:
let bg1='ctermbg=237 guibg=#3c3836 '
let fg0='ctermfg=229 guifg=#fbf1c7 '
let fg1='ctermfg=223 guifg=#ebdbb2 '
let fg2='ctermfg=250 guifg=#d5c4a1 '
let fg3='ctermfg=248 guifg=#bdae93 '
let fg4='ctermfg=246 guifg=#a89984 '
exec 'hi! DiagnosticSignInfo ' .. fg2 .. bg1
exec 'hi! DiagnosticSignHint ' .. fg3 .. bg1
exec 'hi! DiagnosticSignOk ' .. fg4 .. bg1


" vh: vim highlight
nmap <leader>vhs :call SynStack()<CR>
function! g:SynStack() abort
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <leader>vht :so $VIMRUNTIME/syntax/hitest.vim<CR>


" extra, local settings {
if filereadable($HOME . "/.vimrc.extra")
    source $HOME/.vimrc.extra
endif
if filereadable($HOME . "/private-dotfiles/.vimrc")
    source $HOME/private-dotfiles/.vimrc
endif
" }

" vim:et:sts=2:sw=2
