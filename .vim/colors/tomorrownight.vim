" Tomorrow Night - Full Colour
" http://chriskempson.com
"
" mangled by bukzor, to work gracefully with CSApprox in 88 colors

" Default GUI Colours
let s:foreground = "c5c8c6"
let s:background = "1d1f21"
let s:selection = "585858"
let s:line = "282a2e"
let s:comment = "969896"
let s:red = "cc6666"
let s:orange = "de935f"
let s:yellow = "f0c674"
let s:green = "b5bd68"
let s:aqua = "8abeb7"
let s:blue = "81a2be"
let s:purple = "b294bb"
let s:window = "4d5057"

set background=light
hi clear
syntax reset

let g:colors_name = "tomorrownight"

" Sets the highlighting for the given group
fun <SID>X(group, fg, bg, attr)
    if a:fg == "none"
        exec "hi" a:group "guifg=NONE"
    elseif a:fg != ""
        exec "hi" a:group "guifg=#" . a:fg
    endif
    if a:bg == "none"
        exec "hi" a:group "guibg=NONE"
    elseif a:bg != ""
        exec "hi" a:group "guibg=#" . a:bg
    endif
    if a:attr != ""
        exec "hi" a:group "gui=" . a:attr
    endif
endfun

" Vim Highlighting
call <SID>X("Normal", s:foreground, s:background, "")
call <SID>X("LineNr", s:selection, "", "")
call <SID>X("NonText", s:selection, "", "")
call <SID>X("SpecialKey", s:selection, "", "")
call <SID>X("Search", "none", "none", "reverse")
call <SID>X("TabLine", s:foreground, s:background, "reverse")
call <SID>X("StatusLine", s:window, s:yellow, "reverse")
call <SID>X("StatusLineNC", s:window, s:foreground, "reverse")
call <SID>X("VertSplit", s:window, s:window, "")
call <SID>X("Visual", "", s:selection, "")
call <SID>X("Directory", s:blue, "", "")
call <SID>X("ModeMsg", s:green, "", "")
call <SID>X("MoreMsg", s:green, "", "")
call <SID>X("Question", s:green, "", "")
call <SID>X("WarningMsg", s:red, "", "")
call <SID>X("MatchParen", "", s:selection, "")
call <SID>X("Folded", s:comment, s:background, "")
call <SID>X("FoldColumn", "", s:background, "")
call <SID>X("CursorLine", "", s:line, "")
call <SID>X("CursorColumn", "", s:line, "")
call <SID>X("PMenu", s:foreground, s:selection, "")
call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
call <SID>X("SignColumn", "", s:background, "none")
call <SID>X("ColorColumn", "", s:line, "")

" Standard Highlighting
call <SID>X("Comment", s:comment, "", "")
call <SID>X("Todo", s:comment, s:background, "")
call <SID>X("Title", s:comment, "", "")
call <SID>X("Identifier", s:red, "", "none")
call <SID>X("Statement", s:foreground, "", "")
call <SID>X("Conditional", s:foreground, "", "")
call <SID>X("Repeat", s:foreground, "", "")
call <SID>X("Structure", s:purple, "", "")
call <SID>X("Function", s:blue, "", "")
call <SID>X("Constant", s:orange, "", "")
call <SID>X("String", s:green, "", "")
call <SID>X("Special", s:foreground, "", "")
call <SID>X("PreProc", s:purple, "", "")
call <SID>X("Operator", s:aqua, "", "none")
call <SID>X("Type", s:blue, "", "none")
call <SID>X("Define", s:purple, "", "none")
call <SID>X("Include", s:blue, "", "")
"call <SID>X("Ignore", "666666", "", "")

" Vim Highlighting
call <SID>X("vimCommand", s:red, "", "none")

" C Highlighting
call <SID>X("cType", s:yellow, "", "")
call <SID>X("cStorageClass", s:purple, "", "")
call <SID>X("cConditional", s:purple, "", "")
call <SID>X("cRepeat", s:purple, "", "")

" PHP Highlighting
call <SID>X("phpVarSelector", s:red, "", "")
call <SID>X("phpKeyword", s:purple, "", "")
call <SID>X("phpRepeat", s:purple, "", "")
call <SID>X("phpConditional", s:purple, "", "")
call <SID>X("phpStatement", s:purple, "", "")
call <SID>X("phpMemberSelector", s:foreground, "", "")

" Ruby Highlighting
call <SID>X("rubySymbol", s:green, "", "")
call <SID>X("rubyConstant", s:yellow, "", "")
call <SID>X("rubyAttribute", s:blue, "", "")
call <SID>X("rubyInclude", s:blue, "", "")
call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
call <SID>X("rubyCurlyBlock", s:orange, "", "")
call <SID>X("rubyStringDelimiter", s:green, "", "")
call <SID>X("rubyInterpolationDelimiter", s:orange, "", "")
call <SID>X("rubyConditional", s:purple, "", "")
call <SID>X("rubyRepeat", s:purple, "", "")

" Python Highlighting
call <SID>X("pythonInclude", s:purple, "", "")
call <SID>X("pythonStatement", s:purple, "", "")
call <SID>X("pythonConditional", s:purple, "", "")
call <SID>X("pythonRepeat", s:purple, "", "")
call <SID>X("pythonException", s:purple, "", "")
call <SID>X("pythonFunction", s:blue, "", "")

" Go Highlighting
call <SID>X("goStatement", s:purple, "", "")
call <SID>X("goConditional", s:purple, "", "")
call <SID>X("goRepeat", s:purple, "", "")
call <SID>X("goException", s:purple, "", "")
call <SID>X("goDeclaration", s:blue, "", "")
call <SID>X("goConstants", s:yellow, "", "")
call <SID>X("goBuiltins", s:orange, "", "")

" CoffeeScript Highlighting
call <SID>X("coffeeKeyword", s:purple, "", "")
call <SID>X("coffeeConditional", s:purple, "", "")

" JavaScript Highlighting
call <SID>X("javaScriptBraces", s:foreground, "", "")
call <SID>X("javaScriptFunction", s:purple, "", "")
call <SID>X("javaScriptConditional", s:purple, "", "")
call <SID>X("javaScriptRepeat", s:purple, "", "")
call <SID>X("javaScriptNumber", s:orange, "", "")
call <SID>X("javaScriptMember", s:orange, "", "")

" HTML Highlighting
call <SID>X("htmlTag", s:red, "", "")
call <SID>X("htmlTagName", s:red, "", "")
call <SID>X("htmlArg", s:red, "", "")
call <SID>X("htmlScriptTag", s:red, "", "")

" Diff Highlighting
let s:diffbackground = "494e56"

call <SID>X("diffAdded", s:green, "", "")
call <SID>X("diffRemoved", s:red, "", "")
call <SID>X("DiffAdd", s:green, s:diffbackground, "")
call <SID>X("DiffDelete", s:red, s:diffbackground, "")
call <SID>X("DiffChange", s:yellow, s:diffbackground, "")
call <SID>X("DiffText", s:diffbackground, s:orange, "")

" ShowMarks Highlighting
call <SID>X("ShowMarksHLl", s:orange, s:background, "none")
call <SID>X("ShowMarksHLo", s:purple, s:background, "none")
call <SID>X("ShowMarksHLu", s:yellow, s:background, "none")
call <SID>X("ShowMarksHLm", s:aqua, s:background, "none")

" Delete Functions
delf <SID>X
