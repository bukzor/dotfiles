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
"prevents comments from always starting on first row
inoremap # X#

set autoindent
set smartindent

"quick buffer switching with TAB
map <TAB> :bn<CR>
map <S-TAB> :bp<CR>

"save foldings
au BufWinLeave * mkview
au BufWinEnter * silent loadview

"scons files are written in python
au BufReadPost SCons* set syntax=python
