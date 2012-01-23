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
    CSAhi Normal ctermbg=18 ctermfg=226 guibg=darkBlue guifg=yellow
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold cterm=bold ctermfg=250 gui=bold guifg=gray
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=51 guifg=cyan
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=231 ctermfg=16 guibg=white guifg=black
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=62 ctermfg=16 guibg=slateblue guifg=black
    CSAhi DiffChange term=bold ctermbg=22 ctermfg=16 guibg=darkGreen guifg=black
    CSAhi DiffDelete term=bold cterm=bold ctermbg=209 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse cterm=underline ctermbg=18 ctermfg=196 gui=underline guibg=darkBlue guifg=red
    CSAhi ErrorMsg term=standout ctermbg=18 ctermfg=214 guibg=darkBlue guifg=orange
    CSAhi FoldColumn term=standout ctermbg=239 ctermfg=16 guibg=gray30 guifg=black
    CSAhi Folded term=standout ctermbg=214 ctermfg=16 guibg=orange guifg=black
    CSAhi Identifier term=underline ctermfg=250 guifg=gray
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=18 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=226 ctermfg=16 gui=reverse guibg=yellow guifg=black
    CSAhi Label ctermfg=226 guifg=yellow
    CSAhi LineNr term=underline ctermfg=51 guifg=cyan
    CSAhi MatchParen term=reverse ctermbg=30 guibg=DarkCyan
    CSAhi ModeMsg term=bold ctermfg=226 guifg=yellow
    CSAhi MoreMsg term=bold ctermfg=226 guifg=yellow
    CSAhi NonText term=bold cterm=bold ctermfg=201 gui=bold guifg=magenta
    CSAhi Operator cterm=bold ctermfg=214 gui=bold guifg=orange
    CSAhi Pmenu ctermbg=201 guibg=Magenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=248 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=46 guifg=green
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=214 ctermfg=16 guibg=orange guifg=black
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=201 guifg=magenta
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=51 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=231 guifg=white
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=21 ctermfg=51 gui=bold guibg=blue guifg=cyan
    CSAhi StatusLineNC term=reverse ctermbg=21 ctermfg=16 guibg=blue guifg=black
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=231 gui=bold guifg=white
    CSAhi Todo term=standout ctermbg=214 ctermfg=16 guibg=orange guifg=black
    CSAhi Type term=underline cterm=bold ctermfg=214 gui=bold guifg=orange
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=51 gui=underline guifg=cyan
    CSAhi VertSplit term=reverse ctermbg=21 ctermfg=21 guibg=blue guifg=blue
    CSAhi Visual term=reverse ctermbg=30 ctermfg=16 guibg=darkCyan guifg=black
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermbg=18 ctermfg=51 gui=bold guibg=darkBlue guifg=cyan
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cIf0 ctermfg=250 guifg=gray
    CSAhi lCursor ctermbg=226 ctermfg=18 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=17 ctermfg=76 guibg=darkBlue guifg=yellow
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold cterm=bold ctermfg=85 gui=bold guifg=gray
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=31 guifg=cyan
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=79 ctermfg=16 guibg=white guifg=black
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=Grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=Grey40
    CSAhi DiffAdd term=bold ctermbg=38 ctermfg=16 guibg=slateblue guifg=black
    CSAhi DiffChange term=bold ctermbg=20 ctermfg=16 guibg=darkGreen guifg=black
    CSAhi DiffDelete term=bold cterm=bold ctermbg=69 ctermfg=16 gui=bold guibg=coral guifg=black
    CSAhi DiffText term=reverse cterm=bold ctermbg=36 ctermfg=16 gui=bold guibg=olivedrab guifg=black
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse cterm=underline ctermbg=17 ctermfg=64 gui=underline guibg=darkBlue guifg=red
    CSAhi ErrorMsg term=standout ctermbg=17 ctermfg=68 guibg=darkBlue guifg=orange
    CSAhi FoldColumn term=standout ctermbg=81 ctermfg=16 guibg=gray30 guifg=black
    CSAhi Folded term=standout ctermbg=68 ctermfg=16 guibg=orange guifg=black
    CSAhi Identifier term=underline ctermfg=85 guifg=gray
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=17 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse ctermbg=76 ctermfg=16 gui=reverse guibg=yellow guifg=black
    CSAhi Label ctermfg=76 guifg=yellow
    CSAhi LineNr term=underline ctermfg=31 guifg=cyan
    CSAhi MatchParen term=reverse ctermbg=21 guibg=DarkCyan
    CSAhi ModeMsg term=bold ctermfg=76 guifg=yellow
    CSAhi MoreMsg term=bold ctermfg=76 guifg=yellow
    CSAhi NonText term=bold cterm=bold ctermfg=67 gui=bold guifg=magenta
    CSAhi Operator cterm=bold ctermfg=68 gui=bold guifg=orange
    CSAhi Pmenu ctermbg=67 guibg=Magenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=84 guibg=DarkGrey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=28 guifg=green
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=68 ctermfg=16 guibg=orange guifg=black
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=67 guifg=magenta
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=31 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=79 guifg=white
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=19 ctermfg=31 gui=bold guibg=blue guifg=cyan
    CSAhi StatusLineNC term=reverse ctermbg=19 ctermfg=16 guibg=blue guifg=black
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=79 gui=bold guifg=white
    CSAhi Todo term=standout ctermbg=68 ctermfg=16 guibg=orange guifg=black
    CSAhi Type term=underline cterm=bold ctermfg=68 gui=bold guifg=orange
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=31 gui=underline guifg=cyan
    CSAhi VertSplit term=reverse ctermbg=19 ctermfg=19 guibg=blue guifg=blue
    CSAhi Visual term=reverse ctermbg=21 ctermfg=16 guibg=darkCyan guifg=black
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermbg=17 ctermfg=31 gui=bold guibg=darkBlue guifg=cyan
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi cIf0 ctermfg=85 guifg=gray
    CSAhi lCursor ctermbg=76 ctermfg=17 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
