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
set cindent

au BufReadPost SCons* set syntax=python
