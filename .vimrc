syntax on
colorscheme evening

set hlsearch
set incsearch

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
"let me tab, even with edits
set hidden

"make folds open and close like 'aptitude'
map [ zo
map ] zc

"make up and down work like a normal editor
map j gj
map k gk

"scons files are written in python
au BufReadPost SCons* set syntax=python

"python files shouldn't use tabs
au BufReadPost *.py set expandtab|retab

