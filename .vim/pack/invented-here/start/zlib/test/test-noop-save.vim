set runtimepath^=~/.vim/pack/invented-here/start/zlib
runtime plugin/zlib.vim
edit ./test-noop-save.zlib
echomsg "After load: eol=" . &eol . " lines=" . line("$") . " last=" . string(getline("$"))
" Don't make any changes - just save (noop)
echomsg "Before write: no changes made"
write
qall!
