" Run every Test_* function the config defined, then exit: 1 on any failure,
" each failure naming its test function and line. Test files (*_test.vim,
" beside their unit) load inert unless g:config_under_test is set before
" startup; bin/vim-config-test does that.
function! s:Run() abort
  " errors the user would see; not v:errmsg, which silent! errors also set
  let load_errors = filter(split(execute('messages'), "\n"), {_, l -> l =~# '^E\d\+:\|^Error '})
  call assert_equal([], load_errors, 'errors while loading config')
  let tests = map(getcompletion('Test_', 'function'), {_, f -> trim(f, '()', 2)})
  call assert_notequal([], tests, 'no Test_* functions loaded: nothing was tested')
  for t in tests
    try
      call call(t, [])
    catch
      call add(v:errors, t . ': ' . v:exception . ' @ ' . v:throwpoint)
    endtry
  endfor
  call writefile(v:errors, '/dev/stderr', 'a')
  execute empty(v:errors) ? 'qa!' : 'cquit!'
endfunction
" after startup, so OptionSet and friends fire; ++nested lets the tests'
" autocmds fire inside this one
autocmd VimEnter * ++once ++nested call s:Run()
