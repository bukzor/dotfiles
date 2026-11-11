function! HiFile()
    " Create new buffer with highlight info
    new
    setlocal buftype=nofile
    
    redir @a
    silent highlight
    redir END
    put a
    
    " Clear any existing syntax
    syntax clear
    
    " Single pattern that captures both group name and its xxx
    syntax match HiGroup '^\(\w\+\)\(.*\)\@=\|xxx' contains=HiXXX
    syntax match HiXXX 'xxx' contained containedin=HiGroup
    
    " Create the highlight links
    for line in getline(1, '$')
        let parts = split(line)
        if len(parts) > 0
            let group = parts[0]
            exe 'highlight link HiXXX' . group . ' ' . group
            exe 'syntax match HiXXX' . group . ' /xxx/ contained containedin=HiGroup nextgroup=' . group
        endif
    endfor
endfunction

