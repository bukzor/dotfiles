" This scheme was created by CSApproxSnapshot
" on Mon, 23 Jan 2012

syntax on
let syntax_cmd="skip"
highlight clear

let g:colors_name = expand("<sfile>:t:r")
function! s:CSAhi(group, ...)
    exe "hi clear" a:group
    let hi = join(a:000, " ")
    if v:version < 700
        let hi = substitute(substitute(hi, "undercurl", "underline", "g"), "guisp=\\S\\+", "", "g")
    endif
    exe "hi" a:group hi
endfunction
command! -nargs=+ CSAhi call s:CSAhi(<f-args>)

function! s:CSAlink(from, to)
    exe "hi clear" a:from
    exe "hi! link" a:from a:to
endfunction
command! -nargs=+ CSAlink call s:CSAlink(<f-args>)

function! s:old_kde()
  " Konsole only used its own palette up til KDE 4.2.0
  if executable('kde4-config') && system('kde4-config --kde-version') =~ '^4.[10].'
    return 1
  elseif executable('kde-config') && system('kde-config --version') =~# 'KDE: 3.'
    return 1
  else
    return 0
  endif
endfunction

if has("gui_running") || &t_Co == 256
    CSAhi Normal ctermbg=16 ctermfg=230 guibg=black guifg=#f6f3e8
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=244 guifg=#7C7C7C
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional ctermfg=68 guifg=#6699CC
      CSAlink htmlTagName Conditional
      CSAlink xmlTagName Conditional
    CSAhi Constant term=underline ctermfg=114 guifg=#99CC99
      CSAlink Boolean Constant
      CSAlink Character Constant
    CSAhi Cursor ctermbg=231 ctermfg=16 guibg=white guifg=black
    CSAhi CursorColumn term=reverse ctermbg=233 guibg=#121212
    CSAhi CursorLine term=underline ctermbg=233 guibg=#121212
    CSAhi Delimiter ctermfg=37 guifg=#00A0A0
    CSAhi DiffAdd term=bold ctermbg=18 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=90 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse cterm=undercurl ctermfg=203 gui=undercurl guisp=#FF6C60
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=203 ctermfg=231 gui=bold guibg=#FF6C60 guifg=white
    CSAhi FoldColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Folded term=standout ctermbg=59 ctermfg=145 guibg=#384048 guifg=#a0a8b0
    CSAhi Function ctermfg=223 guifg=#FFD2A7
    CSAhi Identifier term=underline ctermfg=189 guifg=#C6C5FE
      CSAlink htmlEndTag Identifier
      CSAlink javaScopeDecl Identifier
      CSAlink rubyClassVariable Identifier
      CSAlink rubyGlobalVariable Identifier
      CSAlink rubyIdentifier Identifier
      CSAlink rubyInstanceVariable Identifier
      CSAlink xmlEndTag Identifier
    CSAhi Ignore ctermfg=16 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Keyword ctermfg=117 guifg=#96CBFE
      CSAlink csXmlTag Keyword
      CSAlink htmlTag Keyword
      CSAlink rubyClass Keyword
      CSAlink rubyKeyword Keyword
      CSAlink rubyModule Keyword
      CSAlink xmlTag Keyword
    CSAhi LineNr term=underline ctermbg=16 ctermfg=237 guibg=black guifg=#3D3D3D
    CSAhi MatchParen term=reverse cterm=bold ctermbg=101 ctermfg=230 gui=bold guibg=#857b6f guifg=#f6f3e8
    CSAhi ModeMsg term=bold cterm=bold ctermbg=189 ctermfg=16 gui=bold guibg=#C6C5FE guifg=black
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold ctermbg=16 ctermfg=232 guibg=black guifg=#070707
    CSAhi Number ctermfg=207 guifg=#FF73FD
      CSAlink Float Number
      CSAlink javaScriptNumber Number
    CSAhi Operator ctermfg=68 guifg=#6699CC
      CSAlink rubyOperator Operator
    CSAhi Pmenu ctermbg=238 ctermfg=230 guibg=#444444 guifg=#f6f3e8
    CSAhi PmenuSbar ctermbg=231 ctermfg=16 guibg=white guifg=black
    CSAhi PmenuSel ctermbg=186 ctermfg=16 guibg=#cae682 guifg=#000000
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=117 guifg=#96CBFE
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse cterm=underline gui=underline
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=173 guifg=#E18964
      CSAlink Debug Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermbg=236 ctermfg=244 guibg=#343434 guifg=#808080
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=68 guifg=#6699CC
      CSAlink Exception Statement
      CSAlink Label Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=underline ctermbg=234 ctermfg=252 gui=italic guibg=#202020 guifg=#CCCCCC
    CSAhi StatusLineNC term=reverse ctermbg=234 ctermfg=16 guibg=#202020 guifg=black
    CSAhi String ctermfg=155 guifg=#A8FF60
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=230 gui=bold guifg=#f6f3e8
    CSAhi Todo term=standout ctermfg=245 guifg=#8f8f8f
    CSAhi Type term=underline ctermfg=229 guifg=#FFFFB6
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
      CSAlink rubyConstant Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=234 ctermfg=234 guibg=#202020 guifg=#202020
    CSAhi Visual term=reverse ctermbg=17 guibg=#262D51
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermbg=203 ctermfg=231 gui=bold guibg=#FF6C60 guifg=white
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=46 guibg=yellow guifg=green
    CSAhi javaDocSeeTag ctermfg=252 guifg=#CCCCCC
      CSAlink javaCommentTitle javaDocSeeTag
      CSAlink javaDocParam javaDocSeeTag
      CSAlink javaDocSeeTagParam javaDocSeeTag
      CSAlink javaDocTags javaDocSeeTag
    CSAhi lCursor ctermbg=230 ctermfg=16 guibg=fg guifg=bg
    CSAhi pythonSpaceError ctermbg=196 guibg=red
    CSAhi rubyControl ctermfg=68 guifg=#6699CC
    CSAhi rubyEscape ctermfg=231 guifg=white
    CSAhi rubyInterpolationDelimiter ctermfg=37 guifg=#00A0A0
    CSAhi rubyRegexp ctermfg=137 guifg=#B18A3D
    CSAhi rubyRegexpDelimiter ctermfg=208 guifg=#FF8000
    CSAhi rubyStringDelimiter ctermfg=59 guifg=#336633

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=16 ctermfg=79 guibg=black guifg=#f6f3e8
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=82 guifg=#7C7C7C
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional ctermfg=38 guifg=#6699CC
      CSAlink htmlTagName Conditional
      CSAlink xmlTagName Conditional
    CSAhi Constant term=underline ctermfg=41 guifg=#99CC99
      CSAlink Boolean Constant
      CSAlink Character Constant
    CSAhi Cursor ctermbg=79 ctermfg=16 guibg=white guifg=black
    CSAhi CursorColumn term=reverse ctermbg=16 guibg=#121212
    CSAhi CursorLine term=underline ctermbg=16 guibg=#121212
    CSAhi Delimiter ctermfg=21 guifg=#00A0A0
    CSAhi DiffAdd term=bold ctermbg=17 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=33 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse cterm=undercurl ctermfg=69 gui=undercurl guisp=#FF6C60
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=69 ctermfg=79 gui=bold guibg=#FF6C60 guifg=white
    CSAhi FoldColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Folded term=standout ctermbg=17 ctermfg=38 guibg=#384048 guifg=#a0a8b0
    CSAhi Function ctermfg=73 guifg=#FFD2A7
    CSAhi Identifier term=underline ctermfg=59 guifg=#C6C5FE
      CSAlink htmlEndTag Identifier
      CSAlink javaScopeDecl Identifier
      CSAlink rubyClassVariable Identifier
      CSAlink rubyGlobalVariable Identifier
      CSAlink rubyIdentifier Identifier
      CSAlink rubyInstanceVariable Identifier
      CSAlink xmlEndTag Identifier
    CSAhi Ignore ctermfg=16 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Keyword ctermfg=43 guifg=#96CBFE
      CSAlink csXmlTag Keyword
      CSAlink htmlTag Keyword
      CSAlink rubyClass Keyword
      CSAlink rubyKeyword Keyword
      CSAlink rubyModule Keyword
      CSAlink xmlTag Keyword
    CSAhi LineNr term=underline ctermbg=16 ctermfg=80 guibg=black guifg=#3D3D3D
    CSAhi MatchParen term=reverse cterm=bold ctermbg=37 ctermfg=79 gui=bold guibg=#857b6f guifg=#f6f3e8
    CSAhi ModeMsg term=bold cterm=bold ctermbg=59 ctermfg=16 gui=bold guibg=#C6C5FE guifg=black
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold ctermbg=16 ctermfg=16 guibg=black guifg=#070707
    CSAhi Number ctermfg=71 guifg=#FF73FD
      CSAlink Float Number
      CSAlink javaScriptNumber Number
    CSAhi Operator ctermfg=38 guifg=#6699CC
      CSAlink rubyOperator Operator
    CSAhi Pmenu ctermbg=80 ctermfg=79 guibg=#444444 guifg=#f6f3e8
    CSAhi PmenuSbar ctermbg=79 ctermfg=16 guibg=white guifg=black
    CSAhi PmenuSel ctermbg=57 ctermfg=16 guibg=#cae682 guifg=#000000
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=43 guifg=#96CBFE
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse cterm=underline gui=underline
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=53 guifg=#E18964
      CSAlink Debug Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermbg=80 ctermfg=83 guibg=#343434 guifg=#808080
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=38 guifg=#6699CC
      CSAlink Exception Statement
      CSAlink Label Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=underline ctermbg=80 ctermfg=58 gui=italic guibg=#202020 guifg=#CCCCCC
    CSAhi StatusLineNC term=reverse ctermbg=80 ctermfg=16 guibg=#202020 guifg=black
    CSAhi String ctermfg=45 guifg=#A8FF60
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=79 gui=bold guifg=#f6f3e8
    CSAhi Todo term=standout ctermfg=83 guifg=#8f8f8f
    CSAhi Type term=underline ctermfg=78 guifg=#FFFFB6
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
      CSAlink rubyConstant Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=80 ctermfg=80 guibg=#202020 guifg=#202020
    CSAhi Visual term=reverse ctermbg=17 guibg=#262D51
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermbg=69 ctermfg=79 gui=bold guibg=#FF6C60 guifg=white
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=28 guibg=yellow guifg=green
    CSAhi javaDocSeeTag ctermfg=58 guifg=#CCCCCC
      CSAlink javaCommentTitle javaDocSeeTag
      CSAlink javaDocParam javaDocSeeTag
      CSAlink javaDocSeeTagParam javaDocSeeTag
      CSAlink javaDocTags javaDocSeeTag
    CSAhi lCursor ctermbg=79 ctermfg=16 guibg=fg guifg=bg
    CSAhi pythonSpaceError ctermbg=64 guibg=red
    CSAhi rubyControl ctermfg=38 guifg=#6699CC
    CSAhi rubyEscape ctermfg=79 guifg=white
    CSAhi rubyInterpolationDelimiter ctermfg=21 guifg=#00A0A0
    CSAhi rubyRegexp ctermfg=52 guifg=#B18A3D
    CSAhi rubyRegexpDelimiter ctermfg=68 guifg=#FF8000
    CSAhi rubyStringDelimiter ctermfg=20 guifg=#336633
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
