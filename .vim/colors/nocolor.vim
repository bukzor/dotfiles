" Vim syntax file
" Language:	none; used to see highlighting
" Maintainer:	Ronald Schild <rs@scutum.de>
" Last Change:	2001 Sep 02
" Version:	5.4n.1

" To see your current highlight settings, do
"    :so $VIMRUNTIME/syntax/hitest.vim

" save global options and registers
let s:register_a  = @a
let s:register_se = @/


" print current highlight settings into register a
redir @a
silent highlight
redir END


let s:hlgroups = split(substitute(@a,'^[ \t\n]*','',''), "\\v [^\n]*(\n|$)*")
for s:hlgroup in s:hlgroups
    if s:hlgroup == ''
        continue
    endif
    "execute 'highlight clear' s:hlgroup
    execute 'highlight' s:hlgroup 'NONE'
endfor

let g:colors_name = expand("<sfile>:t:r")

" restore global options and registers
let @a		 = s:register_a

" restore last search pattern
let @/ = s:register_se

" remove variables
unlet s:register_a s:register_se s:hlgroups s:hlgroup

" vim: ts=8
