" Vim 8 (compatible) Packages {
    " Ensure our vim packages can be found (even under nvim, lvim, etc.).
    " Skip if an existing entry already resolves to ~/.vim (e.g. nvim's
    " default ~/.config/nvim is a symlink to ~/.vim). Otherwise lazy.nvim
    " flags duplicate packages discovered under both prefixes.
    let s:want = resolve(expand('~/.vim'))
    if index(map(split(&packpath, ','), 'resolve(expand(v:val))'), s:want) < 0
        set packpath+=~/.vim
    endif
    unlet s:want

    " Load all plugins now.
    " Plugins need to be added to runtimepath before helptags can be generated.
    packloadall
    " Load all of the helptags now, after plugins have been loaded.
    " All messages and errors will be ignored.
    if v:vim_did_enter
      " on re-sourcing, eagerly regenerate all tags
      silent! helptags ALL
    else
      " during initial startup, just register a lazy handler
      au VimEnter * silent! helptags
    endif
" }
