" ColorThemes {{{
  highlight clear
  set background=dark
  set bg=dark
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
    " else
    "   set transparency=5
    " endif
    au ColorScheme * hi! Folded ctermbg=none guibg=NONE
    au ColorScheme * hi! CursorLine ctermfg=none guifg=NONE gui=NONE term=NONE cterm=NONE
    if g:os != 'Android'
      set fillchars+=vert:│
    endif
    au ColorScheme * hi VertSplit cterm=none ctermfg=Black ctermbg=none guibg=NONE

    " typographic ligatures {{{
    " from: https://maximewack.com/post/emulating_ligatures/
    if has('conceal')
      setlocal conceallevel=1
      " au Syntax * syntax clear customOperator

      " au Syntax * syntax match customOperator '\/' conceal cchar=÷
      " au Syntax * syntax match customOperator '*' conceal cchar=×
      au Syntax * syntax match customOperator '++' conceal cchar=⧺

      au Syntax * syntax match customOperator "=\@<!===\@!" conceal cchar=≖
      au Syntax * syntax match customOperator "=\@<!====\@!" conceal cchar=≡
      au Syntax * syntax match customOperator '\~=' conceal cchar=≃
      au Syntax * syntax match customOperator '==' conceal cchar=≣
      au Syntax * syntax match customOperator ':=' conceal cchar=≔
      au Syntax * syntax match customOperator '!=' conceal cchar=≠
      au Syntax * syntax match customOperator '!==' conceal cchar=≢
      au Syntax * syntax match customOperator '>=' conceal cchar=≥
      au Syntax * syntax match customOperator '!>=' conceal cchar=≱
      au Syntax * syntax match customOperator '<=' conceal cchar=≤
      au Syntax * syntax match customOperator '!<=' conceal cchar=≰

      au Syntax * syntax match customOperator '|>' conceal cchar=⊳
      au Syntax * syntax match customOperator '<|' conceal cchar=⊲
      au Syntax * syntax match customOperator '>>' conceal cchar=»
      au Syntax * syntax match customOperator '<<' conceal cchar=«
      au Syntax * syntax match customOperator '\\' conceal cchar=λ

      au Syntax * syntax match customOperator '::' conceal cchar=∷
      au Syntax * syntax match customOperator '->' conceal cchar=→
      au Syntax * syntax match customOperator '=>' conceal cchar=⇒

      au Syntax * syntax match customOperator '||' conceal cchar=∨
      au Syntax * syntax match customOperator '&&' conceal cchar=∧
      au Syntax * syntax match customOperator '|=' conceal cchar=⊧
      " au Syntax * syntax match customOperator '|.' conceal cchar=⊦
      au Syntax * syntax match customOperator '/=' conceal cchar=≠

      au ColorScheme * hi link customOperator Operator
      au ColorScheme * hi! link Conceal Operator

    endif
    " }}}
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

  " let g:github_colors_soft = 1
  let g:github_colors_block_diffmark = 0

  let g:clap_theme = 'atom_dark'
  " let g:airline_theme = 'base16_tomorrow'
  let g:airline_theme = "github"
  let g:lightline = { 'colorscheme': 'github' }

  let base16colorspace=256

  " color Tomorrow-Night-Bright
  " color molokai
  " color base16-chalk
  color github

" }}}

