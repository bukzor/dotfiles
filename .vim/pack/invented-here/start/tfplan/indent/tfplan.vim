" syntax/swift.vim
" Match TODO comments

" PRIORITY                        *:syn-priority*
" 
" When several syntax items may match, these rules are used:
" 
" 1. When multiple Match or Region items start in the same position, the item
"    defined last has priority.
" 2. A Keyword has priority over Match and Region items.
" 3. An item that starts in an earlier position has priority over items that
"    start in later positions.
syntax keyword tfplanUnimportant module <computed> _
syntax match tfplanUnimportant "\v\."
highlight! default link tfplanUnimportant Comment

syntax keyword tfplanUpdate ~ update
" Overridden below iff there's anything notable going on.
syntax match tfplanUpdate "\v      [^ :]+: +\".+\"$"
highlight! default link tfplanUpdate DiffText

syntax keyword tfplanAdd + create
syntax match tfplanAdd "\v      [^ :]+: +\"\" \=\> \".+\"$"
highlight! default link tfplanAdd DiffAdd

syntax keyword tfplanDelete - destroy
syntax match tfplanDelete "\v      [^ :]+: +\".+\" \=\> \"\"$"
highlight! default link tfplanDelete DiffDelete

syntax match tfplanNoop "\v      [^ :]+: +\"(.*)\" \=\> \"\1\"$"
highlight! default link tfplanNoop Comment

syntax keyword tfplanChange -/+
syntax match tfplanChange "\v      [^ :]+: +.+ \(forces new resource\)$"
highlight! default link tfplanChange DiffChange
