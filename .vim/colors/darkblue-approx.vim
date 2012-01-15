" This scheme was created by CSApproxSnapshot
" on Sat, 14 Jan 2012

hi clear
if exists("syntax_on")
    syntax reset
endif

if v:version < 700
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" substitute(substitute(<q-args>, "undercurl", "underline", "g"), "guisp\\S\\+", "", "g")
else
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" <q-args>
endif

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || &term =~? "^konsole"
    CSAHi Normal term=NONE cterm=NONE ctermbg=17 ctermfg=250 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=213 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=17 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=26 ctermfg=166 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=33 ctermfg=231 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=159 ctermfg=26 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=26 ctermfg=123 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=44 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=118 gui=NONE guibg=bg guifg=#90f020
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=60 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=26 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=fg gui=underline guibg=LightGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Visual term=reverse cterm=NONE ctermbg=105 ctermfg=250 gui=reverse guibg=fg guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=105 ctermfg=250 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=red
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=black guifg=yellow
    CSAHi Folded term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=217 ctermfg=fg gui=NONE guibg=LightRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=yellow guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=Cyan guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=111 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=Orange
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=227 gui=NONE guibg=bg guifg=#ffff60
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=darkblue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=darkmagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=17 ctermfg=250 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=213 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=17 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=26 ctermfg=166 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=33 ctermfg=231 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=159 ctermfg=26 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=26 ctermfg=123 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=44 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=118 gui=NONE guibg=bg guifg=#90f020
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=60 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=26 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=fg gui=underline guibg=LightGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Visual term=reverse cterm=NONE ctermbg=105 ctermfg=250 gui=reverse guibg=fg guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=105 ctermfg=250 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=red
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=black guifg=yellow
    CSAHi Folded term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=217 ctermfg=fg gui=NONE guibg=LightRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=yellow guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=Cyan guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=111 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=Orange
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=227 gui=NONE guibg=bg guifg=#ffff60
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=darkblue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=darkmagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=17 ctermfg=250 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=213 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=17 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=26 ctermfg=166 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=33 ctermfg=231 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=159 ctermfg=26 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=26 ctermfg=123 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=44 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=118 gui=NONE guibg=bg guifg=#90f020
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=60 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=26 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=fg gui=underline guibg=LightGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=darkgray guifg=blue
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Visual term=reverse cterm=NONE ctermbg=105 ctermfg=250 gui=reverse guibg=fg guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=105 ctermfg=250 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=red
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=black guifg=yellow
    CSAHi Folded term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=217 ctermfg=fg gui=NONE guibg=LightRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=yellow guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=Cyan guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=111 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=Orange
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=227 gui=NONE guibg=bg guifg=#ffff60
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=darkblue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=darkmagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=85 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=71 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=45 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=22 ctermfg=52 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=19 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=23 ctermfg=79 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=63 ctermfg=22 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=22 ctermfg=47 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=26 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=44 gui=NONE guibg=bg guifg=#90f020
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=17 ctermfg=85 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=22 ctermfg=85 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=84 ctermfg=19 gui=NONE guibg=darkgray guifg=blue
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=85 ctermfg=16 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=86 ctermfg=fg gui=underline guibg=LightGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=85 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=87 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=87 ctermfg=fg gui=NONE guibg=Grey90 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=28 gui=NONE guibg=bg guifg=green
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=84 ctermfg=19 gui=NONE guibg=darkgray guifg=blue
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=84 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=84 ctermfg=16 gui=NONE guibg=darkgray guifg=black
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=67 gui=NONE guibg=bg guifg=magenta
    CSAHi Visual term=reverse cterm=NONE ctermbg=39 ctermfg=85 gui=reverse guibg=fg guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=39 ctermfg=85 gui=reverse,underline guibg=fg guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=red
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=76 gui=NONE guibg=black guifg=yellow
    CSAHi Folded term=bold cterm=NONE ctermbg=16 ctermfg=83 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=74 ctermfg=fg gui=NONE guibg=LightRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=yellow guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=79 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=31 ctermfg=fg gui=NONE guibg=Cyan guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=39 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=69 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=Orange
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#40ffff
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#ffff60
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=16 ctermfg=83 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=17 ctermfg=fg gui=NONE guibg=darkblue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=33 ctermfg=fg gui=NONE guibg=darkmagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=Magenta
endif

if 1
    delcommand CSAHi
endif
