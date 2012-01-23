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
    CSAhi Normal ctermbg=16 ctermfg=51 guibg=black guifg=cyan
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=46 guifg=green
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline cterm=bold ctermfg=51 gui=bold guifg=cyan
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=71 ctermfg=46 guibg=#60a060 guifg=#00ff00
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=62 guibg=slateblue
    CSAhi DiffChange term=bold ctermbg=22 guibg=darkgreen
    CSAhi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=21 gui=bold guibg=coral guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=olivedrab
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=16 guibg=Red guifg=Black
    CSAhi FoldColumn term=standout ctermbg=239 ctermfg=231 guibg=gray30 guifg=white
    CSAhi Folded term=standout ctermbg=239 ctermfg=51 guibg=gray30 guifg=Cyan
    CSAhi Identifier term=underline ctermfg=51 guifg=cyan
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=16 guifg=bg
    CSAhi IncSearch term=reverse ctermbg=67 guibg=steelblue
    CSAhi Label ctermfg=220 guifg=gold2
    CSAhi LineNr term=underline ctermfg=248 guifg=darkgrey
    CSAhi MatchParen term=reverse ctermbg=30 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=124 gui=bold guifg=brown
    CSAhi Operator ctermfg=214 guifg=orange
    CSAhi Pmenu ctermbg=201 guibg=Magenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=248 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=217 guifg=Pink2
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=99 ctermfg=16 guibg=lightslateblue guifg=Black
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=226 guifg=yellow
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=51 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=152 guifg=lightblue
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=blue guifg=cyan
    CSAhi StatusLineNC term=reverse ctermbg=18 ctermfg=152 guibg=darkblue guifg=lightblue
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=248 gui=bold guifg=darkgrey
    CSAhi Todo term=standout ctermbg=214 ctermfg=16 guibg=orange guifg=Black
    CSAhi Type term=underline cterm=bold ctermfg=29 gui=bold guifg=seagreen
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse cterm=reverse gui=reverse
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermbg=46 ctermfg=16 guibg=Green guifg=Black
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cIf0 ctermfg=250 guifg=gray
    CSAhi lCursor ctermbg=51 ctermfg=16 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=16 ctermfg=31 guibg=black guifg=cyan
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=28 guifg=green
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline cterm=bold ctermfg=31 gui=bold guifg=cyan
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=37 ctermfg=28 guibg=#60a060 guifg=#00ff00
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=38 guibg=slateblue
    CSAhi DiffChange term=bold ctermbg=20 guibg=darkgreen
    CSAhi DiffDelete term=bold cterm=bold ctermbg=69 ctermfg=19 gui=bold guibg=coral guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=36 gui=bold guibg=olivedrab
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=16 guibg=Red guifg=Black
    CSAhi FoldColumn term=standout ctermbg=81 ctermfg=79 guibg=gray30 guifg=white
    CSAhi Folded term=standout ctermbg=81 ctermfg=31 guibg=gray30 guifg=Cyan
    CSAhi Identifier term=underline ctermfg=31 guifg=cyan
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=16 guifg=bg
    CSAhi IncSearch term=reverse ctermbg=38 guibg=steelblue
    CSAhi Label ctermfg=72 guifg=gold2
    CSAhi LineNr term=underline ctermfg=84 guifg=darkgrey
    CSAhi MatchParen term=reverse ctermbg=21 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=32 gui=bold guifg=brown
    CSAhi Operator ctermfg=68 guifg=orange
    CSAhi Pmenu ctermbg=67 guibg=Magenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=84 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=70 guifg=Pink2
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=39 ctermfg=16 guibg=lightslateblue guifg=Black
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=76 guifg=yellow
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=31 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=58 guifg=lightblue
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=19 ctermfg=31 gui=bold guibg=blue guifg=cyan
    CSAhi StatusLineNC term=reverse ctermbg=17 ctermfg=58 guibg=darkblue guifg=lightblue
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=84 gui=bold guifg=darkgrey
    CSAhi Todo term=standout ctermbg=68 ctermfg=16 guibg=orange guifg=Black
    CSAhi Type term=underline cterm=bold ctermfg=21 gui=bold guifg=seagreen
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse cterm=reverse gui=reverse
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermbg=28 ctermfg=16 guibg=Green guifg=Black
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cIf0 ctermfg=85 guifg=gray
    CSAhi lCursor ctermbg=31 ctermfg=16 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
