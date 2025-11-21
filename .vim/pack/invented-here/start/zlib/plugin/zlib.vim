" Auto-detect and handle zlib-compressed files
"
" This plugin automatically detects and decompresses zlib-compressed files
" (files starting with 0x78 magic byte). It preserves the compression level
" on write by examining the FLEVEL hint and DEFLATE block type.
"
" Buffer variables set:
"   b:zlibflag - Set to 1 for statusline display (see :help statusline)
"   b:zlib_comp_level - Detected compression level (0-9)
"   b:uncompressOk - Set to 1 if decompression succeeded, 0 if failed

if exists("g:loaded_zlib")
  finish
endif
let g:loaded_zlib = 1

augroup zlib
  autocmd!
  autocmd BufReadPost * call s:detect_zlib()
augroup END

function! s:detect_zlib()
  " Skip if no file
  if expand('%') == ''
    return
  endif

  " Check if file starts with zlib magic byte (CMF=78 = DEFLATE with 32KB window)
  " Read first 3 bytes as raw binary from file
  let header_blob = readblob(expand('%'), 0, 3)
  if len(header_blob) < 3
    return
  endif

  if header_blob[0] != 0x78
    return
  endif

  " Check for zlib-flate availability
  if !executable('zlib-flate')
    echohl WarningMsg
    echomsg "zlib.vim: zlib-flate not found in PATH"
    echohl None
    return
  endif

  " Detect compression level from header and payload before decompression
  let flg = header_blob[1]
  let deflate_byte = header_blob[2]
  call s:detect_compression_level(flg, deflate_byte)

  " Try to decompress - zlib-flate will validate the header
  let decompressed_str = system('zlib-flate -uncompress < ' . shellescape(expand('%:p')))

  if v:shell_error == 0
    " Decompression succeeded
    " Check if data ends with newline to set eol correctly
    let &l:eol = !empty(decompressed_str) && (decompressed_str[-1:] == "\n")

    " Convert to list format for setline
    " Don't use split(..., 1) because trailing newline creates unwanted empty element
    let decompressed = split(decompressed_str, "\n")

    " Set binary mode and prevent vim from modifying line endings
    setlocal bin nofixeol

    " Replace buffer content with decompressed data
    silent! %delete _
    call setline(1, decompressed)
    setlocal nomodified

    let b:zlibflag = 1
    let b:uncompressOk = 1

    " Set up buffer-local write handlers in dedicated augroup
    augroup zlib_buffer
      autocmd! * <buffer>
      autocmd BufWriteCmd <buffer> call s:write_zlib()
    augroup END

    " Use silent echo to avoid modal prompt during BufReadPost
    silent! echo ""
    redraw
    echomsg "zlib: decompressed"
  else
    " Decompression failed
    let b:uncompressOk = 0
    echoerr "zlib: failed to decompress"
  endif
endfunction

function! s:detect_compression_level(flg, deflate_byte)
  " Decode zlib compression level from header bytes
  " FLG byte bits 6-7 encode FLEVEL (compression level hint):
  "   FLEVEL 0 (bits 00) → levels 0-1
  "   FLEVEL 1 (bits 01) → levels 2-5
  "   FLEVEL 2 (bits 10) → level 6
  "   FLEVEL 3 (bits 11) → levels 7-9
  "
  " For FLEVEL 0, check DEFLATE block type (bits 1-2 of deflate_byte):
  "   BTYPE 00 (stored) → level 0
  "   BTYPE 01/10 (compressed) → level 1

  let flevel = and(a:flg, 0xC0) / 64

  if flevel == 0
    " Check DEFLATE block type to distinguish level 0 vs 1
    let btype = and(a:deflate_byte, 0x06) / 2
    if btype == 0
      " Stored block (uncompressed)
      let b:zlib_comp_level = 0
    else
      " Compressed block
      let b:zlib_comp_level = 1
    endif
  elseif flevel == 1
    let b:zlib_comp_level = 5
  elseif flevel == 2
    let b:zlib_comp_level = 6
  else
    " flevel == 3
    let b:zlib_comp_level = 9
  endif
endfunction

function! s:write_zlib()
  if !exists('b:uncompressOk') || !b:uncompressOk
    return
  endif

  " Get buffer content as list (same format as readfile/systemlist with 'b')
  let lines = getline(1, '$')

  if &l:eol
    call add(lines, '')
  endif

  " Compress using systemlist() to get binary-compatible list
  let level = exists('b:zlib_comp_level') ? b:zlib_comp_level : 6
  let compressed = systemlist('zlib-flate -compress=' . level, lines)

  if v:shell_error == 0
    " Write compressed data to file using 'b' flag for binary mode
    call writefile(compressed, expand('<afile>:p'), 'b')
    setlocal nomodified

    " Display write confirmation like normal :write
    let filename = expand('<afile>:t')
    let noeol_flag = &l:eol ? '' : ' [noeol]'
    let line_count = line('$')
    let line_word = 'L'
    let byte_count = line2byte(line('$') + 1) - 1
    echomsg printf('"%s" [zlib]%s %d%s, %dB written', filename, noeol_flag, line_count, line_word, byte_count)
  else
    echoerr "zlib: failed to compress"
  endif
endfunction
