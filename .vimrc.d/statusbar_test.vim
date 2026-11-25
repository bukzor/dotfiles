if !get(g:, 'config_under_test') | finish | endif  " inert outside test runs
let s:unit = expand('<sfile>:p:h') . '/statusbar.vim'

function Test_statusbar_prefixes_buffer_number() abort
  call assert_match('^%n: ', &statusline)
endfunction

function Test_statusbar_resource_keeps_one_prefix() abort
  execute 'source' fnameescape(s:unit)
  call assert_notmatch('^%n: %n: ', &statusline)
endfunction
