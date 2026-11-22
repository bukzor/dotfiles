" tab completion: more like fish; the default is soooo annoying
set wildmode=longest:full,full  " second tab takes the first candidate
set wildmenu
try
  set wildoptions+=pum  " candidates in a popup menu
catch /^Vim(set):E474:/
  " Vim < 8.2.4325 has no 'pum': wildmenu's one-line menu stands in
endtry
set wildignore=*.pyc,*.sw[pno],.*.bak,.*.tmp
