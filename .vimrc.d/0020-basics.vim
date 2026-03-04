" the bare basics
set background=dark
try
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185:/ " catch error E123
  colorscheme desert
endtry

set number
set norelativenumber
set wrap                "wrap long lines

" columns
set colorcolumn+=+1,+2  "visual inidicator of maximum column

" show some whitespace characters, and make them look nice
set list
set listchars=tab:→·,extends:»,precedes:«,nbsp:␠,trail:␠

" cross-language defaults
set et sw=2 sts=2 sr  " two-space indents
