" send any copied lines to the clipboard, too
vnoremap y y:call g:SendViaOSC52(getreg('"'))<cr>
vnoremap <C-c> y:call g:SendViaOSC52(getreg('"'))<cr>
