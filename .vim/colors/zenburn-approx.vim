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
    CSAhi Normal ctermbg=237 ctermfg=188 guibg=#3f3f3f guifg=#dcdccc
    CSAhi Boolean ctermfg=181 guifg=#dca3a3
    CSAhi Character cterm=bold ctermfg=181 gui=bold guifg=#dca3a3
    CSAhi ColorColumn term=reverse ctermbg=217 guibg=LightRed
    CSAhi Comment term=bold cterm=underline ctermfg=108 gui=italic guifg=#7f9f7f
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional cterm=bold ctermfg=223 gui=bold guifg=#f0dfaf
    CSAhi Constant term=underline cterm=bold ctermfg=181 gui=bold guifg=#dca3a3
    CSAhi Cursor cterm=bold ctermbg=109 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAhi CursorColumn term=reverse ctermbg=239 guibg=#4f4f4f
    CSAhi CursorLine term=underline ctermbg=238 guibg=#434443
    CSAhi Debug cterm=bold ctermfg=145 gui=bold guifg=#bca3a3
    CSAhi Define cterm=bold ctermfg=223 gui=bold guifg=#ffcfaf
    CSAhi Delimiter ctermfg=245 guifg=#8f8f8f
    CSAhi DiffAdd term=bold cterm=bold ctermbg=59 ctermfg=66 gui=bold guibg=#313c36 guifg=#709080
    CSAhi DiffChange term=bold ctermbg=236 guibg=#333333
    CSAhi DiffDelete term=bold cterm=bold ctermbg=238 ctermfg=236 gui=bold guibg=#464646 guifg=#333333
    CSAhi DiffText term=reverse cterm=bold ctermbg=59 ctermfg=217 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAhi Directory term=bold cterm=bold ctermfg=145 gui=bold guifg=#9fafaf
    CSAhi Error term=reverse ctermbg=59 ctermfg=167 guibg=#3d3535 guifg=#e37170
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=236 ctermfg=115 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAhi Exception cterm=bold ctermfg=145 gui=bold guifg=#c3bf9f
    CSAhi Float ctermfg=146 guifg=#c0bed1
    CSAhi FoldColumn term=standout ctermbg=236 ctermfg=109 guibg=#333333 guifg=#93b3a3
    CSAhi Folded term=standout ctermbg=236 ctermfg=109 guibg=#333333 guifg=#93b3a3
    CSAhi Function ctermfg=228 guifg=#efef8f
    CSAhi Identifier term=underline ctermfg=223 guifg=#efdcbc
    CSAhi Ignore ctermfg=237 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=228 ctermfg=59 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAhi Include cterm=bold ctermfg=180 gui=bold guifg=#dfaf8f
    CSAhi Keyword cterm=bold ctermfg=223 gui=bold guifg=#f0dfaf
    CSAhi Label cterm=underline ctermfg=187 gui=underline guifg=#dfcfaf
    CSAhi LineNr term=underline ctermbg=235 ctermfg=145 guibg=#262626 guifg=#9fafaf
    CSAhi Macro cterm=bold ctermfg=223 gui=bold guifg=#ffcfaf
    CSAhi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAhi ModeMsg term=bold ctermfg=223 guifg=#ffcfaf
    CSAhi MoreMsg term=bold cterm=bold ctermfg=231 gui=bold guifg=#ffffff
    CSAhi NonText term=bold cterm=bold ctermfg=59 gui=bold guifg=#5b605e
    CSAhi Number ctermfg=116 guifg=#8cd0d3
    CSAhi Operator ctermfg=230 guifg=#f0efd0
    CSAhi Pmenu ctermbg=236 ctermfg=247 guibg=#2c2e2e guifg=#9f9f9f
    CSAhi PmenuSbar ctermbg=236 ctermfg=16 guibg=#2e3330 guifg=#000000
    CSAhi PmenuSel cterm=bold ctermbg=235 ctermfg=187 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAhi PmenuThumb cterm=reverse ctermbg=145 ctermfg=16 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAhi PreCondit cterm=bold ctermfg=180 gui=bold guifg=#dfaf8f
    CSAhi PreProc term=underline cterm=bold ctermfg=223 gui=bold guifg=#ffcfaf
    CSAhi Question term=standout cterm=bold ctermfg=231 gui=bold guifg=#ffffff
    CSAhi Repeat cterm=bold ctermfg=223 gui=bold guifg=#ffd7a7
    CSAhi Search term=reverse ctermbg=22 ctermfg=230 guibg=#284f28 guifg=#ffffe0
    CSAhi SignColumn term=standout cterm=bold ctermbg=236 ctermfg=145 gui=bold guibg=#343434 guifg=#9fafaf
    CSAhi Special term=bold ctermfg=181 guifg=#cfbfaf
    CSAhi SpecialChar cterm=bold ctermfg=181 gui=bold guifg=#dca3a3
    CSAhi SpecialComment cterm=bold ctermfg=108 gui=bold guifg=#82a282
    CSAhi SpecialKey term=bold ctermbg=238 ctermfg=151 guibg=#444444 guifg=#9ece9e
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=131 gui=undercurl guifg=#dc8c6c guisp=#bc6c4c
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=61 gui=undercurl guifg=#8c8cbc guisp=#6c6c9c
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=108 gui=undercurl guifg=#9ccc9c guisp=#7cac7c
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=133 gui=undercurl guifg=#bc8cbc guisp=#bc6c9c
    CSAhi Statement term=bold ctermfg=187 guifg=#e3ceab
    CSAhi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=186 ctermfg=59 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAhi StatusLineNC term=reverse cterm=reverse ctermbg=108 ctermfg=236 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAhi StorageClass cterm=bold ctermfg=145 gui=bold guifg=#c3bf9f
    CSAhi String ctermfg=174 guifg=#cc9393
    CSAhi Structure cterm=bold ctermfg=229 gui=bold guifg=#efefaf
    CSAhi TabLine term=underline ctermbg=235 ctermfg=187 guibg=#222222 guifg=#d0d0b8
    CSAhi TabLineFill term=reverse ctermbg=233 ctermfg=188 guibg=#101010 guifg=#dccdcc
    CSAhi TabLineSel term=bold cterm=bold ctermbg=236 ctermfg=229 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAhi Tag cterm=bold ctermfg=174 gui=bold guifg=#e89393
    CSAhi Title term=bold cterm=bold ctermfg=255 gui=bold guifg=#efefef
    CSAhi Todo term=standout cterm=bold ctermbg=237 ctermfg=253 gui=bold guibg=bg guifg=#dfdfdf
    CSAhi Type term=underline cterm=bold ctermfg=187 gui=bold guifg=#dfdfbf
    CSAhi Typedef cterm=bold ctermfg=188 gui=bold guifg=#dfe4cf
    CSAhi Underlined term=underline cterm=underline ctermfg=188 gui=underline guifg=#dcdccc
    CSAhi VertSplit term=reverse cterm=reverse ctermbg=65 ctermfg=236 gui=reverse guibg=#688060 guifg=#2e3330
    CSAhi Visual term=reverse ctermbg=236 guibg=#2f2f2f
    CSAhi VisualNOS term=bold,underline cterm=bold,underline ctermbg=236 ctermfg=236 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAhi WarningMsg term=standout cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#333333 guifg=#ffffff
    CSAhi WildMenu term=standout cterm=underline ctermbg=236 ctermfg=194 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAhi lCursor ctermbg=188 ctermfg=237 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=58 guibg=#3f3f3f guifg=#dcdccc
    CSAhi Boolean ctermfg=53 guifg=#dca3a3
    CSAhi Character cterm=bold ctermfg=53 gui=bold guifg=#dca3a3
    CSAhi ColorColumn term=reverse ctermbg=74 guibg=LightRed
    CSAhi Comment term=bold cterm=underline ctermfg=37 gui=italic guifg=#7f9f7f
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Conditional cterm=bold ctermfg=74 gui=bold guifg=#f0dfaf
    CSAhi Constant term=underline cterm=bold ctermfg=53 gui=bold guifg=#dca3a3
    CSAhi Cursor cterm=bold ctermbg=41 ctermfg=16 gui=bold guibg=#8faf9f guifg=#000d18
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=#4f4f4f
    CSAhi CursorLine term=underline ctermbg=80 guibg=#434443
    CSAhi Debug cterm=bold ctermfg=53 gui=bold guifg=#bca3a3
    CSAhi Define cterm=bold ctermfg=74 gui=bold guifg=#ffcfaf
    CSAhi Delimiter ctermfg=83 guifg=#8f8f8f
    CSAhi DiffAdd term=bold cterm=bold ctermbg=80 ctermfg=37 gui=bold guibg=#313c36 guifg=#709080
    CSAhi DiffChange term=bold ctermbg=80 guibg=#333333
    CSAhi DiffDelete term=bold cterm=bold ctermbg=81 ctermfg=80 gui=bold guibg=#464646 guifg=#333333
    CSAhi DiffText term=reverse cterm=bold ctermbg=80 ctermfg=74 gui=bold guibg=#41363c guifg=#ecbcbc
    CSAhi Directory term=bold cterm=bold ctermfg=42 gui=bold guifg=#9fafaf
    CSAhi Error term=reverse ctermbg=80 ctermfg=53 guibg=#3d3535 guifg=#e37170
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=80 ctermfg=41 gui=bold guibg=#2f2f2f guifg=#80d4aa
    CSAhi Exception cterm=bold ctermfg=57 gui=bold guifg=#c3bf9f
    CSAhi Float ctermfg=58 guifg=#c0bed1
    CSAhi FoldColumn term=standout ctermbg=80 ctermfg=41 guibg=#333333 guifg=#93b3a3
    CSAhi Folded term=standout ctermbg=80 ctermfg=41 guibg=#333333 guifg=#93b3a3
    CSAhi Function ctermfg=77 guifg=#efef8f
    CSAhi Identifier term=underline ctermfg=74 guifg=#efdcbc
    CSAhi Ignore ctermfg=80 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=77 ctermfg=20 gui=reverse guibg=#f8f893 guifg=#385f38
    CSAhi Include cterm=bold ctermfg=57 gui=bold guifg=#dfaf8f
    CSAhi Keyword cterm=bold ctermfg=74 gui=bold guifg=#f0dfaf
    CSAhi Label cterm=underline ctermfg=58 gui=underline guifg=#dfcfaf
    CSAhi LineNr term=underline ctermbg=80 ctermfg=42 guibg=#262626 guifg=#9fafaf
    CSAhi Macro cterm=bold ctermfg=74 gui=bold guifg=#ffcfaf
    CSAhi MatchParen term=reverse cterm=bold ctermbg=80 ctermfg=57 gui=bold guibg=#2e2e2e guifg=#b2b2a0
    CSAhi ModeMsg term=bold ctermfg=74 guifg=#ffcfaf
    CSAhi MoreMsg term=bold cterm=bold ctermfg=79 gui=bold guifg=#ffffff
    CSAhi NonText term=bold cterm=bold ctermfg=81 gui=bold guifg=#5b605e
    CSAhi Number ctermfg=42 guifg=#8cd0d3
    CSAhi Operator ctermfg=78 guifg=#f0efd0
    CSAhi Pmenu ctermbg=80 ctermfg=84 guibg=#2c2e2e guifg=#9f9f9f
    CSAhi PmenuSbar ctermbg=80 ctermfg=16 guibg=#2e3330 guifg=#000000
    CSAhi PmenuSel cterm=bold ctermbg=80 ctermfg=57 gui=bold guibg=#242424 guifg=#d0d0a0
    CSAhi PmenuThumb cterm=reverse ctermbg=41 ctermfg=16 gui=reverse guibg=#a0afa0 guifg=#040404
    CSAhi PreCondit cterm=bold ctermfg=57 gui=bold guifg=#dfaf8f
    CSAhi PreProc term=underline cterm=bold ctermfg=74 gui=bold guifg=#ffcfaf
    CSAhi Question term=standout cterm=bold ctermfg=79 gui=bold guifg=#ffffff
    CSAhi Repeat cterm=bold ctermfg=73 gui=bold guifg=#ffd7a7
    CSAhi Search term=reverse ctermbg=20 ctermfg=78 guibg=#284f28 guifg=#ffffe0
    CSAhi SignColumn term=standout cterm=bold ctermbg=80 ctermfg=42 gui=bold guibg=#343434 guifg=#9fafaf
    CSAhi Special term=bold ctermfg=58 guifg=#cfbfaf
    CSAhi SpecialChar cterm=bold ctermfg=53 gui=bold guifg=#dca3a3
    CSAhi SpecialComment cterm=bold ctermfg=37 gui=bold guifg=#82a282
    CSAhi SpecialKey term=bold ctermbg=80 ctermfg=41 guibg=#444444 guifg=#9ece9e
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=53 gui=undercurl guifg=#dc8c6c guisp=#bc6c4c
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=37 gui=undercurl guifg=#8c8cbc guisp=#6c6c9c
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=37 gui=undercurl guifg=#9ccc9c guisp=#7cac7c
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=53 gui=undercurl guifg=#bc8cbc guisp=#bc6c9c
    CSAhi Statement term=bold ctermfg=57 guifg=#e3ceab
    CSAhi StatusLine term=bold,reverse cterm=bold,reverse ctermbg=57 ctermfg=80 gui=bold,reverse guibg=#ccdc90 guifg=#313633
    CSAhi StatusLineNC term=reverse cterm=reverse ctermbg=41 ctermfg=80 gui=reverse guibg=#88b090 guifg=#2e3330
    CSAhi StorageClass cterm=bold ctermfg=57 gui=bold guifg=#c3bf9f
    CSAhi String ctermfg=53 guifg=#cc9393
    CSAhi Structure cterm=bold ctermfg=78 gui=bold guifg=#efefaf
    CSAhi TabLine term=underline ctermbg=80 ctermfg=58 guibg=#222222 guifg=#d0d0b8
    CSAhi TabLineFill term=reverse ctermbg=16 ctermfg=58 guibg=#101010 guifg=#dccdcc
    CSAhi TabLineSel term=bold cterm=bold ctermbg=80 ctermfg=78 gui=bold guibg=#333333 guifg=#f0f0b0
    CSAhi Tag cterm=bold ctermfg=69 gui=bold guifg=#e89393
    CSAhi Title term=bold cterm=bold ctermfg=87 gui=bold guifg=#efefef
    CSAhi Todo term=standout cterm=bold ctermbg=80 ctermfg=87 gui=bold guibg=bg guifg=#dfdfdf
    CSAhi Type term=underline cterm=bold ctermfg=58 gui=bold guifg=#dfdfbf
    CSAhi Typedef cterm=bold ctermfg=58 gui=bold guifg=#dfe4cf
    CSAhi Underlined term=underline cterm=underline ctermfg=58 gui=underline guifg=#dcdccc
    CSAhi VertSplit term=reverse cterm=reverse ctermbg=37 ctermfg=80 gui=reverse guibg=#688060 guifg=#2e3330
    CSAhi Visual term=reverse ctermbg=80 guibg=#2f2f2f
    CSAhi VisualNOS term=bold,underline cterm=bold,underline ctermbg=80 ctermfg=80 gui=bold,underline guibg=#2f2f2f guifg=#333333
    CSAhi WarningMsg term=standout cterm=bold ctermbg=80 ctermfg=79 gui=bold guibg=#333333 guifg=#ffffff
    CSAhi WildMenu term=standout cterm=underline ctermbg=80 ctermfg=62 gui=underline guibg=#2c302d guifg=#cbecd0
    CSAhi lCursor ctermbg=58 ctermfg=80 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
