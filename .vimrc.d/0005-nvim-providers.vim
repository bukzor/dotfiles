" nvim providers {
    " Disable provider hosts we don't use. nvim still autoloads them on
    " demand without warnings; plugins that actually need a provider will
    " error at use time (specific, easier to diagnose than perpetual
    " startup warnings).
    "
    " Under vim these globals are unread and harmless.
    "
    " Python provider stays enabled — pynvim is installed in ~/.venv via
    " `( cd ~ && uv add pynvim )` and nvim finds it through that venv's
    " python3 executable.
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:loaded_ruby_provider = 0
" }
