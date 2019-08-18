" PluginSettings {{{

  if has('autocmd')
    filetype plugin indent on
    au FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=AL
  endif

  " vim-resize {{{
  let g:vim_resize_disable_auto_mappings = 1
  nnoremap <silent> <S-Left> :CmdResizeLeft<cr>
  nnoremap <silent> <S-Down> :CmdResizeDown<cr>
  nnoremap <silent> <S-Up> :CmdResizeUp<cr>
  nnoremap <silent> <S-Right> :CmdResizeRight<cr>
  " }}}

  " vim-choosewin {{{
  let g:choosewin_overlay_enable = 1
  nmap - <Plug>(choosewin)
  " }}}

  " matchparen {{{
  let g:matchparen_timeout = 2
  let g:matchparen_insert_timeout = 2
  " }}}

  " GeekNote {{{
  "let g:GeeknoteFormat="markdown"
  " }}}

  " Syntastic {{{
  let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':   [],'passive_filetypes': [] }
  let g:syntastic_aggregate_errors = 1
  let g:syntastic_always_populate_loc_list = 0
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

  noremap <C-w>e :SyntasticCheck<CR>
  noremap <C-w>f :SyntasticToggleMode<CR>
  " }}}

  " Gundu {{{
  " let g:gundo_width = 60
  " let g:gundo_preview_height = 40
  " let g:gundo_right = 1
  " }}}

  " MinMap {{{
  let g:minimap_highlight='Visual'
  " }}}

  " IndentLine {{{
  let g:indentLine_enabled = 0
  let g:indentLine_faster = 1
  if g:indentLine_faster == 0
    let g:indentLine_leadingSpaceEnabled = 1
  endif
  let g:vim_json_syntax_conceal = 0
  let g:indentLine_char = '┊'
  let g:indentLine_leadingSpaceChar = '˰'
  let g:indentLine_noConcealCursor = ""
  " set conceallevel=1
  " let g:indentLine_conceallevel=1

  " Vim
  let g:indentLine_color_term = 239
  "GVim
  let g:indentLine_color_gui = '#4e4e4e'
  " none X terminal
  let g:indentLine_color_tty_light = 7 " (default: 4)
  let g:indentLine_color_dark = 1 " (default: 2)'
  " }}}

  " Conoline {{{
  " if !&diff
  "   let g:conoline_auto_enable = 1
  " endif
  " }}}

  " vim-illuminate {{{
  let g:Illuminate_ftblacklist = ['nerdtree', 'vim-plug', 'sixpack', '', 'qf']
  " let g:Illuminate_ftHighlightGroups = {
  "     \ 'vim': ['', 'Function', 'Constant', 'vimVar'],
  "     \ 'cpp': ['', 'Function', 'Constant']
  "     \ }
  " }}}

  " GitGutter {{{
  let g:gitgutter_max_signs = 500
  " let g:gitgutter_highlight_lines = 1
  " }}}

  " Ack {{{
  for command in ['Ack', 'AckAdd', 'AckFromSearch', 'LAck', 'LAckAdd', 'AckFile', 'AckHelp', 'LAckHelp', 'AckWindow', 'LAckWindow']
    exe 'command ' . substitute(command, 'Ack', 'Ag', "") . ' ' . command
  endfor

  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
  " }}}

  " CtrlP {{{
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
  " NOTE: The following should make CtrlP faster
  "let g:ctrlp_match_window = 'bottom,order:ttb'
  "let g:ctrlp_switch_buffer = 0
  "let g:ctrlp_working_path_mode = 0
  "if executable('ag')
    "set grepprg=ag\ --nogroup\ --nocolor
    "let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
    "let g:ctrlp_use_caching = 0
  "endif
  "let g:ctrlp_working_path_mode = 'ra'
  " Always open files in new tabs
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }
  " }}}

  " Ultisnip {{{
  " NOTE: <f1> otherwise it overrides <tab> forever
  let g:UltiSnipsExpandTrigger = "<C-tab>"
  let g:UltiSnipsJumpForwardTrigger = "<C-tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<C-S-tab>"
  let g:did_UltiSnips_vim_after = 1
  " }}}

  " YouCompleteMe {{{
  " make YCM compatible with UltiSnips (using supertab)
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:SuperTabDefaultCompletionType = '<C-n>'

  " let g:loaded_youcompleteme = 1 " Disable YCM
  let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
  let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
  let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
  let g:ycm_complete_in_comments = 1 " Completion in comments
  let g:ycm_complete_in_strings = 1 " Completion in string
  let g:ycm_add_preview_to_completeopt = 0
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1

  let g:complete_parameter_use_ultisnips_mapping = 1
  "inoremap <silent><expr> ( complete_parameter#pre_complete("()")
  "smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
  "imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
  "smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
  "imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
  " }}}

  " AutoPairs {{{
  "let g:AutoPairs = {'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
  "inoremap <buffer><silent> ) <C-R>=AutoPairsInsert(')')<CR>
  " }}}

  " Brackets {{{
  let g:usemarks = 0
  " }}}

  " Vim-go {{{
  let g:go_fmt_autosave = 1
  let g:go_fmt_command = "goimports"
  " let g:go_fmt_options = '-w'

  " turn highlighting on
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1

  " Open go doc in vertical window, horizontal, or tab
  " au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
  " au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
  " au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>
  " }}}

  " Codi {{{
  " Use pry instead of irb
  " let g:codi#interpreters = {
  " \ 'ruby': {
  "     \ 'bin': ['pry', '-f'],
  "     \ 'prompt': '^[\d\+] pry(\w\+). ',
  "     \ },
  " \ }
  " }}}

  " vim-airline {{{
  " let g:airline_extensions = ['branch', 'tabline', 'whitespace']
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_min_count = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#whitespace#skip_indent_check_ft = {'go': ['mixed-indent-file']}
  let g:airline_powerline_fonts = 1
  let g:airline_theme='term'
  " }}}

" }}}
