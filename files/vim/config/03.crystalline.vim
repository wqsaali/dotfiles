" function! FTIcon(text)
"   return winwidth(0) > 70 ? ( strlen(&filetype) ?  (a:text ? (&filetype . ' ' ) : '') . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
" endfunction
"
" function! FFIcon(text)
"   return winwidth(0) > 70 ? ( (a:text ? ( &fileformat . ' ' ) : '') . WebDevIconsGetFileFormatSymbol()) : ''
" endfunction
"
" function! StatusDiagnostic() abort
"   let info = get(b:, 'coc_diagnostic_info', {})
"   if empty(info) | return '' | endif
"   let msgs = []
"   if get(info, 'error', 0)
"     call add(msgs, ' E:' . info['error'])
"   endif
"   if get(info, 'warning', 0)
"     call add(msgs, ' W:' . info['warning'])
"   endif
"   return join(msgs, ''). ' ' . get(g:, 'coc_status', '')
" endfunction
"
" function! StatusLine(current, width)
"   let l:s = ''
"
"   if a:current
"     let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
"   else
"     let l:s .= '%#CrystallineInactive#'
"   endif
"   let l:s .= ' %f%h%w%m%r '
"   if a:current
"     let l:s .= crystalline#right_sep('', 'Fill')." \ue0a0 ".'%{fugitive#head()}'
"   endif
"
"   let l:s .= '%='
"   if a:current
"     let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
"     let l:s .= crystalline#left_mode_sep('')
"   endif
"   if a:width > 80
"     let l:s .= ' %{FTIcon(1)} [%{&fenc!=#""?&fenc:&enc}][%{FFIcon(1)} ] %l/%L %c%V %P '
"   else
"     let l:s .= ' '
"   endif
"   if a:current
"     " let l:s = crystalline#left_sep('ReplaceMode',crystalline#mode_hi()).'%{coc#status()}'
"     let l:s .= crystalline#left_sep('ReplaceMode',crystalline#mode_hi()).'%{StatusDiagnostic()}'
"   endif
"
"   return l:s
" endfunction
"
" function! TabLabel(buf, max_width) abort
"     let [l:left, l:name, l:short_name, l:right] = crystalline#default_tablabel_parts(a:buf, a:max_width)
"     return l:left . l:short_name . ' ' . WebDevIconsGetFileTypeSymbol(l:name) . (l:right ==# ' ' ? '' : ' ') . l:right
" endfunction
"
" function! TabLine()
"   let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
"   let l:right = '%=%#CrystallineTab# ' . l:vimlabel . FTIcon(0) . ' ' . FFIcon(0)
"   "return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
"   return crystalline#bufferline(2, len(l:vimlabel), 1, 1, 'TabLabel', crystalline#default_tabwidth() + 3) . l:right
" endfunction
"
" let g:crystalline_enable_sep = 1
" let g:crystalline_statusline_fn = 'StatusLine'
" let g:crystalline_tabline_fn = 'TabLine'
" let g:crystalline_theme = 'default'
"
" set showtabline=2
" set guioptions-=e
" set laststatus=2
