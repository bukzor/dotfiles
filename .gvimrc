colorscheme murphy

"good window size
set columns=80
set lines=24

if has('gui_win32')
    set guifont=Terminal:h9
else
    set guifont=Bitstream\ Vera\ Sans\ Mono\ Bold\ 11
endif

"numbering
set number

"highlight lines over the width limit
highlight OverLength guibg=#444444
match OverLength /\%81v.\+/

