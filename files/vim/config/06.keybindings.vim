" Shortcuts {{{

  let mapleader = '\'

  " lazy ':'
  map ; :

  " Easier to exit terminal mode
  tnoremap <Esc> <C-\><C-n>

  " Don't use Ex mode, use Q for formatting
  map Q gq

  " Use <C-L> to clear the highlighting of :set hlsearch.
  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
  endif

  inoremap <C-U> <C-G>u<C-U>

  " FIXME: (broken) ctrl s to save
  noremap  <C-s> :update<CR>
  vnoremap <C-s> <C-C>:update<CR>
  inoremap <C-s> <Esc>:update<CR>

  " exit insert mode
  inoremap <C-c> <Esc>

  " Find
  " map <C-f> /

  " indent / deindent after selecting the text with (⇧ v), (.) to repeat.
  vnoremap > >gv
  vnoremap < <gv
  nnoremap <Tab> >>_
  nnoremap <S-Tab> <<_
  inoremap <S-Tab> <C-D>
  vnoremap <Tab> >gv
  vnoremap <S-Tab> <gv

  " comment / decomment & normal comment behavior
  vmap <C-/> gc
  nnoremap <C-/> gcc
  inoremap <C-/> gcc
  " nmap <C-/>   <Plug>NERDCommenterToggle
  " vmap <C-/>   <Plug>NERDCommenterToggle<CR>gv
  " nmap <C-#>   <Plug>NERDCommenterToggle
  " vmap <C-#>   <Plug>NERDCommenterToggle<CR>gv

  " Text wrap simpler, then type the open tag or ',"
  vmap <C-w> S

  " Cut, Paste, Copy
  vmap <C-x> d
  vmap <C-v> p
  vmap <C-c> y
  nnoremap <F2> :set invpaste paste?<CR>
  set pastetoggle=<F2>
  " Use a scratch file for clipboard
  "vmap <leader>y :w! /tmp/vitmp<CR>
  "nmap <leader>p :r! cat /tmp/vitmp<CR>
  vmap <leader>y "*y
  nmap <leader>p "*p

  " Undo, Redo (broken)
  nnoremap <C-z> :undo<CR>
  inoremap <C-z> <Esc>:undo<CR>
  nnoremap <C-y> :redo<CR>
  inoremap <C-y> <Esc>:redo<CR>
  nnoremap <F5>  :GundoToggle<CR>

  noremap <Leader>i :set list!<CR>

  " Tabs

  " Tab navigation
  nnoremap <S-PageUp>   :tabprevious<CR>
  inoremap <S-PageUp>   <Esc>:tabprevious<CR>i
  nnoremap <S-PageDown> :tabnext<CR>
  inoremap <S-PageDown> <Esc>:tabnext<CR>i
  "nnoremap <C-t>        :tabnew<CR>
  "inoremap <C-t>        <Esc>:tabnew<CR>i
  nnoremap <C-k>        :tabclose<CR>
  inoremap <C-k>        <Esc>:tabclose<CR>i
  nnoremap <S-h>        gT
  nnoremap <S-l>        gt

  " tab navigation like firefox
  " nnoremap <C-S-tab> :tabprevious<CR>
  " nnoremap <C-tab>   :tabnext<CR>
  " nnoremap <C-t>     :tabnew<CR>
  " inoremap <C-S-tab> <Esc>:tabprevious<CR>i
  " inoremap <C-tab>   <Esc>:tabnext<CR>i
  " inoremap <C-t>     <Esc>:tabnew<CR>

  nnoremap <Leader>p :set paste<CR>
  nnoremap <Leader>o :set nopaste<CR>
  noremap  <Leader>g :GitGutterToggle<CR>
  noremap  <Leader>tb :TagbarToggle<CR>
  noremap  <Leader>nt :NERDTreeToggle<CR>
  noremap  <C-\> :NERDTreeToggle<CR>
  " nmap <C-n> :NERDTreeToggle<CR>
  " vmap ++ <plug>NERDCommenterToggle
  " nmap ++ <plug>NERDCommenterToggle
  nmap     <leader>TB <Plug>ToggleBrackets
  imap     <leader>TB <Plug>ToggleBrackets
  noremap  <leader>co :diffoff!<CR><C-W><C-O>

  "  Window management:
  nnoremap <Leader>sv :windo wincmd K<CR>
  nnoremap <Leader>sh :windo wincmd H<CR>

  " fugitive git bindings
  "vimdiff current vs git head (fugitive extension)
  nnoremap <Leader>gd :Gdiff<cr>
  nnoremap <Leader>gdm :Gdiff master<cr>
  "switch back to current file and closes fugitive buffer
  "nnoremap <Leader>gD :diffoff!<cr><c-w>h:bd<cr>
  nnoremap <Leader>gD <c-w>h<c-w>c
  nnoremap <Leader>ga :Git add %:p<CR><CR>
  nnoremap <Leader>gs :Gstatus<CR>
  nnoremap <Leader>gc :Gcommit -v -q<CR>
  nnoremap <Leader>gt :Gcommit -v -q %:p<CR>
  nnoremap <Leader>ge :Gedit<CR>
  nnoremap <Leader>gr :Gread<CR>
  nnoremap <Leader>gw :Gwrite<CR><CR>
  nnoremap <Leader>gbl :Gblame<CR>
  nnoremap <Leader>gl :silent! Glog<CR>:bot copen<CR>
  nnoremap <Leader>gp :Ggrep<Space>
  nnoremap <Leader>gm :Gmove<Space>
  nnoremap <Leader>gb :Git branch<Space>
  nnoremap <Leader>go :Git checkout<Space>
  nnoremap <Leader>gps :Dispatch! git push<CR>
  nnoremap <Leader>gpl :Dispatch! git pull<CR>
  nnoremap <Leader>g- :Silent Git stash<CR>:e<CR>
  nnoremap <Leader>g+ :Silent Git stash pop<CR>:e<CR>

  " Vimux Aliases
  command -nargs=+ Run VimuxRunCommand <args>
  command -nargs=+ Prompt VimuxPromptCommand <args>
  command CloseRunner VimuxCloseRunner
  command RunAgain VimuxRunLastCommand

" }}}
