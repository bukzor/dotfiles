" { Rainbow colored closures for clojure.
"   https://github.com/kien/rainbow_parentheses.vim
if exists(":RainbowParenthesesToggle")
    RainbowParenthesesToggle       " Toggle it on
    RainbowParenthesesLoadRound    " (), the default when toggling
    RainbowParenthesesLoadSquare   " []
    RainbowParenthesesLoadBraces   " {}
    RainbowParenthesesLoadChevrons " <>
endif
" }


" { Clojure syntax
"   https://github.com/guns/vim-clojure-static
    let g:clojure_fuzzy_indent = 1
    let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^fact$']
    let g:clojure_fuzzy_indent_blacklist = ['^with-meta$', '-fn$']
" }
