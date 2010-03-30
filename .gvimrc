colorscheme murphy

"good window size
set columns=132
set lines=36

if has('gui_win32')
    set guifont=Terminal:h9
else
    set guifont=Bitstream\ Vera\ Sans\ Mono\ Bold\ 12
endif

"numbering
set number

"highlight lines over the width limit
highlight OverLength guibg=#444444
match OverLength /\%81v.\+/

