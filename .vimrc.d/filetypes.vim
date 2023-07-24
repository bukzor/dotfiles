" teach vim about some new filetypes
function! g:RegexFiletype(regex, ft) abort
  if did_filetype()
    return
  endif
  if getline(1) =~# a:regex
    exec "set ft=" . a:ft
  endif
endfunction

augroup extra_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.js.tmpl     set filetype=javascript
    autocmd BufNewFile,BufRead *.css.tmpl    set filetype=css
    autocmd BufNewFile,BufRead *.pxi         set filetype=pyrex
    autocmd BufNewFile,BufRead *.md          set filetype=markdown
    autocmd BufNewFile,BufRead *.proto       set filetype=proto
    autocmd BufNewFile,BufRead *.hcl         set filetype=terraform
    autocmd BufNewFile,BufRead .envrc        set filetype=bash
    autocmd BufNewFile,BufRead *.tfvars      set filetype=terraform
    autocmd BufNewFile,BufRead *.scm         set filetype=lisp
    autocmd BufNewFile,BufRead *.wgsl        set filetype=wgsl

    autocmd BufNewFile,BufRead *    call g:RegexFiletype('\<jq\>', 'jq')

    autocmd FileType go set ts=2
augroup end
