" nvim providers {
    " Disable provider hosts we don't use. nvim still autoloads them on
    " demand without warnings; plugins that actually need a provider will
    " error at use time (specific, easier to diagnose than perpetual
    " startup warnings).
    "
    " Under vim these globals are unread and harmless.
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:loaded_ruby_provider = 0

    " Pin the python3 provider's interpreter — bypass PATH discovery so
    " the :python3 RPC bridge always uses ~/.venv (where pynvim is
    " installed via `( cd ~ && uv add --dev pynvim )`), regardless of
    " the venv/CWD nvim was launched from. This only affects the bridge
    " process; LSP (basedpyright), linters (nvim-lint), formatters
    " (conform), and !shell escapes use their own python discovery.
    let g:python3_host_prog = expand('~/.venv/bin/python3')
" }
