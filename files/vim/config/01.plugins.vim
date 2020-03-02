" Plugins {{{

  "auto-install vim-plug
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif

  " Load vim-plug
  call plug#begin('~/.vim/bundle')

  " if g:os ==? 'Darwin'
  "   let g:plug_url_format = 'git@github.com:%s.git'
  " else
  "   let $GIT_SSL_NO_VERIFY = 'true'
  " endif

  Plug 'tpope/vim-sensible'
  Plug 'editorconfig/editorconfig-vim'

  "Plug 'camspiers/animate.vim'
  "Plug 'camspiers/lens.vim'
  Plug 'breuckelen/vim-resize'
  Plug 't9md/vim-choosewin'

  Plug 'wincent/terminus'
  Plug 'kassio/neoterm'
  "Plug 'edkolev/promptline.vim'
  "Plug 'edkolev/tmuxline.vim'
  "Plug 'powerline/powerline'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "Plug 'tpope/vim-flagship'
  Plug 'airblade/vim-gitgutter'
  "Plug 'mhinz/vim-signify'

  Plug 'tpope/vim-fugitive'
  Plug 'gregsexton/gitv'
  Plug 'junegunn/gv.vim'

  "Plug 'miyakogi/conoline.vim'
  "Plug 'RRethy/vim-illuminate'
  Plug 'nelstrom/vim-visual-star-search'

  Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

  "Plug 'ctrlpvim/ctrlp.vim'
  "Plug 'fisadev/vim-ctrlp-cmdpalette'
  "Plug 'DavidEGx/ctrlp-smarttabs'

  "Plug 'dyng/ctrlsf.vim'
  "Plug 'gcmt/breeze.vim'
  "Plug 'mileszs/ack.vim'
  Plug 'jremmen/vim-ripgrep'
  Plug 'terryma/vim-multiple-cursors'

  "Plug 'ptzz/lf.vim'
  "Plug 'rbgrouleff/bclose.vim'

  Plug 'ryanoasis/vim-devicons'
  Plug 'preservim/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] } "Loads only when opening NERDTree }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
  " Plug 'vwxyutarooo/nerdtree-devicons-syntax', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
  "Plug 'jlanzarotta/bufexplorer'
  "Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  "Plug 'vim-scripts/taglist.vim'
  Plug 'liuchengxu/vista.vim'
  "Plug 'severin-lemaignan/vim-minimap'

  "Plug 'vim-scripts/cmdalias.vim'
  Plug 'benmills/vimux'

  "Plug 'Shougo/neocomplete.vim.git'
  "Plug 'Shougo/neosnippet'
  "Plug 'Shougo/neosnippet-snippets'
  "Plug 'SirVer/ultisnips'
  "Plug 'MarcWeber/vim-addon-mw-utils' "requiered by snipmate
  "Plug 'tomtom/tlib_vim' "requiered by snipmate
  "Plug 'garbas/vim-snipmate'
  "Plug 'honza/vim-snippets'

  " function! BuildYCM(info)
  "   if a:info.status == 'installed' || a:info.force
  "     !./install.py --clang-completer --go-completer --ts-completer --quiet
  "   endif
  " endfunction
  " Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp', 'ruby', 'python', 'go', 'javascript'], 'do': function('BuildYCM') }

  "Plug 'tenfyzhong/CompleteParameter.vim', { 'for': ['c', 'cpp', 'ruby', 'python', 'go', 'javascript'] }
  "Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
  "Plug 'mgedmin/python-imports.vim', { 'for': ['python'] }
  "Plug 'ervandew/supertab'

  "Plug 'sjl/gundo.vim'
  "Plug 'luochen1990/indent-detector.vim'
  Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  "Plug 'tomtom/tcomment_vim'
  Plug 'preservim/nerdcommenter'
  Plug 'nvie/vim-togglemouse'
  "Plug 'LucHermitte/lh-vim-lib'
  "Plug 'LucHermitte/lh-tags'
  "Plug 'LucHermitte/lh-dev'
  "Plug 'LucHermitte/lh-brackets'
  "Plug 'LucHermitte/lh-misc'
  "Plug 'jiangmiao/auto-pairs'
  "Plug 'alvan/vim-closetag'
  "Plug 'Raimondi/delimitMate'
  "Plug 'Townk/vim-autoclose'
  "Plug 'tpope/vim-endwise'
  "Plug 'godlygeek/tabular'
  "Plug 'neilagabriel/vim-geeknote'
  "Plug 'kopischke/vim-stay'
  "Plug 'kopischke/vim-fetch'
  Plug 'Konfekt/FastFold'
  Plug 'luisdavim/pretty-folds'
  Plug 'chrisbra/vim-diff-enhanced'
  "Plug 'scrooloose/syntastic'
  Plug 'metakirby5/codi.vim'

  Plug 'flazz/vim-colorschemes'
  "Plug 'lilydjwg/colorizer'
  "Plug 'chriskempson/base16-vim'
  "Plug 'dracula/vim'
  "Plug 'rakr/vim-one'
  "Plug 'cormacrelf/vim-colors-github'
  "Plug 'arzg/vim-colors-xcode'

  Plug 'jamessan/vim-gnupg'
  Plug 'hashivim/vim-hashicorp-tools'
  Plug 'andrewstuart/vim-kubernetes'
  Plug 'tell-k/vim-autopep8', {'for': 'python'}
  Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
  "Plug 'chr4/nginx.vim'
  "Plug 'elzr/vim-json', { 'for': 'json' }
  "Plug 'cespare/vim-toml', { 'for': 'toml' }
  "Plug 'pearofducks/ansible-vim'
  Plug 'maralla/vim-toml-enhance', { 'for': 'toml' }
  "Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebars'] }
  "Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  if has('nvim')
    Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': 'cd app & yarn install'  }
  else
    Plug 'iamcco/mathjax-support-for-mkdp', { 'for': 'markdown' }
    Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
  endif

  Plug 'sheerun/vim-polyglot'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  call plug#end()

  " Automatically install missing plugins on startup
  autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| endif
" }}}

" coc-extensions {{{
let g:coc_global_extensions = [
      \ 'coc-marketplace',
      \ 'coc-git',
      \ 'coc-gitignore',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-tabnine',
      \ 'coc-highlight',
      \ 'coc-snippets',
      \ 'coc-markdownlint',
      \ 'coc-sh',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-vimlsp',
      \ 'coc-python',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-phpls',
      \ 'coc-docker',
      \ ]
" }}}
