"""function! g:VimReset() abort
"""  " get vim back to a blank-slate state, as if we just started
"  set background=dark
"""  highlight clear       " Uses the current value of 'background' to decide which default colors to use.
"""  syntax clear          " The command also deletes the "b:current_syntax" variable
"""  syntax on
"""
"""  """ if exists('lsp#disable')
"""  """   call lsp#disable()
"""  """   call lsp#enable()
"""  """ endif
"""endfunction  # VimReset
"""command! VimReset call g:VimReset()

messages clear

" plugins {
  call bukzor#plug#bootstrap()
  " https://github.com/junegunn/vim-plug#readme
  call plug#begin()
    """ Plug 'prabirshrestha/vim-lsp'
    """ Plug 'mattn/vim-lsp-settings'
    """ " TBD: do we need/want ale?
    """ Plug 'dense-analysis/ale'
    """ Plug 'rhysd/vim-lsp-ale'


    " the only color scheme
    Plug 'morhetz/gruvbox'

    " sensible behavior for zoom (AKA ctrl-w_o, AKA :only)
    Plug 'troydm/zoomwintab.vim'

    "syntaxen
    Plug 'vim-python/python-syntax'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'hashivim/vim-terraform'
    Plug 'puppetlabs/puppet-syntax-vim'

    if has('nvim')
      " https://github.com/williamboman/mason-lspconfig.nvim#vim-plug
      Plug 'williamboman/mason.nvim'
      Plug 'williamboman/mason-lspconfig.nvim'
      Plug 'neovim/nvim-lspconfig'

      " https://github.com/jay-babu/mason-null-ls.nvim#vim-plug
      Plug 'jose-elias-alvarez/null-ls.nvim'
      Plug 'jay-babu/mason-null-ls.nvim'

      " implicit dep of null-ls
      Plug 'nvim-lua/plenary.nvim'
    else
      " :CheckHealth like in nvim
      Plug 'rhysd/vim-healthcheck'
    end

    " migrated from pathogen
    Plug 'ConradIrwin/vim-bracketed-paste'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'will133/vim-dirdiff'
    Plug 'tpope/vim-sensible'
  call plug#end()
  call bukzor#plug#sync()
" } plugins


" display options {
    set synmaxcol=3000      "extra-long lines lose highlighting, for speed
    scriptencoding utf-8
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

    autocmd BufNewFile,BufRead *    call g:RegexFiletype('\<jq\>', 'jq')

    autocmd FileType go set ts=2
augroup end
" }

" tkdiff-like bindings for vimdiff {
    if &diff
        "refresh the diff
        nnoremap R :w\|set nodiff\|set diff<cr>
        "quit, both panes
        nnoremap q :qall<cr>

        "show me the top of the "new" file
        autocmd VimEnter * normal lgg
    endif

    " in case I start diff-mode while editting
    "next diff
    nnoremap gd ]cz.
    "previous diff
    nnoremap gD [cz.
    set diffopt+=iwhiteall
    silent! set diffopt+=hiddenoff
    silent! set diffopt+=algorithm:patience
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

" { from http://www.bestofvim.com/tip/diff-diff/
    nnoremap <Leader>df :call DiffToggle()<CR>

    function! DiffToggle() abort
        if &diff
            diffoff
        else
            diffthis
        endif
    :endfunction

    nnoremap <Leader>dw :call DiffToggleWhitespace()<CR>

    function! DiffToggleWhitespace() abort
       if &diffopt =~ 'iwhiteall'
         set diffopt-=iwhiteall
       else
         set diffopt+=iwhiteall
       endif
    :endfunction
" }

" Vim 8 Packages {
    " Load all plugins now.
    " Plugins need to be added to runtimepath before helptags can be generated.
    packloadall
    " Load all of the helptags now, after plugins have been loaded.
    " All messages and errors will be ignored.
    silent! helptags ALL
" }

if has('nvim')
  lua require("bukzor.unload").unload()
  lua require("bukzor.plugins").setup()
endif

""" " plugin ale-lsp {
"""   let g:lsp_ale_auto_config_ale = v:true
"""   let g:lsp_ale_auto_config_vim_lsp = v:true
"""   let g:lsp_ale_auto_enable_linter = v:true
"""   if exists('lsp#ale#enable') | call lsp#ale#enable() | endif
""" " } ale-lsp
""" 
""" " plugin: ALE {
"""   let g:ale_disable_lsp = 1
"""   let g:ale_use_global_executables = 1
"""   let g:ale_fix_on_save = 1
"""   let g:ale_lint_on_save = 1
"""   let g:ale_lint_delay = 2000
"""   let g:ale_lint_on_enter = 0
"""   let g:ale_lint_on_text_changed = 'always'
"""   let g:ale_virtualenv_dir_names = []
"""   let g:ale_fixers = {
""" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
""" \   'javascript': ['eslint'],
""" \   'python': ['black'],
""" \   'terraform': ['terraform'],
""" \}
"""   "let g:ale_echo_msg_format = '%s (%linter% %code%)1'
"""   "let g:ale_loclist_msg_format = 'wtfbro2%code: %%s (%linter%)'
"""   "let g:ale_lsp_show_message_format = 'wtfbro3%code: %%s (%linter%)'
"""   "let g:ale_virtualtext_prefix = '%type%:'
"""   let g:ale_completion_enabled = 1
"""   let g:ale_completion_delay = 333
"""   " Use ALE's function for omnicompletion.
"""   set omnifunc=ale#completion#OmniFunc
"""   imap <C-Space> <Plug>(ale_complete)
""" 
"""   """ " ALE automatic completion will interfere with default insert completion with
"""   """ " `CTRL-N` and so on (|compl-vim|). You can write your own keybinds and a
"""   """ " function in your |vimrc| file to force insert completion instead, like so: >
"""   """ function! SmartInsertCompletion() abort
"""   """   " Use the default CTRL-N in completion menus
"""   """   if pumvisible()
"""   """     return "\<C-n>"
"""   """   endif
"""   """   " Exit and re-enter insert mode, and use insert completion
"""   """   return "\<C-c>a\<C-n>"
"""   """ endfunction
"""   """ inoremap <silent> <C-n> <C-R>=SmartInsertCompletion()<CR>
""" 
""" " } plugin: ALE

""" " Use Ctrl-j/k to cycle through the suggestions.
""" inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
""" inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
""" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
""" " Force refresh completion.
""" imap <C-space> <Plug>(asyncomplete_force_refresh)

function! g:OnLspBufferEnabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>lr <plug>(lsp-rename)
    nmap <buffer> ge <plug>(lsp-next-diagnostic)
    nmap <buffer> gE <plug>(lsp-previous-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    """ let g:lsp_format_sync_timeout = 1000
    """ autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
    """ TODO:
    """ " Get current document diagnostics information.
    """ nnoremap <Leader>li :LspDocumentDiagnostics<CR>
    """ nnoremap <Leader>lS :LspStatus<CR>
    """ nnoremap <Leader>lpd :LspPeekDefinition<CR>
    """ nnoremap <Leader>lD :LspDeclaration<CR>
    """ nnoremap <Leader>lpD :LspPeekDeclaration<CR>
    """ nnoremap <Leader>lpi :LspPeekImplementation<CR>
    """ " Go to the type definition of the word under the cursor, and open in the current window.
    """ nnoremap <Leader>lt :LspTypeDefinition<CR>
    """ nnoremap <Leader>lpt :LspPeekTypeDefinition<CR>
    """ " View type hierarchy of the symbol under the cursor.
    """ nnoremap <Leader>lT :LspTypeHierarchy<CR>
    """ " Gets a list of possible commands that can be applied to a file so it can be fixed.
    """ nnoremap <Leader>la :LspCodeAction<CR>
    """ nnoremap <Leader>lr :LspReferences<CR>
endfunction
""" augroup lsp_stuff
"""   autocmd!
"""   autocmd BufEnter,CursorHold,InsertLeave lua vim.lsp.codelens.refresh()
"""   autocmd CursorHold  lua vim.lsp.buf.document_highlight()
"""   autocmd CursorHoldI lua vim.lsp.buf.document_highlight()
"""   autocmd CursorMoved lua vim.lsp.buf.clear_references()
"""   autocmd User lsp_buffer_enabled call g:OnLspBufferEnabled()
""" augroup END
""" 
""" 

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
