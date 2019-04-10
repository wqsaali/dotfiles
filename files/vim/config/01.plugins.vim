" Plugins {{{

  "auto-install vim-plug
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif

  " Load vim-plug
  call plug#begin('~/.vim/bundle')

  if g:os ==? 'Darwin'
    let g:plug_url_format = 'git@github.com:%s.git'
  else
    let $GIT_SSL_NO_VERIFY = 'true'
  endif

  Plug 'tpope/vim-sensible'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'wincent/terminus'
  Plug 'kassio/neoterm'
  "Plug 'edkolev/promptline.vim'
  "Plug 'edkolev/tmuxline.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'breuckelen/vim-resize'
  Plug 't9md/vim-choosewin'
  "Plug 'powerline/powerline'
  "Plug 'tpope/vim-flagship'
  Plug 'airblade/vim-gitgutter'
  "Plug 'miyakogi/conoline.vim'
  Plug 'RRethy/vim-illuminate'
  "Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'gregsexton/gitv'
  Plug 'junegunn/gv.vim'
  "Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
  Plug 'chrisbra/vim-diff-enhanced'
  "Plug 'gcmt/breeze.vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'mileszs/ack.vim'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] } "Loads only when opening NERDTree }
  "Plug 'jlanzarotta/bufexplorer'
  "Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  "Plug 'vim-scripts/taglist.vim'
  "Plug 'severin-lemaignan/vim-minimap'
  "Plug 'vim-scripts/cmdalias.vim'
  Plug 'benmills/vimux'
  Plug 'nelstrom/vim-visual-star-search'
  "Plug 'Shougo/neocomplete.vim.git'
  "Plug 'Shougo/neosnippet'
  "Plug 'Shougo/neosnippet-snippets'
  Plug 'SirVer/ultisnips'
  Plug 'MarcWeber/vim-addon-mw-utils' "requiered by snipmate
  Plug 'tomtom/tlib_vim' "requiered by snipmate
  Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
  function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
      !./install.py --clang-completer --go-completer --ts-completer --quiet
    endif
  endfunction
  Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp', 'ruby', 'python', 'go', 'javascript'], 'do': function('BuildYCM') }
  "Plug 'tenfyzhong/CompleteParameter.vim', { 'for': ['c', 'cpp', 'ruby', 'python', 'go', 'javascript'] }
  "Plug 'davidhalter/jedi-vim.git'
  Plug 'ervandew/supertab'
  "Plug 'sjl/gundo.vim'
  Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  "Plug 'luochen1990/indent-detector.vim'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tomtom/tcomment_vim'
  "Plug 'scrooloose/nerdcommenter'
  Plug 'nvie/vim-togglemouse'
  "Plug 'LucHermitte/lh-vim-lib'
  "Plug 'LucHermitte/lh-tags'
  "Plug 'LucHermitte/lh-dev'
  "Plug 'LucHermitte/lh-brackets'
  "Plug 'LucHermitte/lh-misc'
  "Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'Raimondi/delimitMate'
  "Plug 'Townk/vim-autoclose'
  Plug 'tpope/vim-endwise'
  "Plug 'godlygeek/tabular'
  "Plug 'neilagabriel/vim-geeknote'
  "Plug 'kopischke/vim-stay'
  "Plug 'kopischke/vim-fetch'
  Plug 'Konfekt/FastFold'
  Plug 'luisdavim/pretty-folds'
  Plug 'scrooloose/syntastic'
  Plug 'metakirby5/codi.vim'
  Plug 'flazz/vim-colorschemes'
  "Plug 'lilydjwg/colorizer'
  "Plug 'chriskempson/base16-vim'
  "Plug 'dracula/vim'
  "Plug 'rakr/vim-one'
  "Plug 'cormacrelf/vim-colors-github'
  Plug 'jamessan/vim-gnupg'
  Plug 'hashivim/vim-hashicorp-tools'
  Plug 'andrewstuart/vim-kubernetes'
  Plug 'chr4/nginx.vim'
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  if has('nvim')
    Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': 'cd app & yarn install'  }
  else
    Plug 'iamcco/mathjax-support-for-mkdp', { 'for': 'markdown' }
    Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
  endif
  Plug 'tell-k/vim-autopep8', {'for': 'python'}
  Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
  Plug 'pearofducks/ansible-vim'
  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'cespare/vim-toml', { 'for': 'toml' }
  Plug 'maralla/vim-toml-enhance', { 'for': 'toml' }
  Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebars'] }

  call plug#end()

  " Automatically install missing plugins on startup
  autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| endif
" }}}
