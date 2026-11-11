" host-local settings, kept outside this repo; sorts last so it can override
for s:extra in [expand('~/.vimrc.extra'), expand('~/private-dotfiles/.vimrc')]
  if filereadable(s:extra) | exe 'source' fnameescape(s:extra) | endif
endfor
unlet! s:extra
