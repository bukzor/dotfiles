" ensure that vim-plug is installed.
function! bukzor#plug#bootstrap() abort
  runtime autoload/plug.vim
  if !exists('g:loaded_plug')
    silent !curl -fsSLo "$HOME"/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
endfunction

" force all plugins into configured state, and build their help while we're at it
function! bukzor#plug#sync() abort
    PlugClean
    PlugUpdate
    call plug#helptags()
endfunction
command! PlugSync call bukzor#plug#sync()

" list of installed plugins, according to the filesystem
function! bukzor#plug#get_installed() abort
  return map(split(globpath(g:plug_home, "*/"), "\n"), 'fnamemodify(v:val, ":h:t")')
endfunction

" sync plugins, but only if needed
function! bukzor#plug#lazy_sync() abort
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
\ || len(filter(bukzor#plug#get_installed(), "!has_key(g:plugs, v:val)"))
    PlugSync
  endif
endfunction
