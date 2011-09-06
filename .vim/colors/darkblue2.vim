" This scheme was created by CSApproxSnapshot
" on Tue, 06 Sep 2011

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
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=219 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=120 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=147 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=26 ctermfg=166 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=69 ctermfg=231 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=159 ctermfg=68 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=68 ctermfg=159 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=80 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=155 gui=NONE guibg=bg guifg=#90f020
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=61 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=68 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=147 ctermfg=250 gui=reverse guibg=#c0c0c0 guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=147 ctermfg=250 gui=reverse,underline guibg=#c0c0c0 guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Folded term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=228 gui=NONE guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=17 gui=NONE guibg=bg guifg=#000040
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=147 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=18 ctermfg=250 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=123 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=219 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=120 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=153 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=33 ctermfg=208 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=75 ctermfg=255 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=195 ctermfg=69 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=69 ctermfg=159 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=87 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=155 gui=NONE guibg=bg guifg=#90f020
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=103 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=69 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=18 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=147 ctermfg=250 gui=reverse guibg=#c0c0c0 guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=147 ctermfg=250 gui=reverse,underline guibg=#c0c0c0 guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Folded term=bold cterm=NONE ctermbg=18 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=255 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=224 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=228 gui=NONE guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=18 gui=NONE guibg=bg guifg=#000040
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=153 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=18 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=17 ctermfg=250 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=213 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=26 ctermfg=166 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=27 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=33 ctermfg=231 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=159 ctermfg=26 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=26 ctermfg=123 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=44 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=118 gui=NONE guibg=bg guifg=#90f020
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=60 ctermfg=250 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=26 ctermfg=250 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=250 ctermfg=17 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=248 ctermfg=21 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=248 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=105 ctermfg=250 gui=reverse guibg=#c0c0c0 guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=105 ctermfg=250 gui=reverse,underline guibg=#c0c0c0 guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Folded term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=227 gui=NONE guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=17 gui=NONE guibg=bg guifg=#000040
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=111 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=17 ctermfg=244 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=85 gui=NONE guibg=#000040 guifg=#c0c0c0
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=71 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=45 gui=NONE guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=22 ctermfg=52 gui=NONE guibg=#1248d1 guifg=#d14a14
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=19 gui=bold guibg=bg guifg=#0030ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=23 ctermfg=79 gui=NONE guibg=#287eff guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=63 ctermfg=22 gui=reverse guibg=#2050d0 guifg=#b0ffff
    CSAHi Search term=underline cterm=NONE ctermbg=22 ctermfg=47 gui=NONE guibg=#2050d0 guifg=#90fff0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=26 gui=bold guibg=bg guifg=#22cce2
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=44 gui=NONE guibg=bg guifg=#90f020
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=31 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=17 ctermfg=85 gui=NONE guibg=#404080 guifg=#c0c0c0
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=22 ctermfg=85 gui=NONE guibg=#2050d0 guifg=#c0c0c0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=84 ctermfg=19 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=85 ctermfg=16 gui=reverse guibg=bg guifg=#c0c0c0
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=85 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=NONE ctermbg=bg ctermfg=28 gui=NONE guibg=bg guifg=#00ff00
    CSAHi StatusLine term=NONE cterm=NONE ctermbg=84 ctermfg=19 gui=NONE guibg=#a9a9a9 guifg=#0000ff
    CSAHi StatusLineNC term=NONE cterm=NONE ctermbg=84 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi VertSplit term=NONE cterm=NONE ctermbg=84 ctermfg=16 gui=NONE guibg=#a9a9a9 guifg=#000000
    CSAHi Title term=bold cterm=NONE ctermbg=bg ctermfg=67 gui=NONE guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=39 ctermfg=85 gui=reverse guibg=#c0c0c0 guifg=#8080ff
    CSAHi VisualNOS term=bold,underline cterm=underline ctermbg=39 ctermfg=85 gui=reverse,underline guibg=#c0c0c0 guifg=#8080ff
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=16 ctermfg=76 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Folded term=bold cterm=NONE ctermbg=16 ctermfg=83 gui=NONE guibg=#000040 guifg=#808080
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=79 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=69 gui=NONE guibg=bg guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000040
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=39 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=bold cterm=NONE ctermbg=16 ctermfg=83 gui=NONE guibg=#000040 guifg=#808080
    CSAHi DiffAdd term=NONE cterm=NONE ctermbg=17 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=33 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
endif

if 1
    delcommand CSAHi
endif
