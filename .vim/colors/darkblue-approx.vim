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
    CSAhi Normal ctermbg=17 ctermfg=250 guibg=#000040 guifg=#c0c0c0
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=111 guifg=#80a0ff
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=217 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=226 ctermfg=16 guibg=yellow guifg=black
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=Grey40
    CSAhi DiffAdd ctermbg=18 guibg=darkblue
    CSAhi DiffChange term=bold ctermbg=90 guibg=darkmagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=33 ctermfg=231 guibg=#287eff guifg=#ffffff
    CSAhi FoldColumn term=bold ctermbg=17 ctermfg=244 guibg=#000040 guifg=#808080
    CSAhi Folded term=bold ctermbg=17 ctermfg=244 guibg=#000040 guifg=#808080
    CSAhi Identifier term=underline ctermfg=87 guifg=#40ffff
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=17 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=26 ctermfg=159 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAhi LineNr term=underline ctermfg=118 guifg=#90f020
    CSAhi MatchParen term=reverse ctermbg=30 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=44 gui=bold guifg=#22cce2
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=27 gui=bold guifg=#0030ff
    CSAhi Pmenu ctermbg=60 ctermfg=250 guibg=#404080 guifg=#c0c0c0
    CSAhi PmenuSbar ctermbg=248 ctermfg=21 guibg=darkgray guifg=blue
    CSAhi PmenuSel ctermbg=26 ctermfg=250 guibg=#2050d0 guifg=#c0c0c0
    CSAhi PmenuThumb cterm=reverse ctermfg=250 gui=reverse guifg=#c0c0c0
    CSAhi PreProc term=underline ctermfg=213 guifg=#ff80ff
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout ctermfg=46 guifg=green
    CSAhi Search term=underline ctermbg=26 ctermfg=123 guibg=#2050d0 guifg=#90fff0
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=214 guifg=Orange
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=51 guifg=cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=227 guifg=#ffff60
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine ctermbg=248 ctermfg=21 guibg=darkgray guifg=blue
    CSAhi StatusLineNC ctermbg=248 ctermfg=16 guibg=darkgray guifg=black
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold ctermfg=201 guifg=magenta
    CSAhi Todo term=standout ctermbg=26 ctermfg=166 guibg=#1248d1 guifg=#d14a14
    CSAhi Type term=underline ctermfg=83 guifg=#60ff60
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit ctermbg=248 ctermfg=16 guibg=darkgray guifg=black
    CSAhi Visual term=reverse cterm=reverse ctermbg=250 ctermfg=105 gui=reverse guibg=fg guifg=#8080ff
    CSAhi VisualNOS term=bold,underline cterm=reverse,underline ctermbg=250 ctermfg=105 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAhi WarningMsg term=standout ctermfg=196 guifg=red
    CSAhi WildMenu ctermbg=16 ctermfg=226 guibg=black guifg=yellow
    CSAhi lCursor ctermbg=231 ctermfg=16 guibg=white guifg=black

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=16 ctermfg=85 guibg=#000040 guifg=#c0c0c0
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=39 guifg=#80a0ff
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=69 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=76 ctermfg=16 guibg=yellow guifg=black
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=Grey40
    CSAhi DiffAdd ctermbg=17 guibg=darkblue
    CSAhi DiffChange term=bold ctermbg=33 guibg=darkmagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=23 ctermfg=79 guibg=#287eff guifg=#ffffff
    CSAhi FoldColumn term=bold ctermbg=16 ctermfg=83 guibg=#000040 guifg=#808080
    CSAhi Folded term=bold ctermbg=16 ctermfg=83 guibg=#000040 guifg=#808080
    CSAhi Identifier term=underline ctermfg=31 guifg=#40ffff
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=16 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=22 ctermfg=63 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAhi LineNr term=underline ctermfg=44 guifg=#90f020
    CSAhi MatchParen term=reverse ctermbg=21 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=26 gui=bold guifg=#22cce2
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=19 gui=bold guifg=#0030ff
    CSAhi Pmenu ctermbg=17 ctermfg=85 guibg=#404080 guifg=#c0c0c0
    CSAhi PmenuSbar ctermbg=84 ctermfg=19 guibg=darkgray guifg=blue
    CSAhi PmenuSel ctermbg=22 ctermfg=85 guibg=#2050d0 guifg=#c0c0c0
    CSAhi PmenuThumb cterm=reverse ctermfg=85 gui=reverse guifg=#c0c0c0
    CSAhi PreProc term=underline ctermfg=71 guifg=#ff80ff
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout ctermfg=28 guifg=green
    CSAhi Search term=underline ctermbg=22 ctermfg=47 guibg=#2050d0 guifg=#90fff0
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=68 guifg=Orange
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=31 guifg=cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=77 guifg=#ffff60
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine ctermbg=84 ctermfg=19 guibg=darkgray guifg=blue
    CSAhi StatusLineNC ctermbg=84 ctermfg=16 guibg=darkgray guifg=black
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold ctermfg=67 guifg=magenta
    CSAhi Todo term=standout ctermbg=22 ctermfg=52 guibg=#1248d1 guifg=#d14a14
    CSAhi Type term=underline ctermfg=45 guifg=#60ff60
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit ctermbg=84 ctermfg=16 guibg=darkgray guifg=black
    CSAhi Visual term=reverse cterm=reverse ctermbg=85 ctermfg=39 gui=reverse guibg=fg guifg=#8080ff
    CSAhi VisualNOS term=bold,underline cterm=reverse,underline ctermbg=85 ctermfg=39 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAhi WarningMsg term=standout ctermfg=64 guifg=red
    CSAhi WildMenu ctermbg=16 ctermfg=76 guibg=black guifg=yellow
    CSAhi lCursor ctermbg=79 ctermfg=16 guibg=white guifg=black
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
