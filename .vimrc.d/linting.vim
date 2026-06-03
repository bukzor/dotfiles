" VSCode owns linting
if exists('g:vscode') | finish | endif

" ALE: Asynchronous Lint Engine {
let g:ale_linters = {'rust': ['analyzer']}
