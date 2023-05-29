if exists("$VIMtDEBUG")
  set verbose=2
endif

for s:vimfile in split(expand('$HOME/.vimrc.d/*.vim'), '\n')
  exe "source" s:vimfile
endfor

set verbose=0
