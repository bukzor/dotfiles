" VSCode owns popup menus; aunmenu/noremenu will error
if exists('g:vscode') | finish | endif

""" vim_diff.txt
" Nvim creates the following default mappings at |startup|. You can disable any
" of these in your config by simply removing the mapping, e.g. ":unmap Y".
nnoremap Y y$
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
xnoremap * y/\V<C-R>"<CR>
xnoremap # y?\V<C-R>"<CR>
nnoremap & :&&<CR>

" nvim_terminal  BufReadCmd
"     term://*  if !exists('b:term_title')|call termopen(matchstr(expand("<amatch>"), '\c\mterm://\%(.\{-}//\%(\d\+:\)\?\)\?\zs.*'), {'cwd': expand(get(matchlist(expand("<amatch>"), '\c\mterm://\(.\{-}\)//'), 1, ''))})
"
" nvim_cmdwin  CmdWinEnter
"     [:>]      syntax sync minlines=1 maxlines=1


aunmenu PopUp
vnoremenu PopUp.Cut                         "+x
vnoremenu PopUp.Copy                        "+y
anoremenu PopUp.Paste                       "+gP
vnoremenu PopUp.Paste                       "+P
vnoremenu PopUp.Delete                      "_x
nnoremenu PopUp.Select\ All                 ggVG
vnoremenu PopUp.Select\ All                 gg0oG$
inoremenu PopUp.Select\ All                 <C-Home><C-O>VG
anoremenu PopUp.-1-                         <Nop>
anoremenu PopUp.How-to\ disable\ mouse      <Cmd>help disable-mouse<CR>
