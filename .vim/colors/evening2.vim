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
    CSAHi Normal term=NONE cterm=NONE ctermbg=59 ctermfg=231 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=219 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=120 gui=bold guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=147 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=239 ctermfg=153 gui=bold guibg=#4d4d4d guifg=#add8e6
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=231 ctermfg=59 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=59 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=231 ctermfg=59 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=231 ctermfg=59 gui=reverse,bold guibg=bg guifg=fg
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=231 ctermfg=59 gui=reverse guibg=bg guifg=fg
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=231 ctermfg=59 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=145 ctermfg=fg gui=NONE guibg=#999999 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=252 ctermfg=19 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=232 ctermfg=217 gui=NONE guibg=#0d0d0d guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=232 ctermfg=214 gui=NONE guibg=#0d0d0d guifg=#ffa500
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=228 gui=bold guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=59 gui=NONE guibg=bg guifg=#333333
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=147 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=255 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=123 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=219 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=120 gui=bold guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=153 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=239 ctermfg=195 gui=bold guibg=#4d4d4d guifg=#add8e6
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=255 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=255 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=255 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=255 ctermfg=236 gui=reverse,bold guibg=bg guifg=fg
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=255 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=255 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=246 ctermfg=fg gui=NONE guibg=#999999 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=231 ctermfg=19 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=232 ctermfg=224 gui=NONE guibg=#0d0d0d guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=232 ctermfg=220 gui=NONE guibg=#0d0d0d guifg=#ffa500
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=228 gui=bold guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=236 gui=NONE guibg=bg guifg=#333333
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=153 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=231 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=87 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=213 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=83 gui=bold guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=239 ctermfg=152 gui=bold guibg=#4d4d4d guifg=#add8e6
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=231 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=231 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=231 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=231 ctermfg=236 gui=reverse,bold guibg=bg guifg=fg
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=231 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=231 ctermfg=236 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=201 gui=bold guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=246 ctermfg=fg gui=NONE guibg=#999999 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=252 ctermfg=18 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=232 ctermfg=217 gui=NONE guibg=#0d0d0d guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=232 ctermfg=214 gui=NONE guibg=#0d0d0d guifg=#ffa500
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=227 gui=bold guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=236 gui=NONE guibg=bg guifg=#333333
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=111 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=79 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#40ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=71 gui=NONE guibg=bg guifg=#ff80ff
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=45 gui=bold guibg=bg guifg=#60ff60
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=76 ctermfg=19 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=81 ctermfg=58 gui=bold guibg=#4d4d4d guifg=#add8e6
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=79 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=76 gui=NONE guibg=bg guifg=#ffff00
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=31 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=67 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=84 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=79 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=79 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=28 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=79 ctermfg=80 gui=reverse,bold guibg=bg guifg=fg
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=79 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=79 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=67 gui=bold guibg=bg guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=84 ctermfg=fg gui=NONE guibg=#999999 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=86 ctermfg=17 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=28 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi lCursor term=NONE cterm=NONE ctermbg=31 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=16 ctermfg=69 gui=NONE guibg=#0d0d0d guifg=#ffa0a0
    CSAHi Special term=bold cterm=NONE ctermbg=16 ctermfg=68 gui=NONE guibg=#0d0d0d guifg=#ffa500
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=77 gui=bold guibg=bg guifg=#ffff60
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=80 gui=NONE guibg=bg guifg=#333333
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=39 gui=NONE guibg=bg guifg=#80a0ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=17 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
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
