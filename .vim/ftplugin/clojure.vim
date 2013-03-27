" { Rainbow parens
"	https://github.com/kien/rainbow_parentheses.vim
	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
" }


" { Clojure syntax
"	https://github.com/guns/vim-clojure-static
	let g:clojure_fuzzy_indent = 1
	let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^fact$']
	let g:clojure_fuzzy_indent_blacklist = ['^with-meta$', '-fn$']
" }
