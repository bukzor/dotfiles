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
    CSAhi Normal ctermbg=236 ctermfg=231 guibg=grey20 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=116 guifg=SkyBlue
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=217 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=222 ctermfg=66 guibg=khaki guifg=slategrey
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=18 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=90 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=239 ctermfg=180 guibg=grey30 guifg=tan
    CSAhi Folded term=standout ctermbg=239 ctermfg=220 guibg=grey30 guifg=gold
    CSAhi Identifier term=underline ctermfg=120 guifg=palegreen
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=241 guifg=grey40
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=222 ctermfg=66 gui=reverse guibg=khaki guifg=slategrey
    CSAhi LineNr term=underline ctermfg=226 guifg=Yellow
    CSAhi MatchParen term=reverse ctermbg=30 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=178 gui=bold guifg=goldenrod
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=239 ctermfg=152 gui=bold guibg=grey30 guifg=LightBlue
    CSAhi Pmenu ctermbg=201 guibg=Magenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=248 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=167 guifg=indianred
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=48 gui=bold guifg=springgreen
    CSAhi Search term=reverse ctermbg=173 ctermfg=223 guibg=peru guifg=wheat
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=223 guifg=navajowhite
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=113 guifg=yellowgreen
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=222 gui=bold guifg=khaki
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=145 ctermfg=16 guibg=#c2bfa5 guifg=black
    CSAhi StatusLineNC term=reverse ctermbg=145 ctermfg=244 guibg=#c2bfa5 guifg=grey50
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=167 gui=bold guifg=indianred
    CSAhi Todo term=standout ctermbg=226 ctermfg=202 guibg=yellow2 guifg=orangered
    CSAhi Type term=underline cterm=bold ctermfg=143 gui=bold guifg=darkkhaki
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=145 ctermfg=244 guibg=#c2bfa5 guifg=grey50
    CSAhi Visual term=reverse ctermbg=64 ctermfg=222 guibg=olivedrab guifg=khaki
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=209 guifg=salmon
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=231 ctermfg=236 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=79 guibg=grey20 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=43 guifg=SkyBlue
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=69 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=73 ctermfg=37 guibg=khaki guifg=slategrey
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=17 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=33 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=81 ctermfg=57 guibg=grey30 guifg=tan
    CSAhi Folded term=standout ctermbg=81 ctermfg=72 guibg=grey30 guifg=gold
    CSAhi Identifier term=underline ctermfg=45 guifg=palegreen
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=81 guifg=grey40
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=73 ctermfg=37 gui=reverse guibg=khaki guifg=slategrey
    CSAhi LineNr term=underline ctermfg=76 guifg=Yellow
    CSAhi MatchParen term=reverse ctermbg=21 guibg=DarkCyan
    CSAhi ModeMsg term=bold cterm=bold ctermfg=52 gui=bold guifg=goldenrod
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=81 ctermfg=58 gui=bold guibg=grey30 guifg=LightBlue
    CSAhi Pmenu ctermbg=67 guibg=Magenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=84 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=53 guifg=indianred
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=29 gui=bold guifg=springgreen
    CSAhi Search term=reverse ctermbg=52 ctermfg=74 guibg=peru guifg=wheat
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=74 guifg=navajowhite
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=40 guifg=yellowgreen
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=73 gui=bold guifg=khaki
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=57 ctermfg=16 guibg=#c2bfa5 guifg=black
    CSAhi StatusLineNC term=reverse ctermbg=57 ctermfg=82 guibg=#c2bfa5 guifg=grey50
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=53 gui=bold guifg=indianred
    CSAhi Todo term=standout ctermbg=76 ctermfg=64 guibg=yellow2 guifg=orangered
    CSAhi Type term=underline cterm=bold ctermfg=57 gui=bold guifg=darkkhaki
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=57 ctermfg=82 guibg=#c2bfa5 guifg=grey50
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
