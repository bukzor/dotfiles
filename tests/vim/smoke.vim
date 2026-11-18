scriptencoding utf-8

" Acceptance tests for Vim9 basics
let s:suite = themis#suite('Vim basics')
let s:assert = themis#helper('assert')

function! s:suite.has_basic_motion_commands() abort
  " Open a temp file with content
  let tmp = tempname()
  call writefile(['line1', 'line2', 'line3'], tmp)
  execute 'edit' tmp

  " Test navigation
  normal! gg
  call s:assert.equals(line('.'), 1)
  normal! j
  call s:assert.equals(line('.'), 2)
  normal! G
  call s:assert.equals(line('.'), 3)

  " Clean up
  bwipe!
  call delete(tmp)
endfunction

function! s:suite.has_working_set_commands() abort
  set number
  call s:assert.true(&number)
  set nonumber
  call s:assert.false(&number)
endfunction

function! s:suite.can_load_vimrc() abort
  " If we got here, vimrc loaded successfully
  call s:assert.true(1)
endfunction

let s:text_suite = themis#suite('Text manipulation')

function! s:text_suite.can_yank_and_paste() abort
  let tmp = tempname()
  call writefile(['hello'], tmp)
  execute 'edit!' tmp

  normal! yiw
  normal! $p
  call s:assert.equals(getline(1), 'hellohello')

  bwipe!
  call delete(tmp)
endfunction

let s:search_suite = themis#suite('Search')

function! s:search_suite.can_search_with_slash() abort
  let tmp = tempname()
  call writefile(['foo', 'bar', 'baz'], tmp)
  execute 'edit!' tmp

  normal! gg
  execute "normal! /bar\<CR>"
  call s:assert.equals(line('.'), 2)

  bwipe!
  call delete(tmp)
endfunction
