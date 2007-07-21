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

"disable capslock
lnoremap a A
lnoremap b B
lnoremap c C
lnoremap d D
lnoremap e E
lnoremap f F
lnoremap g G
lnoremap h H
lnoremap i I
lnoremap j J
lnoremap k K
lnoremap l L
lnoremap m M
lnoremap n N
lnoremap o O
lnoremap p P
lnoremap q Q
lnoremap r R
lnoremap s S
lnoremap t T
lnoremap u U
lnoremap v V
lnoremap w W
lnoremap x X
lnoremap y Y
lnoremap z Z

lnoremap A a
lnoremap B b
lnoremap C c
lnoremap D d
lnoremap E e
lnoremap F f
lnoremap G g
lnoremap H h
lnoremap I i
lnoremap J j
lnoremap K k
lnoremap L l
lnoremap M m
lnoremap N n
lnoremap O o
lnoremap P p
lnoremap Q q
lnoremap R r
lnoremap S s
lnoremap T t
lnoremap U u
lnoremap V v
lnoremap W w
lnoremap X x
lnoremap Y y
lnoremap Z z 
