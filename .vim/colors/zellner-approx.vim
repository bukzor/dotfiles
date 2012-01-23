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
    CSAhi Normal ctermbg=231 ctermfg=16 guibg=white guifg=black
    CSAhi ColorColumn term=reverse ctermbg=217 guibg=LightRed
    CSAhi Comment term=bold ctermfg=196 guifg=Red
      CSAlink MoreMsg Comment
      CSAlink Question Comment
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=201 guifg=Magenta
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=16 ctermfg=231 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=254 guibg=Grey90
    CSAhi CursorLine term=underline ctermbg=254 guibg=Grey90
    CSAhi DiffAdd term=bold ctermbg=152 guibg=LightBlue
    CSAhi DiffChange term=bold ctermbg=219 guibg=LightMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=LightCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=21 guifg=Blue
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=252 ctermfg=18 guibg=LightGrey guifg=DarkBlue
    CSAhi Identifier term=underline ctermfg=21 guifg=Blue
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=231 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=124 guifg=Brown
    CSAhi MatchParen term=reverse ctermbg=51 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi NonText term=bold cterm=bold ctermfg=21 gui=bold guifg=Blue
    CSAhi Pmenu ctermbg=219 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=250 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=129 guifg=Purple
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Search term=reverse ctermbg=51 ctermfg=16 guibg=Cyan guifg=Black
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=201 guifg=Magenta
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
    CSAhi SpecialKey term=bold ctermfg=21 guifg=Blue
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=30 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=124 guifg=Brown
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=248 ctermfg=226 guibg=DarkGray guifg=Yellow
    CSAhi StatusLineNC term=reverse cterm=reverse gui=reverse
    CSAhi TabLine term=underline cterm=underline ctermbg=252 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Tag term=bold ctermfg=22 guifg=DarkGreen
    CSAhi Title term=bold cterm=bold ctermfg=201 gui=bold guifg=Magenta
    CSAhi Todo term=standout ctermbg=226 ctermfg=21 guibg=Yellow guifg=Blue
    CSAhi Type term=underline ctermfg=21 guifg=Blue
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=62 gui=underline guifg=SlateBlue
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
      CSAlink ErrorMsg Visual
      CSAlink WarningMsg Visual
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=16 ctermfg=231 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=79 ctermfg=16 guibg=white guifg=black
    CSAhi ColorColumn term=reverse ctermbg=74 guibg=LightRed
    CSAhi Comment term=bold ctermfg=64 guifg=Red
      CSAlink MoreMsg Comment
      CSAlink Question Comment
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=67 guifg=Magenta
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=16 ctermfg=79 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=87 guibg=Grey90
    CSAhi CursorLine term=underline ctermbg=87 guibg=Grey90
    CSAhi DiffAdd term=bold ctermbg=58 guibg=LightBlue
    CSAhi DiffChange term=bold ctermbg=75 guibg=LightMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=63 ctermfg=19 gui=bold guibg=LightCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=19 guifg=Blue
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=86 ctermfg=17 guibg=LightGrey guifg=DarkBlue
    CSAhi Identifier term=underline ctermfg=19 guifg=Blue
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=79 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=32 guifg=Brown
    CSAhi MatchParen term=reverse ctermbg=31 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi NonText term=bold cterm=bold ctermfg=19 gui=bold guifg=Blue
    CSAhi Pmenu ctermbg=75 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=85 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=35 guifg=Purple
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Search term=reverse ctermbg=31 ctermfg=16 guibg=Cyan guifg=Black
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=67 guifg=Magenta
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
    CSAhi SpecialKey term=bold ctermfg=19 guifg=Blue
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=21 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=32 guifg=Brown
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse ctermbg=84 ctermfg=76 guibg=DarkGray guifg=Yellow
    CSAhi StatusLineNC term=reverse cterm=reverse gui=reverse
    CSAhi TabLine term=underline cterm=underline ctermbg=86 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Tag term=bold ctermfg=20 guifg=DarkGreen
    CSAhi Title term=bold cterm=bold ctermfg=67 gui=bold guifg=Magenta
    CSAhi Todo term=standout ctermbg=76 ctermfg=19 guibg=Yellow guifg=Blue
    CSAhi Type term=underline ctermfg=19 guifg=Blue
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=38 gui=underline guifg=SlateBlue
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
      CSAlink ErrorMsg Visual
      CSAlink WarningMsg Visual
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=16 ctermfg=79 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
