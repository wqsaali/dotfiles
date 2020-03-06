" ColorThemes {{{
  highlight clear
  set background=dark
  set t_Co=256

  " Overrides {{{
  if has('autocmd')
    " au ColorScheme * hi! link illuminatedWord Visual
    au ColorScheme * hi! link illuminatedWord CursorLine
    au ColorScheme * hi! CursorLineNr cterm=NONE
    au ColorScheme * hi! FoldColumn ctermbg=none ctermfg=none guibg=NONE
    au ColorScheme * hi! Conceal ctermbg=none ctermfg=239  guibg=NONE guifg=#4e4e4e
    " if ! has('gui_macvim')
    "   au ColorScheme * hi! Normal ctermbg=none guibg=NONE
    "   au ColorScheme * hi! NonText ctermbg=none guibg=NONE
    " endif
    au ColorScheme * hi! Folded ctermbg=none guibg=NONE
    au ColorScheme * hi! CursorLine ctermfg=none guifg=NONE gui=NONE term=NONE cterm=NONE
    if g:os != 'Android'
      set fillchars+=vert:│
    endif
    au ColorScheme * hi VertSplit cterm=none ctermfg=Black ctermbg=none guibg=NONE
  endif
  " }}}

  " Use GIU colors
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  else
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  if (has("termguicolors"))
    set termguicolors
  endif

  set guifont=FuraCode\ Nerd\ Font\ Mono:h12

  " if has('gui_macvim')
  "   set transparency=5
  " endif

  let g:airline_theme='base16_tomorrow'
  color Tomorrow-Night-Bright
  "color PaperColor
  " color xcodedarkhc
  " color one
  " color dracula
  " color github
" }}}

" typographic ligatures {{{
" from: https://maximewack.com/post/emulating_ligatures/
 "if has('conceal')
 "  syntax clear customOperator
 "  syntax match customOperator '//' conceal cchar=÷
 "  syntax match customOperator '*' conceal cchar=×
 "  syntax match customOperator '==' conceal cchar=≣
 "  syntax match customOperator '!=' conceal cchar=≠
 "  syntax match customOperator '>=' conceal cchar=≥
 "  syntax match customOperator '<=' conceal cchar=≤
 "  syntax match customOperator '->' conceal cchar=→
 "  syntax match customOperator '|>' conceal cchar=⊳
 "  syntax match customOperator '<|' conceal cchar=⊲
 "  syntax match customOperator '>>' conceal cchar=»
 "  syntax match customOperator '<<' conceal cchar=«
 "  syntax match customOperator '\\' conceal cchar=λ
 "  syntax match customOperator '::' conceal cchar=∷
 "  syntax match customOperator '|=' conceal cchar=⊧
 "  syntax match customOperator '|.' conceal cchar=⊦
 "  syntax match customOperator '/=' conceal cchar=≠

 "  hi link customOperator Operator
 "  hi! link Conceal Operator
 "endif
" }}}
