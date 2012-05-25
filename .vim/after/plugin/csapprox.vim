" CSapprox: reproduce gvim colors in terminal vim..
if !exists('g:CSApprox_loaded')
    " CSApprox didn't load.
    " Fall back to pre-compiled color scheme, if possible.
    silent! execute 'colorscheme' colors_name.'-approx'
endif
" vim:et:sts=4:sw=4
