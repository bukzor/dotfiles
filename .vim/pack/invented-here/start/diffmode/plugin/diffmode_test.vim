if !get(g:, 'config_under_test') | finish | endif  " inert outside test runs

function Test_diffmode_ignores_unrelated_options() abort
  let g:diffmode_test_exits = 0
  augroup diffmode_test
    autocmd User DiffModeExit let g:diffmode_test_exits += 1
  augroup END
  set tabstop=4
  autocmd! diffmode_test
  call assert_equal(0, g:diffmode_test_exits, 'unrelated :set ran DiffModeExit')
endfunction

function Test_diffmode_maps_m_in_diff_mode() abort
  set diff
  call assert_equal(']cz.', maparg('m', 'n'))
  set nodiff
endfunction
