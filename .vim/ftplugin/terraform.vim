" Copyright 2017 Google Inc. All rights reserved.
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.


" let s:plugin = maktaba#plugin#Get('codefmt')


""
" @private
" Formatter: hclfmt
function! s:get_formatter() abort
  let l:formatter = {
      \ 'name': 'hclfmt',
      \ 'setup_instructions': 'Install hclfmt.'}

  function l:formatter.IsAvailable() abort
    return executable('hclfmt')
  endfunction

  function l:formatter.AppliesToBuffer() abort
    return &filetype is# 'terraform'
  endfunction

  ""
  " Reformat the current buffer with hclfmt, only targeting the range between
  " {startline} and {endline}.
  " @throws ShellError
  function l:formatter.Format() abort
    let l:lines = getline(1, line('$'))
    let l:input = join(l:lines, "\n")
    let l:result = maktaba#syscall#Create(['hclfmt']).WithStdin(l:input).Call(0)
    if v:shell_error == 1 " Indicates an error with parsing
      call maktaba#error#Shout('Error formatting file: %s', l:result.stderr)
      return
    endif
    let l:formatted = split(l:result.stdout, "\n")

    call maktaba#buffer#Overwrite(1, line('$'), l:formatted)
  endfunction

  return l:formatter
endfunction


" let s:codefmt_registry = maktaba#extension#GetRegistry('codefmt')
" call s:codefmt_registry.AddExtension(s:get_formatter())

" autocmd FileType terraform AutoFormatBuffer hclfmt
