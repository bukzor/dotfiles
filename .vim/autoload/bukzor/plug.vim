function! bukzor#plug#bootstrap() abort
  " Install vim-plug if not found
  runtime autoload/plug.vim
  if !exists('g:loaded_plug')
    silent !curl -fsSLo "$HOME"/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
endfunction

" bring actually-installed plugins into sync with config
function! bukzor#plug#sync() abort
  call plug#helptags()
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall
  endif

  let installed = map(split(globpath(g:plug_home, "*/"), "\n"), 'fnamemodify(v:val, ":h:t")')
  if len(filter(installed, "!has_key(g:plugs, v:val)"))
    PlugClean
  endif
endfunction
