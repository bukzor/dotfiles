function! bukzor#mason#on_install(info) abort
  MasonUpdate
endfunction

function! bukzor#mason#setup() abort
  lua require("mason").setup()
  "MasonUpdate
endfunction

function! bukzor#mason#wtf() abort
  echom 'WTF, bro!'
endfunction
