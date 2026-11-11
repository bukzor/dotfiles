" debugging helpers: commands only, nothing runs until invoked

" get vim back to a blank-slate state, as if we just started
command! -bar VimReset call s:VimReset()
function! s:VimReset() abort
  messages clear
  set background=dark
  highlight clear  " uses the current 'background' to pick default colors
  syntax clear     " also deletes b:current_syntax
  syntax on
endfunction

" log every autocmd event (and its <amatch>) to ./vim-event.log
command! -bar LogAllEvents call s:LogAllEvents()
function! s:LogAllEvents() abort
  call writefile(["START"], 'vim-event.log', "")
  function! LogEvent(event) abort
    try
      let l:match = expand('<amatch>')
    catch
      let l:match = '(expand failed)'
    endtry
    call writefile([a:event . ": " . l:match], 'vim-event.log', "a")
  endfunction

  augroup ShowAllEvents
    autocmd!
    let skip_events = ['SourcePre', 'SourcePost']  " too noisy
    for event in getcompletion('', 'event')
      if index(skip_events, event) == -1 && event !~# 'Cmd$'
        execute 'autocmd' event '* call LogEvent("' . event . '")'
      endif
    endfor
  augroup END

  echom "event logging activated; see vim-event.log"
endfunction
