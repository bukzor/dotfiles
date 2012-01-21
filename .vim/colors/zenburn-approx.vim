" This scheme was created by CSApproxSnapshot
" on Sat, 21 Jan 2012

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

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
    CSAHi Normal term=NONE cterm=NONE ctermbg=237 ctermfg=188 gui=NONE guibg=#3f3f3f guifg=#dcdccc
    CSAHi Debug term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#bca3a3
    CSAHi Define term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Delimiter term=NONE cterm=NONE ctermbg=bg ctermfg=245 gui=NONE guibg=bg guifg=#8f8f8f
    CSAHi Exception term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi Float term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#c0bed1
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=228 gui=NONE guibg=bg guifg=#efef8f
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#efdcbc
    CSAHi Keyword term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Label term=NONE cterm=underline ctermbg=bg ctermfg=187 gui=underline guibg=bg guifg=#dfcfaf
    CSAHi Macro term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#e3ceab
    CSAHi StorageClass term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=238 ctermfg=151 gui=NONE guibg=#444444 guifg=#9ece9e
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=59 gui=bold guibg=bg guifg=#5b605e
    CSAHi Directory term=bold cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#9fafaf
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=236 ctermfg=115 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=59 ctermfg=228 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAHi Search term=reverse cterm=NONE ctermbg=22 ctermfg=230 gui=NONE guibg=#284f28 guifg=#ffffe0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#ffcfaf
    CSAHi LineNr term=underline cterm=NONE ctermbg=235 ctermfg=145 gui=NONE guibg=#262626 guifg=#9fafaf
    CSAHi Include term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#cfbfaf
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=108 gui=undercurl guibg=bg guifg=#9ccc9c guisp=#7cac7c
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=236 ctermfg=247 gui=NONE guibg=#2c2e2e guifg=#9f9f9f
    CSAHi PmenuSel term=NONE cterm=bold ctermbg=235 ctermfg=187 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=236 ctermfg=16 gui=NONE guibg=#2e3330 guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=16 ctermfg=145 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAHi TabLine term=underline cterm=NONE ctermbg=235 ctermfg=187 gui=NONE guibg=#222222 guifg=#d0d0b8
    CSAHi TabLineSel term=bold cterm=bold ctermbg=236 ctermfg=229 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=233 ctermfg=188 gui=NONE guibg=#101010 guifg=#dccdcc
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=239 ctermfg=fg gui=NONE guibg=#4f4f4f guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#434443 guifg=fg
    CSAHi Error term=NONE cterm=NONE ctermbg=59 ctermfg=167 gui=NONE guibg=#3d3535 guifg=#e37170
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=116 gui=NONE guibg=bg guifg=#8cd0d3
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#f0efd0
    CSAHi PreCondit term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi PreProc term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Repeat term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffd7a7
    CSAHi SpecialChar term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi SpecialComment term=NONE cterm=bold ctermbg=bg ctermfg=108 gui=bold guibg=bg guifg=#82a282
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=59 ctermfg=186 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=236 ctermfg=108 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAHi VertSplit term=reverse cterm=reverse ctermbg=236 ctermfg=65 gui=reverse guibg=#688060 guifg=#2e3330
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=255 gui=bold guibg=bg guifg=#efefef
    CSAHi Visual term=reverse cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2f2f2f guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=236 ctermfg=236 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#333333 guifg=#ffffff
    CSAHi WildMenu term=NONE cterm=underline ctermbg=236 ctermfg=194 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=bold ctermbg=109 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAHi lCursor term=NONE cterm=NONE ctermbg=188 ctermfg=237 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#dca3a3
    CSAHi Character term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=108 gui=italic guibg=bg guifg=#7f9f7f
    CSAHi Conditional term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Constant term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#cc9393
    CSAHi Structure term=NONE cterm=bold ctermbg=bg ctermfg=229 gui=bold guibg=bg guifg=#efefaf
    CSAHi Tag term=NONE cterm=bold ctermbg=bg ctermfg=174 gui=bold guibg=bg guifg=#e89393
    CSAHi Todo term=NONE cterm=bold ctermbg=237 ctermfg=253 gui=bold guibg=bg guifg=#dfdfdf
    CSAHi Typedef term=NONE cterm=bold ctermbg=bg ctermfg=188 gui=bold guibg=bg guifg=#dfe4cf
    CSAHi Type term=NONE cterm=bold ctermbg=bg ctermfg=187 gui=bold guibg=bg guifg=#dfdfbf
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=188 gui=underline guibg=bg guifg=#dcdccc
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi DiffAdd term=bold cterm=bold ctermbg=59 ctermfg=66 gui=bold guibg=#313c36 guifg=#709080
    CSAHi DiffChange term=bold cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#333333 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=238 ctermfg=236 gui=bold guibg=#464646 guifg=#333333
    CSAHi DiffText term=reverse cterm=bold ctermbg=59 ctermfg=217 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAHi SignColumn term=NONE cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#343434 guifg=#9fafaf
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=131 gui=undercurl guibg=bg guifg=#dc8c6c guisp=#bc6c4c
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=61 gui=undercurl guibg=bg guifg=#8c8cbc guisp=#6c6c9c
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=133 gui=undercurl guibg=bg guifg=#bc8cbc guisp=#bc6c9c
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=237 ctermfg=188 gui=NONE guibg=#3f3f3f guifg=#dcdccc
    CSAHi Debug term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#bca3a3
    CSAHi Define term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Delimiter term=NONE cterm=NONE ctermbg=bg ctermfg=245 gui=NONE guibg=bg guifg=#8f8f8f
    CSAHi Exception term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi Float term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#c0bed1
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=228 gui=NONE guibg=bg guifg=#efef8f
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#efdcbc
    CSAHi Keyword term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Label term=NONE cterm=underline ctermbg=bg ctermfg=187 gui=underline guibg=bg guifg=#dfcfaf
    CSAHi Macro term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#e3ceab
    CSAHi StorageClass term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=238 ctermfg=151 gui=NONE guibg=#444444 guifg=#9ece9e
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=59 gui=bold guibg=bg guifg=#5b605e
    CSAHi Directory term=bold cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#9fafaf
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=236 ctermfg=115 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=59 ctermfg=228 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAHi Search term=reverse cterm=NONE ctermbg=22 ctermfg=230 gui=NONE guibg=#284f28 guifg=#ffffe0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#ffcfaf
    CSAHi LineNr term=underline cterm=NONE ctermbg=235 ctermfg=145 gui=NONE guibg=#262626 guifg=#9fafaf
    CSAHi Include term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#cfbfaf
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=108 gui=undercurl guibg=bg guifg=#9ccc9c guisp=#7cac7c
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=236 ctermfg=247 gui=NONE guibg=#2c2e2e guifg=#9f9f9f
    CSAHi PmenuSel term=NONE cterm=bold ctermbg=235 ctermfg=187 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=236 ctermfg=16 gui=NONE guibg=#2e3330 guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=16 ctermfg=145 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAHi TabLine term=underline cterm=NONE ctermbg=235 ctermfg=187 gui=NONE guibg=#222222 guifg=#d0d0b8
    CSAHi TabLineSel term=bold cterm=bold ctermbg=236 ctermfg=229 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=233 ctermfg=188 gui=NONE guibg=#101010 guifg=#dccdcc
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=239 ctermfg=fg gui=NONE guibg=#4f4f4f guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#434443 guifg=fg
    CSAHi Error term=NONE cterm=NONE ctermbg=59 ctermfg=167 gui=NONE guibg=#3d3535 guifg=#e37170
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=116 gui=NONE guibg=bg guifg=#8cd0d3
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#f0efd0
    CSAHi PreCondit term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi PreProc term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Repeat term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffd7a7
    CSAHi SpecialChar term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi SpecialComment term=NONE cterm=bold ctermbg=bg ctermfg=108 gui=bold guibg=bg guifg=#82a282
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=59 ctermfg=186 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=236 ctermfg=108 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAHi VertSplit term=reverse cterm=reverse ctermbg=236 ctermfg=65 gui=reverse guibg=#688060 guifg=#2e3330
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=255 gui=bold guibg=bg guifg=#efefef
    CSAHi Visual term=reverse cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2f2f2f guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=236 ctermfg=236 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#333333 guifg=#ffffff
    CSAHi WildMenu term=NONE cterm=underline ctermbg=236 ctermfg=194 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=bold ctermbg=109 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAHi lCursor term=NONE cterm=NONE ctermbg=188 ctermfg=237 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#dca3a3
    CSAHi Character term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=108 gui=italic guibg=bg guifg=#7f9f7f
    CSAHi Conditional term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Constant term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#cc9393
    CSAHi Structure term=NONE cterm=bold ctermbg=bg ctermfg=229 gui=bold guibg=bg guifg=#efefaf
    CSAHi Tag term=NONE cterm=bold ctermbg=bg ctermfg=174 gui=bold guibg=bg guifg=#e89393
    CSAHi Todo term=NONE cterm=bold ctermbg=237 ctermfg=253 gui=bold guibg=bg guifg=#dfdfdf
    CSAHi Typedef term=NONE cterm=bold ctermbg=bg ctermfg=188 gui=bold guibg=bg guifg=#dfe4cf
    CSAHi Type term=NONE cterm=bold ctermbg=bg ctermfg=187 gui=bold guibg=bg guifg=#dfdfbf
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=188 gui=underline guibg=bg guifg=#dcdccc
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi DiffAdd term=bold cterm=bold ctermbg=59 ctermfg=66 gui=bold guibg=#313c36 guifg=#709080
    CSAHi DiffChange term=bold cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#333333 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=238 ctermfg=236 gui=bold guibg=#464646 guifg=#333333
    CSAHi DiffText term=reverse cterm=bold ctermbg=59 ctermfg=217 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAHi SignColumn term=NONE cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#343434 guifg=#9fafaf
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=131 gui=undercurl guibg=bg guifg=#dc8c6c guisp=#bc6c4c
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=61 gui=undercurl guibg=bg guifg=#8c8cbc guisp=#6c6c9c
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=133 gui=undercurl guibg=bg guifg=#bc8cbc guisp=#bc6c9c
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=237 ctermfg=188 gui=NONE guibg=#3f3f3f guifg=#dcdccc
    CSAHi Debug term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#bca3a3
    CSAHi Define term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Delimiter term=NONE cterm=NONE ctermbg=bg ctermfg=245 gui=NONE guibg=bg guifg=#8f8f8f
    CSAHi Exception term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi Float term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#c0bed1
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=228 gui=NONE guibg=bg guifg=#efef8f
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#efdcbc
    CSAHi Keyword term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Label term=NONE cterm=underline ctermbg=bg ctermfg=187 gui=underline guibg=bg guifg=#dfcfaf
    CSAHi Macro term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=187 gui=NONE guibg=bg guifg=#e3ceab
    CSAHi StorageClass term=NONE cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=238 ctermfg=151 gui=NONE guibg=#444444 guifg=#9ece9e
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=59 gui=bold guibg=bg guifg=#5b605e
    CSAHi Directory term=bold cterm=bold ctermbg=bg ctermfg=145 gui=bold guibg=bg guifg=#9fafaf
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=236 ctermfg=115 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=59 ctermfg=228 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAHi Search term=reverse cterm=NONE ctermbg=22 ctermfg=230 gui=NONE guibg=#284f28 guifg=#ffffe0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#ffcfaf
    CSAHi LineNr term=underline cterm=NONE ctermbg=235 ctermfg=145 gui=NONE guibg=#262626 guifg=#9fafaf
    CSAHi Include term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#cfbfaf
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=108 gui=undercurl guibg=bg guifg=#9ccc9c guisp=#7cac7c
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=236 ctermfg=247 gui=NONE guibg=#2c2e2e guifg=#9f9f9f
    CSAHi PmenuSel term=NONE cterm=bold ctermbg=235 ctermfg=187 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=236 ctermfg=16 gui=NONE guibg=#2e3330 guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=16 ctermfg=145 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAHi TabLine term=underline cterm=NONE ctermbg=235 ctermfg=187 gui=NONE guibg=#222222 guifg=#d0d0b8
    CSAHi TabLineSel term=bold cterm=bold ctermbg=236 ctermfg=229 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=233 ctermfg=188 gui=NONE guibg=#101010 guifg=#dccdcc
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=239 ctermfg=fg gui=NONE guibg=#4f4f4f guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=238 ctermfg=fg gui=NONE guibg=#434443 guifg=fg
    CSAHi Error term=NONE cterm=NONE ctermbg=59 ctermfg=167 gui=NONE guibg=#3d3535 guifg=#e37170
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=116 gui=NONE guibg=bg guifg=#8cd0d3
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#f0efd0
    CSAHi PreCondit term=NONE cterm=bold ctermbg=bg ctermfg=180 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi PreProc term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Repeat term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#ffd7a7
    CSAHi SpecialChar term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi SpecialComment term=NONE cterm=bold ctermbg=bg ctermfg=108 gui=bold guibg=bg guifg=#82a282
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=59 ctermfg=186 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=236 ctermfg=108 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAHi VertSplit term=reverse cterm=reverse ctermbg=236 ctermfg=65 gui=reverse guibg=#688060 guifg=#2e3330
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=255 gui=bold guibg=bg guifg=#efefef
    CSAHi Visual term=reverse cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2f2f2f guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=236 ctermfg=236 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#333333 guifg=#ffffff
    CSAHi WildMenu term=NONE cterm=underline ctermbg=236 ctermfg=194 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=bold ctermbg=109 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAHi lCursor term=NONE cterm=NONE ctermbg=188 ctermfg=237 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=181 gui=NONE guibg=bg guifg=#dca3a3
    CSAHi Character term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=108 gui=italic guibg=bg guifg=#7f9f7f
    CSAHi Conditional term=NONE cterm=bold ctermbg=bg ctermfg=223 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Constant term=NONE cterm=bold ctermbg=bg ctermfg=181 gui=bold guibg=bg guifg=#dca3a3
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=174 gui=NONE guibg=bg guifg=#cc9393
    CSAHi Structure term=NONE cterm=bold ctermbg=bg ctermfg=229 gui=bold guibg=bg guifg=#efefaf
    CSAHi Tag term=NONE cterm=bold ctermbg=bg ctermfg=174 gui=bold guibg=bg guifg=#e89393
    CSAHi Todo term=NONE cterm=bold ctermbg=237 ctermfg=253 gui=bold guibg=bg guifg=#dfdfdf
    CSAHi Typedef term=NONE cterm=bold ctermbg=bg ctermfg=188 gui=bold guibg=bg guifg=#dfe4cf
    CSAHi Type term=NONE cterm=bold ctermbg=bg ctermfg=187 gui=bold guibg=bg guifg=#dfdfbf
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=188 gui=underline guibg=bg guifg=#dcdccc
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=109 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi DiffAdd term=bold cterm=bold ctermbg=59 ctermfg=66 gui=bold guibg=#313c36 guifg=#709080
    CSAHi DiffChange term=bold cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#333333 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=238 ctermfg=236 gui=bold guibg=#464646 guifg=#333333
    CSAHi DiffText term=reverse cterm=bold ctermbg=59 ctermfg=217 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAHi SignColumn term=NONE cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#343434 guifg=#9fafaf
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=131 gui=undercurl guibg=bg guifg=#dc8c6c guisp=#bc6c4c
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=61 gui=undercurl guibg=bg guifg=#8c8cbc guisp=#6c6c9c
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=133 gui=undercurl guibg=bg guifg=#bc8cbc guisp=#bc6c9c
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=58 gui=NONE guibg=#3f3f3f guifg=#dcdccc
    CSAHi Debug term=NONE cterm=bold ctermbg=bg ctermfg=53 gui=bold guibg=bg guifg=#bca3a3
    CSAHi Define term=NONE cterm=bold ctermbg=bg ctermfg=74 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Delimiter term=NONE cterm=NONE ctermbg=bg ctermfg=83 gui=NONE guibg=bg guifg=#8f8f8f
    CSAHi Exception term=NONE cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi Float term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c0bed1
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=77 gui=NONE guibg=bg guifg=#efef8f
    CSAHi Identifier term=NONE cterm=NONE ctermbg=bg ctermfg=74 gui=NONE guibg=bg guifg=#efdcbc
    CSAHi Keyword term=NONE cterm=bold ctermbg=bg ctermfg=74 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Label term=NONE cterm=underline ctermbg=bg ctermfg=58 gui=underline guibg=bg guifg=#dfcfaf
    CSAHi Macro term=NONE cterm=bold ctermbg=bg ctermfg=74 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Statement term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#e3ceab
    CSAHi StorageClass term=NONE cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#c3bf9f
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=80 ctermfg=41 gui=NONE guibg=#444444 guifg=#9ece9e
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=81 gui=bold guibg=bg guifg=#5b605e
    CSAHi Directory term=bold cterm=bold ctermbg=bg ctermfg=42 gui=bold guibg=bg guifg=#9fafaf
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=80 ctermfg=41 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=20 ctermfg=77 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAHi Search term=reverse cterm=NONE ctermbg=20 ctermfg=78 gui=NONE guibg=#284f28 guifg=#ffffe0
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=79 gui=bold guibg=bg guifg=#ffffff
    CSAHi ModeMsg term=bold cterm=NONE ctermbg=bg ctermfg=74 gui=NONE guibg=bg guifg=#ffcfaf
    CSAHi LineNr term=underline cterm=NONE ctermbg=80 ctermfg=42 gui=NONE guibg=#262626 guifg=#9fafaf
    CSAHi Include term=NONE cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi Special term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#cfbfaf
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=37 gui=undercurl guibg=bg guifg=#9ccc9c guisp=#7cac7c
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=80 ctermfg=84 gui=NONE guibg=#2c2e2e guifg=#9f9f9f
    CSAHi PmenuSel term=NONE cterm=bold ctermbg=80 ctermfg=57 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=80 ctermfg=16 gui=NONE guibg=#2e3330 guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=16 ctermfg=41 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAHi TabLine term=underline cterm=NONE ctermbg=80 ctermfg=58 gui=NONE guibg=#222222 guifg=#d0d0b8
    CSAHi TabLineSel term=bold cterm=bold ctermbg=80 ctermfg=78 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=58 gui=NONE guibg=#101010 guifg=#dccdcc
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#4f4f4f guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#434443 guifg=fg
    CSAHi Error term=NONE cterm=NONE ctermbg=80 ctermfg=53 gui=NONE guibg=#3d3535 guifg=#e37170
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=42 gui=NONE guibg=bg guifg=#8cd0d3
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=78 gui=NONE guibg=bg guifg=#f0efd0
    CSAHi PreCondit term=NONE cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#dfaf8f
    CSAHi PreProc term=NONE cterm=bold ctermbg=bg ctermfg=74 gui=bold guibg=bg guifg=#ffcfaf
    CSAHi Repeat term=NONE cterm=bold ctermbg=bg ctermfg=73 gui=bold guibg=bg guifg=#ffd7a7
    CSAHi SpecialChar term=NONE cterm=bold ctermbg=bg ctermfg=53 gui=bold guibg=bg guifg=#dca3a3
    CSAHi SpecialComment term=NONE cterm=bold ctermbg=bg ctermfg=37 gui=bold guibg=bg guifg=#82a282
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=79 gui=bold guibg=bg guifg=#ffffff
    CSAHi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=80 ctermfg=57 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=80 ctermfg=41 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAHi VertSplit term=reverse cterm=reverse ctermbg=80 ctermfg=37 gui=reverse guibg=#688060 guifg=#2e3330
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=87 gui=bold guibg=bg guifg=#efefef
    CSAHi Visual term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#2f2f2f guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=80 ctermfg=80 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=80 ctermfg=79 gui=bold guibg=#333333 guifg=#ffffff
    CSAHi WildMenu term=NONE cterm=underline ctermbg=80 ctermfg=62 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAHi Folded term=NONE cterm=NONE ctermbg=80 ctermfg=41 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=fg gui=NONE guibg=DarkRed guifg=fg
    CSAHi Cursor term=NONE cterm=bold ctermbg=41 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAHi lCursor term=NONE cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=bold ctermbg=80 ctermfg=57 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#dca3a3
    CSAHi Character term=NONE cterm=bold ctermbg=bg ctermfg=53 gui=bold guibg=bg guifg=#dca3a3
    CSAHi Comment term=NONE cterm=NONE ctermbg=bg ctermfg=37 gui=italic guibg=bg guifg=#7f9f7f
    CSAHi Conditional term=NONE cterm=bold ctermbg=bg ctermfg=74 gui=bold guibg=bg guifg=#f0dfaf
    CSAHi Constant term=NONE cterm=bold ctermbg=bg ctermfg=53 gui=bold guibg=bg guifg=#dca3a3
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc9393
    CSAHi Structure term=NONE cterm=bold ctermbg=bg ctermfg=78 gui=bold guibg=bg guifg=#efefaf
    CSAHi Tag term=NONE cterm=bold ctermbg=bg ctermfg=69 gui=bold guibg=bg guifg=#e89393
    CSAHi Todo term=NONE cterm=bold ctermbg=80 ctermfg=87 gui=bold guibg=bg guifg=#dfdfdf
    CSAHi Typedef term=NONE cterm=bold ctermbg=bg ctermfg=58 gui=bold guibg=bg guifg=#dfe4cf
    CSAHi Type term=NONE cterm=bold ctermbg=bg ctermfg=58 gui=bold guibg=bg guifg=#dfdfbf
    CSAHi Underlined term=NONE cterm=underline ctermbg=bg ctermfg=58 gui=underline guibg=bg guifg=#dcdccc
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=80 ctermfg=41 gui=NONE guibg=#333333 guifg=#93b3a3
    CSAHi DiffAdd term=bold cterm=bold ctermbg=80 ctermfg=37 gui=bold guibg=#313c36 guifg=#709080
    CSAHi DiffChange term=bold cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#333333 guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=81 ctermfg=80 gui=bold guibg=#464646 guifg=#333333
    CSAHi DiffText term=reverse cterm=bold ctermbg=80 ctermfg=74 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAHi SignColumn term=NONE cterm=bold ctermbg=80 ctermfg=42 gui=bold guibg=#343434 guifg=#9fafaf
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=53 gui=undercurl guibg=bg guifg=#dc8c6c guisp=#bc6c4c
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=37 gui=undercurl guibg=bg guifg=#8c8cbc guisp=#6c6c9c
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=53 gui=undercurl guibg=bg guifg=#bc8cbc guisp=#bc6c9c
endif

if 1
    delcommand CSAHi
endif
