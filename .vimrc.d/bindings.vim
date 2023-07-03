" responsiveness: make it worse, so that i can find and fix it
set timeout
set timeoutlen=5
set ttimeoutlen=0



" LSP key-bindings { 
  nmap gd :LspDefinition<CR>
" } LSP key-bindings


" send any copied lines to the clipboard, too
vnoremap y y:call g:SendViaOSC52(getreg('"'))<cr>
vnoremap <C-c> y:call g:SendViaOSC52(getreg('"'))<cr>
