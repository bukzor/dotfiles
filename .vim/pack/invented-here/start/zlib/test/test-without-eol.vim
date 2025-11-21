set runtimepath^=~/.vim/pack/invented-here/start/zlib
runtime plugin/zlib.vim
edit ./test-without-eol.zlib
echomsg "After load: eol=" . &eol . " lines=" . line("$") . " last=" . string(getline("$"))
call append(line("$")-1, "new line")
echomsg "Before write: eol=" . &eol . " lines=" . line("$") . " last=" . string(getline("$"))
write
qall!
