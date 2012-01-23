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
    CSAhi Normal ctermbg=236 ctermfg=251 guibg=#303030 guifg=#c5c8c6
    CSAhi ColorColumn term=reverse ctermbg=237 guibg=#3a3a3a
    CSAhi Comment term=bold ctermfg=246 guifg=#969896
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional ctermfg=251 guifg=#c5c8c6
    CSAhi Constant term=underline ctermfg=173 guifg=#de935f
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
    CSAhi Cursor ctermbg=251 ctermfg=236 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=237 guibg=#3a3a3a
    CSAhi CursorLine term=underline ctermbg=237 guibg=#3a3a3a
    CSAhi Define ctermfg=139 guifg=#b294bb
    CSAhi DiffAdd term=bold ctermbg=152 guibg=LightBlue
    CSAhi DiffChange term=bold ctermbg=219 guibg=LightMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=LightCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=109 guifg=#81a2be
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=236 ctermfg=51 guibg=#303030 guifg=Cyan
    CSAhi Folded term=standout ctermbg=236 ctermfg=246 guibg=#303030 guifg=#969896
    CSAhi Function ctermfg=109 guifg=#81a2be
    CSAhi Identifier term=underline ctermfg=167 guifg=#cc6666
    CSAhi Ignore ctermfg=236 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Include ctermfg=109 guifg=#81a2be
    CSAhi LineNr term=underline ctermfg=240 guifg=#585858
    CSAhi MatchParen term=reverse ctermbg=240 guibg=#585858
    CSAhi ModeMsg term=bold cterm=bold ctermfg=143 gui=bold guifg=#b5bd68
    CSAhi MoreMsg term=bold cterm=bold ctermfg=143 gui=bold guifg=#b5bd68
    CSAhi NonText term=bold cterm=bold ctermfg=240 gui=bold guifg=#585858
    CSAhi Operator ctermfg=109 guifg=#8abeb7
    CSAhi Pmenu ctermbg=240 ctermfg=251 guibg=#585858 guifg=#c5c8c6
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel cterm=reverse ctermbg=240 ctermfg=251 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=139 guifg=#b294bb
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=143 gui=bold guifg=#b5bd68
    CSAhi Repeat ctermfg=251 guifg=#c5c8c6
    CSAhi Search term=reverse ctermbg=222 ctermfg=236 guibg=#f0c674 guifg=#303030
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=251 guifg=#c5c8c6
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=240 guifg=#585858
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=30 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=251 gui=bold guifg=#c5c8c6
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
    CSAhi StatusLine term=bold,reverse cterm=reverse ctermbg=222 ctermfg=59 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAhi StatusLineNC term=reverse cterm=reverse ctermbg=251 ctermfg=59 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAhi String ctermfg=143 guifg=#b5bd68
    CSAhi Structure ctermfg=139 guifg=#b294bb
    CSAhi TabLine term=underline cterm=reverse ctermbg=236 ctermfg=251 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=246 gui=bold guifg=#969896
    CSAhi Todo term=standout ctermbg=236 ctermfg=246 guibg=#303030 guifg=#969896
    CSAhi Type term=underline ctermfg=109 guifg=#81a2be
      CSAlink StorageClass Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=59 ctermfg=59 guibg=#5e5e5e guifg=#5e5e5e
    CSAhi Visual term=reverse ctermbg=240 guibg=#585858
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=167 guifg=#cc6666
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cStorageClass ctermfg=139 guifg=#b294bb
    CSAhi cType ctermfg=222 guifg=#f0c674
    CSAhi diffAdded ctermfg=143 guifg=#b5bd68
    CSAhi diffRemoved ctermfg=167 guifg=#cc6666
    CSAhi javaScriptBraces ctermfg=251 guifg=#c5c8c6
    CSAhi javaScriptConditional ctermfg=139 guifg=#b294bb
    CSAhi javaScriptFunction ctermfg=139 guifg=#b294bb
    CSAhi javaScriptMember ctermfg=173 guifg=#de935f
    CSAhi javaScriptNumber ctermfg=173 guifg=#de935f
    CSAhi javaScriptRepeat ctermfg=139 guifg=#b294bb
    CSAhi lCursor ctermbg=251 ctermfg=236 guibg=fg guifg=bg
    CSAhi phpConditional ctermfg=139 guifg=#b294bb
    CSAhi phpKeyword ctermfg=139 guifg=#b294bb
    CSAhi phpMemberSelector ctermfg=251 guifg=#c5c8c6
    CSAhi phpRepeat ctermfg=139 guifg=#b294bb
    CSAhi phpStatement ctermfg=139 guifg=#b294bb
    CSAhi phpVarSelector ctermfg=167 guifg=#cc6666
    CSAhi pythonConditional ctermfg=139 guifg=#b294bb
    CSAhi pythonFunction ctermfg=109 guifg=#81a2be
    CSAhi pythonInclude ctermfg=139 guifg=#b294bb
    CSAhi pythonStatement ctermfg=139 guifg=#b294bb
    CSAhi rubyAttribute ctermfg=109 guifg=#81a2be
    CSAhi rubyConditional ctermfg=139 guifg=#b294bb
    CSAhi rubyConstant ctermfg=222 guifg=#f0c674
    CSAhi rubyCurlyBlock ctermfg=173 guifg=#de935f
    CSAhi rubyInclude ctermfg=109 guifg=#81a2be
    CSAhi rubyInterpolationDelimiter ctermfg=173 guifg=#de935f
    CSAhi rubyLocalVariableOrMethod ctermfg=173 guifg=#de935f
    CSAhi rubyRepeat ctermfg=139 guifg=#b294bb
    CSAhi rubyStringDelimiter ctermfg=143 guifg=#b5bd68
    CSAhi rubySymbol ctermfg=143 guifg=#b5bd68
    CSAhi vimCommand ctermfg=167 guifg=#cc6666

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=58 guibg=#303030 guifg=#c5c8c6
    CSAhi ColorColumn term=reverse ctermbg=80 guibg=#3a3a3a
    CSAhi Comment term=bold ctermfg=37 guifg=#969896
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional ctermfg=58 guifg=#c5c8c6
    CSAhi Constant term=underline ctermfg=53 guifg=#de935f
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
    CSAhi Cursor ctermbg=58 ctermfg=80 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=80 guibg=#3a3a3a
    CSAhi CursorLine term=underline ctermbg=80 guibg=#3a3a3a
    CSAhi Define ctermfg=54 guifg=#b294bb
    CSAhi DiffAdd term=bold ctermbg=58 guibg=LightBlue
    CSAhi DiffChange term=bold ctermbg=75 guibg=LightMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=63 ctermfg=19 gui=bold guibg=LightCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=38 guifg=#81a2be
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=80 ctermfg=31 guibg=#303030 guifg=Cyan
    CSAhi Folded term=standout ctermbg=80 ctermfg=37 guibg=#303030 guifg=#969896
    CSAhi Function ctermfg=38 guifg=#81a2be
    CSAhi Identifier term=underline ctermfg=53 guifg=#cc6666
    CSAhi Ignore ctermfg=80 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Include ctermfg=38 guifg=#81a2be
    CSAhi LineNr term=underline ctermfg=81 guifg=#585858
    CSAhi MatchParen term=reverse ctermbg=81 guibg=#585858
    CSAhi ModeMsg term=bold cterm=bold ctermfg=57 gui=bold guifg=#b5bd68
    CSAhi MoreMsg term=bold cterm=bold ctermfg=57 gui=bold guifg=#b5bd68
    CSAhi NonText term=bold cterm=bold ctermfg=81 gui=bold guifg=#585858
    CSAhi Operator ctermfg=42 guifg=#8abeb7
    CSAhi Pmenu ctermbg=81 ctermfg=58 guibg=#585858 guifg=#c5c8c6
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel cterm=reverse ctermbg=81 ctermfg=58 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=54 guifg=#b294bb
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=57 gui=bold guifg=#b5bd68
    CSAhi Repeat ctermfg=58 guifg=#c5c8c6
    CSAhi Search term=reverse ctermbg=73 ctermfg=80 guibg=#f0c674 guifg=#303030
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=58 guifg=#c5c8c6
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=81 guifg=#585858
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=21 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=58 gui=bold guifg=#c5c8c6
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
    CSAhi StatusLine term=bold,reverse cterm=reverse ctermbg=73 ctermfg=81 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAhi StatusLineNC term=reverse cterm=reverse ctermbg=58 ctermfg=81 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAhi String ctermfg=57 guifg=#b5bd68
    CSAhi Structure ctermfg=54 guifg=#b294bb
    CSAhi TabLine term=underline cterm=reverse ctermbg=80 ctermfg=58 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=37 gui=bold guifg=#969896
    CSAhi Todo term=standout ctermbg=80 ctermfg=37 guibg=#303030 guifg=#969896
    CSAhi Type term=underline ctermfg=38 guifg=#81a2be
      CSAlink StorageClass Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=81 ctermfg=81 guibg=#5e5e5e guifg=#5e5e5e
    CSAhi Visual term=reverse ctermbg=81 guibg=#585858
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=53 guifg=#cc6666
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cStorageClass ctermfg=54 guifg=#b294bb
    CSAhi cType ctermfg=73 guifg=#f0c674
    CSAhi diffAdded ctermfg=57 guifg=#b5bd68
    CSAhi diffRemoved ctermfg=53 guifg=#cc6666
    CSAhi javaScriptBraces ctermfg=58 guifg=#c5c8c6
    CSAhi javaScriptConditional ctermfg=54 guifg=#b294bb
    CSAhi javaScriptFunction ctermfg=54 guifg=#b294bb
    CSAhi javaScriptMember ctermfg=53 guifg=#de935f
    CSAhi javaScriptNumber ctermfg=53 guifg=#de935f
    CSAhi javaScriptRepeat ctermfg=54 guifg=#b294bb
    CSAhi lCursor ctermbg=58 ctermfg=80 guibg=fg guifg=bg
    CSAhi phpConditional ctermfg=54 guifg=#b294bb
    CSAhi phpKeyword ctermfg=54 guifg=#b294bb
    CSAhi phpMemberSelector ctermfg=58 guifg=#c5c8c6
    CSAhi phpRepeat ctermfg=54 guifg=#b294bb
    CSAhi phpStatement ctermfg=54 guifg=#b294bb
    CSAhi phpVarSelector ctermfg=53 guifg=#cc6666
    CSAhi pythonConditional ctermfg=54 guifg=#b294bb
    CSAhi pythonFunction ctermfg=38 guifg=#81a2be
    CSAhi pythonInclude ctermfg=54 guifg=#b294bb
    CSAhi pythonStatement ctermfg=54 guifg=#b294bb
    CSAhi rubyAttribute ctermfg=38 guifg=#81a2be
    CSAhi rubyConditional ctermfg=54 guifg=#b294bb
    CSAhi rubyConstant ctermfg=73 guifg=#f0c674
    CSAhi rubyCurlyBlock ctermfg=53 guifg=#de935f
    CSAhi rubyInclude ctermfg=38 guifg=#81a2be
    CSAhi rubyInterpolationDelimiter ctermfg=53 guifg=#de935f
    CSAhi rubyLocalVariableOrMethod ctermfg=53 guifg=#de935f
    CSAhi rubyRepeat ctermfg=54 guifg=#b294bb
    CSAhi rubyStringDelimiter ctermfg=57 guifg=#b5bd68
    CSAhi rubySymbol ctermfg=57 guifg=#b5bd68
    CSAhi vimCommand ctermfg=53 guifg=#cc6666
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
