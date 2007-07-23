syntax on
set background=dark
colorscheme delek
hi Normal ctermfg=white ctermbg=black
set guifont=Bitstream\ Vera\ Sans\ Mono\ Bold\ 12

set number
set hlsearch

"simulate 4-space tabbing with spaces
set smarttab
set tabstop=8 "default
set softtabstop=4
set shiftwidth=4

"smart indenting for python and C
set autoindent
set smartindent

"prevents comments from always starting on first row
inoremap # X#
"fix backspacing
set backspace=indent,eol,start

"make registers more accessible
map ; "

"quick buffer switching with TAB
map <TAB> :bn<CR>
map <S-TAB> :bp<CR>

"make folds open and close like 'aptitude'
map [ zo
map ] zc

"make up and down work like a normal editor
map j gj
map k gk

"save foldings automatically, suppress errors
au BufWinLeave,BufWrite * silent! mkview
au BufWinEnter * silent! loadview

"scons files are written in python
au BufReadPost SCons* set syntax=python

"python files shouldn't use tabs
au BufReadPost *.py set expandtab|retab

