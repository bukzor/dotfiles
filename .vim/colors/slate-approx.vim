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
    CSAhi Normal ctermbg=235 ctermfg=231 guibg=grey15 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=241 guifg=grey40
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=217 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
    CSAhi Cursor ctermbg=222 ctermfg=66 guibg=khaki guifg=slategrey
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=Grey40
    CSAhi Define cterm=bold ctermfg=220 gui=bold guifg=gold
    CSAhi DiffAdd term=bold ctermbg=18 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=90 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=16 ctermfg=236 guibg=black guifg=grey20
    CSAhi Folded term=standout ctermbg=16 ctermfg=241 guibg=black guifg=grey40
    CSAhi Function ctermfg=223 guifg=navajowhite
    CSAhi Identifier term=underline ctermfg=209 guifg=salmon
    CSAhi Ignore ctermfg=241 guifg=grey40
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=16 ctermfg=46 gui=reverse guibg=black guifg=green
    CSAhi Include ctermfg=196 guifg=red
    CSAhi LineNr term=underline ctermfg=244 guifg=grey50
    CSAhi MatchParen term=reverse ctermbg=30 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=178 gui=bold guifg=goldenrod
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=235 ctermfg=62 gui=bold guibg=grey15 guifg=RoyalBlue
    CSAhi Operator ctermfg=196 guifg=Red
    CSAhi Pmenu ctermbg=201 guibg=Magenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=248 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermbg=231 ctermfg=196 guibg=white guifg=red
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=48 gui=bold guifg=springgreen
    CSAhi Search term=reverse ctermbg=173 ctermfg=223 guibg=peru guifg=wheat
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=143 guifg=darkkhaki
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=113 guifg=yellowgreen
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellErrors ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=69 gui=bold guifg=CornflowerBlue
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=145 ctermfg=16 guibg=#c2bfa5 guifg=black
    CSAhi StatusLineNC term=reverse ctermbg=145 ctermfg=241 guibg=#c2bfa5 guifg=grey40
    CSAhi String ctermfg=116 guifg=SkyBlue
    CSAhi Structure ctermfg=46 guifg=green
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=220 gui=bold guifg=gold
    CSAhi Todo term=standout ctermbg=226 ctermfg=202 guibg=yellow2 guifg=orangered
    CSAhi Type term=underline cterm=bold ctermfg=69 gui=bold guifg=CornflowerBlue
      CSAlink StorageClass Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=145 ctermfg=241 guibg=#c2bfa5 guifg=grey40
    CSAhi Visual term=reverse ctermbg=64 ctermfg=222 guibg=olivedrab guifg=khaki
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=209 guifg=salmon
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=231 ctermfg=235 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=79 guibg=grey15 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=81 guifg=grey40
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=69 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
    CSAhi Cursor ctermbg=73 ctermfg=37 guibg=khaki guifg=slategrey
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=Grey40
    CSAhi Define cterm=bold ctermfg=72 gui=bold guifg=gold
    CSAhi DiffAdd term=bold ctermbg=17 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=33 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=16 ctermfg=80 guibg=black guifg=grey20
    CSAhi Folded term=standout ctermbg=16 ctermfg=81 guibg=black guifg=grey40
    CSAhi Function ctermfg=74 guifg=navajowhite
    CSAhi Identifier term=underline ctermfg=69 guifg=salmon
    CSAhi Ignore ctermfg=81 guifg=grey40
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=16 ctermfg=28 gui=reverse guibg=black guifg=green
    CSAhi Include ctermfg=64 guifg=red
    CSAhi LineNr term=underline ctermfg=82 guifg=grey50
    CSAhi MatchParen term=reverse ctermbg=21 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=52 gui=bold guifg=goldenrod
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=80 ctermfg=22 gui=bold guibg=grey15 guifg=RoyalBlue
    CSAhi Operator ctermfg=64 guifg=Red
    CSAhi Pmenu ctermbg=67 guibg=Magenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=84 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermbg=79 ctermfg=64 guibg=white guifg=red
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=29 gui=bold guifg=springgreen
    CSAhi Search term=reverse ctermbg=52 ctermfg=74 guibg=peru guifg=wheat
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=57 guifg=darkkhaki
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=40 guifg=yellowgreen
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellErrors ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=39 gui=bold guifg=CornflowerBlue
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=57 ctermfg=16 guibg=#c2bfa5 guifg=black
    CSAhi StatusLineNC term=reverse ctermbg=57 ctermfg=81 guibg=#c2bfa5 guifg=grey40
    CSAhi String ctermfg=43 guifg=SkyBlue
    CSAhi Structure ctermfg=28 guifg=green
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=72 gui=bold guifg=gold
    CSAhi Todo term=standout ctermbg=76 ctermfg=64 guibg=yellow2 guifg=orangered
    CSAhi Type term=underline cterm=bold ctermfg=39 gui=bold guifg=CornflowerBlue
      CSAlink StorageClass Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=57 ctermfg=81 guibg=#c2bfa5 guifg=grey40
    CSAhi Visual term=reverse ctermbg=36 ctermfg=73 guibg=olivedrab guifg=khaki
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=69 guifg=salmon
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=79 ctermfg=80 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
