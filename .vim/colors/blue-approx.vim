" This scheme was created by CSApproxSnapshot
" on Fri, 20 Jan 2012

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
    CSAHi Normal term=NONE cterm=NONE ctermbg=18 ctermfg=226 gui=NONE guibg=darkBlue guifg=yellow
    CSAHi type term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=orange
    CSAHi special term=NONE cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=51 gui=underline guibg=bg guifg=cyan
    CSAHi label term=NONE cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi operator term=NONE cterm=bold ctermbg=bg ctermfg=214 gui=bold guibg=bg guifg=orange
    CSAHi Error term=NONE cterm=underline ctermbg=18 ctermfg=196 gui=underline guibg=darkBlue guifg=red
    CSAHi Todo term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=magenta
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=18 ctermfg=214 gui=NONE guibg=darkBlue guifg=orange
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=226 gui=reverse guibg=yellow guifg=black
    CSAHi Search term=reverse cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi MoreMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=Magenta guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=DarkGrey guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=DarkGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=blue guifg=cyan
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=21 ctermfg=16 gui=NONE guibg=blue guifg=black
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=21 ctermfg=21 gui=NONE guibg=blue guifg=blue
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=white
    CSAHi Visual term=reverse cterm=NONE ctermbg=30 ctermfg=16 gui=NONE guibg=darkCyan guifg=black
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=18 ctermfg=51 gui=bold guibg=darkBlue guifg=cyan
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=DarkCyan guifg=fg
    CSAHi comment term=NONE cterm=bold ctermbg=bg ctermfg=250 gui=bold guibg=bg guifg=gray
    CSAHi constant term=NONE cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi identifier term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi statement term=NONE cterm=NONE ctermbg=bg ctermfg=231 gui=NONE guibg=bg guifg=white
    CSAHi preproc term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=16 gui=NONE guibg=gray30 guifg=black
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=62 ctermfg=16 gui=NONE guibg=slateblue guifg=black
    CSAHi DiffChange term=bold cterm=NONE ctermbg=22 ctermfg=16 gui=NONE guibg=darkGreen guifg=black
    CSAHi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=Grey guifg=Cyan
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=18 ctermfg=226 gui=NONE guibg=darkBlue guifg=yellow
    CSAHi type term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=orange
    CSAHi special term=NONE cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=51 gui=underline guibg=bg guifg=cyan
    CSAHi label term=NONE cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi operator term=NONE cterm=bold ctermbg=bg ctermfg=214 gui=bold guibg=bg guifg=orange
    CSAHi Error term=NONE cterm=underline ctermbg=18 ctermfg=196 gui=underline guibg=darkBlue guifg=red
    CSAHi Todo term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=magenta
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=18 ctermfg=214 gui=NONE guibg=darkBlue guifg=orange
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=226 gui=reverse guibg=yellow guifg=black
    CSAHi Search term=reverse cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi MoreMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=Magenta guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=DarkGrey guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=DarkGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=blue guifg=cyan
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=21 ctermfg=16 gui=NONE guibg=blue guifg=black
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=21 ctermfg=21 gui=NONE guibg=blue guifg=blue
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=white
    CSAHi Visual term=reverse cterm=NONE ctermbg=30 ctermfg=16 gui=NONE guibg=darkCyan guifg=black
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=18 ctermfg=51 gui=bold guibg=darkBlue guifg=cyan
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=DarkCyan guifg=fg
    CSAHi comment term=NONE cterm=bold ctermbg=bg ctermfg=250 gui=bold guibg=bg guifg=gray
    CSAHi constant term=NONE cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi identifier term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi statement term=NONE cterm=NONE ctermbg=bg ctermfg=231 gui=NONE guibg=bg guifg=white
    CSAHi preproc term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=16 gui=NONE guibg=gray30 guifg=black
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=62 ctermfg=16 gui=NONE guibg=slateblue guifg=black
    CSAHi DiffChange term=bold cterm=NONE ctermbg=22 ctermfg=16 gui=NONE guibg=darkGreen guifg=black
    CSAHi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=Grey guifg=Cyan
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=18 ctermfg=226 gui=NONE guibg=darkBlue guifg=yellow
    CSAHi type term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=orange
    CSAHi special term=NONE cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=magenta
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=51 gui=underline guibg=bg guifg=cyan
    CSAHi label term=NONE cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi operator term=NONE cterm=bold ctermbg=bg ctermfg=214 gui=bold guibg=bg guifg=orange
    CSAHi Error term=NONE cterm=underline ctermbg=18 ctermfg=196 gui=underline guibg=darkBlue guifg=red
    CSAHi Todo term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=magenta
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=Cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=18 ctermfg=214 gui=NONE guibg=darkBlue guifg=orange
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=226 gui=reverse guibg=yellow guifg=black
    CSAHi Search term=reverse cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi MoreMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=yellow
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=Magenta guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=DarkGrey guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=DarkGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=226 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=blue guifg=cyan
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=21 ctermfg=16 gui=NONE guibg=blue guifg=black
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=21 ctermfg=21 gui=NONE guibg=blue guifg=blue
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=white
    CSAHi Visual term=reverse cterm=NONE ctermbg=30 ctermfg=16 gui=NONE guibg=darkCyan guifg=black
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=18 ctermfg=51 gui=bold guibg=darkBlue guifg=cyan
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=226 ctermfg=18 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=DarkCyan guifg=fg
    CSAHi comment term=NONE cterm=bold ctermbg=bg ctermfg=250 gui=bold guibg=bg guifg=gray
    CSAHi constant term=NONE cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=cyan
    CSAHi identifier term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=gray
    CSAHi statement term=NONE cterm=NONE ctermbg=bg ctermfg=231 gui=NONE guibg=bg guifg=white
    CSAHi preproc term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=green
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=16 gui=NONE guibg=gray30 guifg=black
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=62 ctermfg=16 gui=NONE guibg=slateblue guifg=black
    CSAHi DiffChange term=bold cterm=NONE ctermbg=22 ctermfg=16 gui=NONE guibg=darkGreen guifg=black
    CSAHi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=Grey guifg=Cyan
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=17 ctermfg=76 gui=NONE guibg=darkBlue guifg=yellow
    CSAHi type term=NONE cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=orange
    CSAHi special term=NONE cterm=NONE ctermbg=bg ctermfg=67 gui=NONE guibg=bg guifg=magenta
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=31 gui=underline guibg=bg guifg=cyan
    CSAHi label term=NONE cterm=NONE ctermbg=bg ctermfg=76 gui=NONE guibg=bg guifg=yellow
    CSAHi operator term=NONE cterm=bold ctermbg=bg ctermfg=68 gui=bold guibg=bg guifg=orange
    CSAHi Error term=NONE cterm=underline ctermbg=17 ctermfg=64 gui=underline guibg=darkBlue guifg=red
    CSAHi Todo term=NONE cterm=NONE ctermbg=68 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=85 gui=NONE guibg=bg guifg=gray
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=Cyan
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=67 gui=bold guibg=bg guifg=magenta
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=Cyan
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=17 ctermfg=68 gui=NONE guibg=darkBlue guifg=orange
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=76 gui=reverse guibg=yellow guifg=black
    CSAHi Search term=reverse cterm=NONE ctermbg=68 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi MoreMsg term=bold cterm=NONE ctermbg=bg ctermfg=76 gui=NONE guibg=bg guifg=yellow
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=76 gui=NONE guibg=bg guifg=yellow
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=cyan
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=31 gui=undercurl guibg=bg guifg=fg guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=67 ctermfg=fg gui=NONE guibg=Magenta guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=84 ctermfg=fg gui=NONE guibg=DarkGrey guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=76 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=fg gui=underline guibg=DarkGrey guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=76 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=Grey40 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=28 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=19 ctermfg=31 gui=bold guibg=blue guifg=cyan
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=19 ctermfg=16 gui=NONE guibg=blue guifg=black
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=19 ctermfg=19 gui=NONE guibg=blue guifg=blue
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=79 gui=bold guibg=bg guifg=white
    CSAHi Visual term=reverse cterm=NONE ctermbg=21 ctermfg=16 gui=NONE guibg=darkCyan guifg=black
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=17 ctermfg=31 gui=bold guibg=darkBlue guifg=cyan
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=68 ctermfg=16 gui=NONE guibg=orange guifg=black
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=79 ctermfg=16 gui=NONE guibg=white guifg=black
    CSAHi lCursor term=NONE cterm=NONE ctermbg=76 ctermfg=17 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=fg gui=NONE guibg=DarkCyan guifg=fg
    CSAHi comment term=NONE cterm=bold ctermbg=bg ctermfg=85 gui=bold guibg=bg guifg=gray
    CSAHi constant term=NONE cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=cyan
    CSAHi identifier term=NONE cterm=NONE ctermbg=bg ctermfg=85 gui=NONE guibg=bg guifg=gray
    CSAHi statement term=NONE cterm=NONE ctermbg=bg ctermfg=79 gui=NONE guibg=bg guifg=white
    CSAHi preproc term=NONE cterm=NONE ctermbg=bg ctermfg=28 gui=NONE guibg=bg guifg=green
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=81 ctermfg=16 gui=NONE guibg=gray30 guifg=black
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=38 ctermfg=16 gui=NONE guibg=slateblue guifg=black
    CSAHi DiffChange term=bold cterm=NONE ctermbg=20 ctermfg=16 gui=NONE guibg=darkGreen guifg=black
    CSAHi DiffDelete term=bold cterm=bold ctermbg=69 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAHi DiffText term=reverse cterm=bold ctermbg=36 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=Grey guifg=Cyan
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=Magenta
endif

if 1
    delcommand CSAHi
endif
