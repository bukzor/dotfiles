set nocompatible        " Use Vim defaults (much better!)
set mouse=vicrh

"search
set incsearch
set hlsearch
set ignorecase
set smartcase
set showcmd
set wrap

" os x backspace fix
set backspace=indent,eol,start

colorscheme evening
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set autoindent
"NOT smartindent

" be smarter about multiple buffers / vim instances
set hidden
set autoread
set shortmess+=IA

" Free cursor
set whichwrap=b,s,h,l,<,>,[,]

" better tab-completion
set wildmode=longest:full
set wildmenu

set laststatus=2
set scrolloff=2

" override those annoying commands I always mistype
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command QW q
:command Qw q

" Always gj, gk
nnoremap j gj
nnoremap k gk

set t_Co=256

nmap <tab> :bn<cr>
nmap <s-tab> :bp<cr>
"replacement for CTRL-I, also known as <tab>
nnoremap <C-P> <C-I>

"I never *mean* to press this
nmap Q q 


if &diff
	"vimdiff mode
	noremap n ]cz.
	noremap p [cz.
	noremap q :qall<cr>
	noremap r :e!<cr>
endif


au BufNewFile,BufRead *.js.tmpl set filetype=javascript
au BufNewFile,BufRead *.css.tmpl set filetype=css

"pathogen: http://www.vim.org/scripts/script.php?script_id=2332
call pathogen#infect() 

