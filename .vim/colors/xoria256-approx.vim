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
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#1c1c1c guifg=#d0d0d0
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=238 gui=NONE guibg=bg guifg=#444444
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi PreProc term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi Type term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#afafdf
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi htmlTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonExceptions term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi treeCWD term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=223 ctermfg=16 gui=NONE guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi djangoFilter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=243 ctermfg=255 gui=NONE guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=252 ctermfg=fg gui=NONE guibg=#d0d0d0 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=243 ctermfg=234 gui=reverse guibg=bg guifg=#767676
    CSAHi TabLine term=underline cterm=NONE ctermbg=241 ctermfg=252 gui=NONE guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=237 ctermfg=252 gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi htmlEndTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi htmlArg term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi htmlValue term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#dfdfaf
    CSAHi htmlTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoVarBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoTagBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=237 ctermfg=249 gui=NONE guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=237 ctermfg=237 gui=NONE guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=225 gui=bold guibg=bg guifg=#ffdfff
    CSAHi Visual term=reverse cterm=NONE ctermbg=96 ctermfg=255 gui=NONE guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=Red
    CSAHi WildMenu term=NONE cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=60 ctermfg=255 gui=NONE guibg=#5f5f87 guifg=#eeeeee
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=214 ctermfg=234 gui=NONE guibg=#ffaf00 guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=252 ctermfg=234 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Error term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=184 ctermfg=16 gui=NONE guibg=#dfdf00 guifg=#000000
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#00afff
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi Constant term=NONE cterm=NONE ctermbg=bg ctermfg=229 gui=NONE guibg=bg guifg=#ffffaf
    CSAHi treeClosable term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi treeOpenable term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi treePart term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeDirSlash term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeLink term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=151 ctermfg=234 gui=NONE guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=181 ctermfg=234 gui=NONE guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=246 ctermfg=234 gui=NONE guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse cterm=NONE ctermbg=174 ctermfg=234 gui=NONE guibg=#df8787 guifg=bg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=248 gui=NONE guibg=Grey guifg=#a8a8a8
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=160 gui=undercurl guibg=bg guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#1c1c1c guifg=#d0d0d0
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=238 gui=NONE guibg=bg guifg=#444444
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi PreProc term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi Type term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#afafdf
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi htmlTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonExceptions term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi treeCWD term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=223 ctermfg=16 gui=NONE guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi djangoFilter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=243 ctermfg=255 gui=NONE guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=252 ctermfg=fg gui=NONE guibg=#d0d0d0 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=243 ctermfg=234 gui=reverse guibg=bg guifg=#767676
    CSAHi TabLine term=underline cterm=NONE ctermbg=241 ctermfg=252 gui=NONE guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=237 ctermfg=252 gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi htmlEndTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi htmlArg term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi htmlValue term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#dfdfaf
    CSAHi htmlTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoVarBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoTagBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=237 ctermfg=249 gui=NONE guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=237 ctermfg=237 gui=NONE guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=225 gui=bold guibg=bg guifg=#ffdfff
    CSAHi Visual term=reverse cterm=NONE ctermbg=96 ctermfg=255 gui=NONE guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=Red
    CSAHi WildMenu term=NONE cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=60 ctermfg=255 gui=NONE guibg=#5f5f87 guifg=#eeeeee
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=214 ctermfg=234 gui=NONE guibg=#ffaf00 guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=252 ctermfg=234 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Error term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=184 ctermfg=16 gui=NONE guibg=#dfdf00 guifg=#000000
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#00afff
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi Constant term=NONE cterm=NONE ctermbg=bg ctermfg=229 gui=NONE guibg=bg guifg=#ffffaf
    CSAHi treeClosable term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi treeOpenable term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi treePart term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeDirSlash term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeLink term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=151 ctermfg=234 gui=NONE guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=181 ctermfg=234 gui=NONE guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=246 ctermfg=234 gui=NONE guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse cterm=NONE ctermbg=174 ctermfg=234 gui=NONE guibg=#df8787 guifg=bg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=248 gui=NONE guibg=Grey guifg=#a8a8a8
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=160 gui=undercurl guibg=bg guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#1c1c1c guifg=#d0d0d0
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=238 gui=NONE guibg=bg guifg=#444444
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi PreProc term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi Type term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#afafdf
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi htmlTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonExceptions term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi treeCWD term=NONE cterm=NONE ctermbg=bg ctermfg=180 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=110 gui=NONE guibg=bg guifg=#87afdf
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=223 ctermfg=16 gui=NONE guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi djangoFilter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=243 ctermfg=255 gui=NONE guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=252 ctermfg=fg gui=NONE guibg=#d0d0d0 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=243 ctermfg=234 gui=reverse guibg=bg guifg=#767676
    CSAHi TabLine term=underline cterm=NONE ctermbg=241 ctermfg=252 gui=NONE guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=237 ctermfg=252 gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi htmlEndTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi htmlArg term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi htmlValue term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#dfdfaf
    CSAHi htmlTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoVarBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoTagBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=237 ctermfg=249 gui=NONE guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=237 ctermfg=237 gui=NONE guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=225 gui=bold guibg=bg guifg=#ffdfff
    CSAHi Visual term=reverse cterm=NONE ctermbg=96 ctermfg=255 gui=NONE guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=Red
    CSAHi WildMenu term=NONE cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=60 ctermfg=255 gui=NONE guibg=#5f5f87 guifg=#eeeeee
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=214 ctermfg=234 gui=NONE guibg=#ffaf00 guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=252 ctermfg=234 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Error term=NONE cterm=NONE ctermbg=88 ctermfg=231 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=184 ctermfg=16 gui=NONE guibg=#dfdf00 guifg=#000000
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#00afff
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi Constant term=NONE cterm=NONE ctermbg=bg ctermfg=229 gui=NONE guibg=bg guifg=#ffffaf
    CSAHi treeClosable term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#df8787
    CSAHi treeOpenable term=NONE cterm=NONE ctermbg=bg ctermfg=150 gui=NONE guibg=bg guifg=#afdf87
    CSAHi treePart term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeDirSlash term=NONE cterm=NONE ctermbg=bg ctermfg=244 gui=NONE guibg=bg guifg=#808080
    CSAHi treeLink term=NONE cterm=NONE ctermbg=bg ctermfg=182 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=233 ctermfg=247 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=151 ctermfg=234 gui=NONE guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=181 ctermfg=234 gui=NONE guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=246 ctermfg=234 gui=NONE guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse cterm=NONE ctermbg=174 ctermfg=234 gui=NONE guibg=#df8787 guifg=bg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=248 gui=NONE guibg=Grey guifg=#a8a8a8
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=160 gui=undercurl guibg=bg guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=86 gui=NONE guibg=#1c1c1c guifg=#d0d0d0
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=80 gui=NONE guibg=bg guifg=#444444
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi PreProc term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#afdf87
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#df8787
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=42 gui=NONE guibg=bg guifg=#87afdf
    CSAHi Type term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#afafdf
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#afdf87
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#df8787
    CSAHi htmlTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonExceptions term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi treeCWD term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#dfaf87
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=41 gui=NONE guibg=bg guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=84 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=42 gui=NONE guibg=bg guifg=#87afdf
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=32 ctermfg=79 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=74 ctermfg=16 gui=NONE guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=57 ctermfg=16 gui=NONE guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=84 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi djangoFilter term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=underline ctermbg=80 ctermfg=31 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=85 ctermfg=16 gui=NONE guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=82 ctermfg=87 gui=NONE guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=86 ctermfg=fg gui=NONE guibg=#d0d0d0 guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=82 ctermfg=80 gui=reverse guibg=bg guifg=#767676
    CSAHi TabLine term=underline cterm=NONE ctermbg=81 ctermfg=86 gui=NONE guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=80 ctermfg=86 gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#444444 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi htmlEndTag term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi htmlArg term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi htmlValue term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#dfdfaf
    CSAHi htmlTitle term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoVarBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoTagBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi djangoStatement term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=28 gui=bold guibg=bg guifg=Green
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=81 ctermfg=79 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=80 ctermfg=85 gui=NONE guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=80 ctermfg=80 gui=NONE guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=75 gui=bold guibg=bg guifg=#ffdfff
    CSAHi Visual term=reverse cterm=NONE ctermbg=37 ctermfg=87 gui=NONE guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=37 ctermfg=87 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=Red
    CSAHi WildMenu term=NONE cterm=bold ctermbg=57 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=37 ctermfg=87 gui=NONE guibg=#5f5f87 guifg=#eeeeee
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=72 ctermfg=80 gui=NONE guibg=#ffaf00 guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=86 ctermfg=80 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=38 ctermfg=87 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Error term=NONE cterm=NONE ctermbg=32 ctermfg=79 gui=NONE guibg=#800000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=56 ctermfg=16 gui=NONE guibg=#dfdf00 guifg=#000000
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=27 gui=underline guibg=bg guifg=#00afff
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#808080
    CSAHi Constant term=NONE cterm=NONE ctermbg=bg ctermfg=78 gui=NONE guibg=bg guifg=#ffffaf
    CSAHi treeClosable term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#df8787
    CSAHi treeOpenable term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#afdf87
    CSAHi treePart term=NONE cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#808080
    CSAHi treeDirSlash term=NONE cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#808080
    CSAHi treeLink term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#dfafdf
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=16 ctermfg=84 gui=NONE guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold cterm=NONE ctermbg=83 ctermfg=80 gui=NONE guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse cterm=NONE ctermbg=53 ctermfg=80 gui=NONE guibg=#df8787 guifg=bg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=84 gui=NONE guibg=Grey guifg=#a8a8a8
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=48 gui=undercurl guibg=bg guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse cterm=underline ctermbg=80 ctermfg=19 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse cterm=underline ctermbg=80 ctermfg=67 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
endif

if 1
    delcommand CSAHi
endif
