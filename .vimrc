syntax on
colorscheme delek
set background=dark
set guifont=Bitstream\ Vera\ Sans\ Mono\ Bold\ 12

set number
set hlsearch

"simulate 4-space tabbing with spaces
set smarttab
set softtabstop=4
set shiftwidth=4

set autoindent
set smartindent

"quick buffer switching with TAB
map <TAB> :bn<CR>
map <S-TAB> :bp<CR>


au BufReadPost SCons* set syntax=python
