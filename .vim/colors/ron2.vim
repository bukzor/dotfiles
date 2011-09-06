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
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=218 gui=NONE guibg=bg guifg=#eea9b8
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=147 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=#ffa500 guifg=#000000
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=131 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=16 gui=NONE guibg=#ff0000 guifg=#000000
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=74 ctermfg=fg gui=NONE guibg=#4682b4 guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=141 ctermfg=16 gui=NONE guibg=#8470ff guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=248 gui=NONE guibg=bg guifg=#a9a9a9
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=#bebebe
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=102 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Label term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#eec900
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=#0000ff guifg=#00ffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=19 ctermfg=153 gui=NONE guibg=#00008b guifg=#add8e6
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=248 gui=bold guibg=bg guifg=#a9a9a9
    CSAHi Visual term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=239 ctermfg=51 gui=NONE guibg=#4d4d4d guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=108 ctermfg=46 gui=NONE guibg=#60a060 guifg=#00ff00
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=bold ctermbg=bg ctermfg=51 gui=bold guibg=bg guifg=#00ffff
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=153 gui=NONE guibg=bg guifg=#add8e6
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=231 gui=NONE guibg=#4d4d4d guifg=#ffffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=104 ctermfg=fg gui=NONE guibg=#6a5acd guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=28 ctermfg=fg gui=NONE guibg=#006400 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=210 ctermfg=21 gui=bold guibg=#ff7f50 guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=107 ctermfg=fg gui=bold guibg=#6b8e23 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=224 gui=NONE guibg=bg guifg=#eea9b8
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=153 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=220 ctermfg=16 gui=NONE guibg=#ffa500 guifg=#000000
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=167 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=16 gui=NONE guibg=#ff0000 guifg=#000000
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=110 ctermfg=fg gui=NONE guibg=#4682b4 guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=147 ctermfg=16 gui=NONE guibg=#8470ff guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=248 gui=NONE guibg=bg guifg=#a9a9a9
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=#bebebe
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Label term=NONE cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#eec900
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=#0000ff guifg=#00ffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=19 ctermfg=195 gui=NONE guibg=#00008b guifg=#add8e6
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=248 gui=bold guibg=bg guifg=#a9a9a9
    CSAHi Visual term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=239 ctermfg=51 gui=NONE guibg=#4d4d4d guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=114 ctermfg=46 gui=NONE guibg=#60a060 guifg=#00ff00
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=bold ctermbg=bg ctermfg=51 gui=bold guibg=bg guifg=#00ffff
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=195 gui=NONE guibg=bg guifg=#add8e6
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=255 gui=NONE guibg=#4d4d4d guifg=#ffffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=105 ctermfg=fg gui=NONE guibg=#6a5acd guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=28 ctermfg=fg gui=NONE guibg=#006400 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=216 ctermfg=21 gui=bold guibg=#ff7f50 guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=143 ctermfg=fg gui=bold guibg=#6b8e23 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=217 gui=NONE guibg=bg guifg=#eea9b8
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=214 ctermfg=16 gui=NONE guibg=#ffa500 guifg=#000000
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=124 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=16 gui=NONE guibg=#ff0000 guifg=#000000
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=67 ctermfg=fg gui=NONE guibg=#4682b4 guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=99 ctermfg=16 gui=NONE guibg=#8470ff guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=248 gui=NONE guibg=bg guifg=#a9a9a9
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=250 gui=NONE guibg=bg guifg=#bebebe
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Label term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#eec900
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=#0000ff guifg=#00ffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=18 ctermfg=152 gui=NONE guibg=#00008b guifg=#add8e6
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=248 gui=bold guibg=bg guifg=#a9a9a9
    CSAHi Visual term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=46 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=239 ctermfg=51 gui=NONE guibg=#4d4d4d guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=71 ctermfg=46 gui=NONE guibg=#60a060 guifg=#00ff00
    CSAHi lCursor term=NONE cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=bold ctermbg=bg ctermfg=51 gui=bold guibg=bg guifg=#00ffff
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=226 gui=NONE guibg=bg guifg=#ffff00
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=152 gui=NONE guibg=bg guifg=#add8e6
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=46 gui=NONE guibg=bg guifg=#00ff00
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=239 ctermfg=231 gui=NONE guibg=#4d4d4d guifg=#ffffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=62 ctermfg=fg gui=NONE guibg=#6a5acd guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=22 ctermfg=fg gui=NONE guibg=#006400 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=21 gui=bold guibg=#ff7f50 guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=fg gui=bold guibg=#6b8e23 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=31 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=70 gui=NONE guibg=bg guifg=#eea9b8
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=68 ctermfg=16 gui=NONE guibg=#ffa500 guifg=#000000
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=32 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=16 gui=NONE guibg=#ff0000 guifg=#000000
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=38 ctermfg=fg gui=NONE guibg=#4682b4 guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=39 ctermfg=16 gui=NONE guibg=#8470ff guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=84 gui=NONE guibg=bg guifg=#a9a9a9
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=85 gui=NONE guibg=bg guifg=#bebebe
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=31 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=67 ctermfg=fg gui=NONE guibg=#ff00ff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=84 ctermfg=fg gui=NONE guibg=#a9a9a9 guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=31 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=31 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#666666 guifg=fg
    CSAHi Label term=NONE cterm=NONE ctermbg=bg ctermfg=72 gui=NONE guibg=bg guifg=#eec900
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ffa500
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=28 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=19 ctermfg=31 gui=bold guibg=#0000ff guifg=#00ffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=17 ctermfg=58 gui=NONE guibg=#00008b guifg=#add8e6
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=31 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=84 gui=bold guibg=bg guifg=#a9a9a9
    CSAHi Visual term=reverse cterm=NONE ctermbg=31 ctermfg=16 gui=reverse guibg=bg guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=28 ctermfg=16 gui=NONE guibg=#00ff00 guifg=#000000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=81 ctermfg=31 gui=NONE guibg=#4d4d4d guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=#8b0000 guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=37 ctermfg=28 gui=NONE guibg=#60a060 guifg=#00ff00
    CSAHi lCursor term=NONE cterm=NONE ctermbg=31 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=fg gui=NONE guibg=#008b8b guifg=fg
    CSAHi Constant term=underline cterm=bold ctermbg=bg ctermfg=31 gui=bold guibg=bg guifg=#00ffff
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=76 gui=NONE guibg=bg guifg=#ffff00
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#add8e6
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=16 gui=NONE guibg=bg guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=28 gui=NONE guibg=bg guifg=#00ff00
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=81 ctermfg=79 gui=NONE guibg=#4d4d4d guifg=#ffffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=38 ctermfg=fg gui=NONE guibg=#6a5acd guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=20 ctermfg=fg gui=NONE guibg=#006400 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=69 ctermfg=19 gui=bold guibg=#ff7f50 guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=36 ctermfg=fg gui=bold guibg=#6b8e23 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
endif

if 1
    delcommand CSAHi
endif
