" Retrieved 2019-12-15 by Buck Evan, from:
"   https://github.com/chromium/hterm/blob/master/etc/osc52.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
" Use of this source code is governed by a BSD-style license that can be
" found in the LICENSE file.

"
" This script can be used to send an arbitrary string to the terminal clipboard
" using the OSC 52 escape sequence, as specified in
" http://invisible-island.net/xterm/ctlseqs/ctlseqs.html, section "Operating
" System Controls", Ps => 52.
"
" To add this script to vim...
"  1. Save it somewhere.
"  2. Edit ~/.vimrc to include...
"       source ~/path/to/osc52.vim
"       vmap <C-c> y:call SendViaOSC52(getreg('"'))<cr>
"
" This will map Ctrl-C to copy.  You can now select text in vi using the visual
" mark mode or the mouse, and press Ctrl-C to copy it to the clipboard.
"

" Max length of the OSC 52 sequence.  Sequences longer than this will not be
" sent to the terminal.
let g:max_osc52_sequence=100000

" Send a string to the terminal's clipboard using the OSC 52 sequence.
function! g:SendViaOSC52 (str)
  let len = strlen(a:str)
  if len > g:max_osc52_sequence
    echo "Selection too long to send to terminal: " . len
    return 1
  endif

  let osc52 = OSC52_get(a:str)

  let len = strlen(osc52)
  if len <= g:max_osc52_sequence
    call g:Rawecho(osc52)
  else
    echo "Selection too long to send to terminal: " . len
  endif
endfunction

" This function base64's the entire string and wraps it in a single OSC52.
"
" It's appropriate when running in a raw terminal that supports OSC 52.
function! g:OSC52_get (str)
  let b64 = s:b64encode(a:str, 0)
  let rv = "\e]52;c;" . b64 . "\x07"
  return rv
endfunction
" Echo a string to the terminal without munging the escape sequences.
function! g:Rawecho (str)
  call writefile([a:str], '/dev/fd/2', 'b')
endfunction

" Lookup table for s:b64encode.
let s:b64_table = [
      \ "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
      \ "Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f",
      \ "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v",
      \ "w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"]

" Encode a string of bytes in base 64.
" Based on http://vim-soko.googlecode.com/svn-history/r405/trunk/vimfiles/
" autoload/base64.vim
" If size is > 0 the output will be line wrapped every `size` chars.
function! s:b64encode(str, size)
  let bytes = g:Str2bytes(a:str)
  let b64 = []

  for i in range(0, len(bytes) - 1, 3)
    let n = bytes[i] * 0x10000
          \ + get(bytes, i + 1, 0) * 0x100
          \ + get(bytes, i + 2, 0)
    call add(b64, s:b64_table[n / 0x40000])
    call add(b64, s:b64_table[n / 0x1000 % 0x40])
    call add(b64, s:b64_table[n / 0x40 % 0x40])
    call add(b64, s:b64_table[n % 0x40])
  endfor

  if len(bytes) % 3 == 1
    let b64[-1] = '='
    let b64[-2] = '='
  endif

  if len(bytes) % 3 == 2
    let b64[-1] = '='
  endif

  let b64 = join(b64, '')
  if a:size <= 0
    return b64
  endif

  let chunked = ''
  while strlen(b64) > 0
    let chunked .= strpart(b64, 0, a:size) . "\n"
    let b64 = strpart(b64, a:size)
  endwhile
  return chunked
endfunction

function! g:Str2bytes(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction
