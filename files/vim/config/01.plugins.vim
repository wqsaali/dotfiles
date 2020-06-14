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

  Plug 'breuckelen/vim-resize'
  Plug 't9md/vim-choosewin'

  Plug 'benmills/vimux'

  Plug 'wincent/terminus'
  Plug 'kassio/neoterm'

  Plug 'tpope/vim-dispatch'

  Plug 'tpope/vim-fugitive'
  Plug 'gregsexton/gitv'
  Plug 'junegunn/gv.vim'

  Plug 'nelstrom/vim-visual-star-search'

  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
  Plug 'vn-ki/coc-clap'

  Plug 'jremmen/vim-ripgrep'
  Plug 'terryma/vim-multiple-cursors'

  Plug 'ryanoasis/vim-devicons'

  Plug 'liuchengxu/vista.vim'

  Plug 'Yggdroot/indentLine', {'on': 'IndentLinesEnable'}
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  "Plug 'tpope/vim-unimpaired'"
  "Plug 'tpope/vim-endwise'
  "Plug 'tpope/vim-abolish'
  Plug 'nvie/vim-togglemouse'
  Plug 'Konfekt/FastFold'
  Plug 'luisdavim/pretty-folds'
  Plug 'chrisbra/vim-diff-enhanced'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'flazz/vim-colorschemes'

  Plug 'jamessan/vim-gnupg'
  Plug 'hashivim/vim-hashicorp-tools'
  Plug 'andrewstuart/vim-kubernetes'
  Plug 'tell-k/vim-autopep8', {'for': 'python'}

  "Plug 'govim/govim', {'for': 'go'}
  "Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
  " Plug 'arp242/gopher.vim', {'for': 'go'}
  Plug 'sebdah/vim-delve', {'for': 'go'}

  Plug 'maralla/vim-toml-enhance', {'for': 'toml'}

  if has('nvim')
    Plug 'iamcco/markdown-preview.nvim', {'for': 'markdown', 'do': 'cd app & yarn install' }
  else
    Plug 'iamcco/mathjax-support-for-mkdp', {'for': 'markdown'}
    Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'}
  endif

  function! BuildVimspector(info)
    if a:info.status == 'installed' || a:info.force
      !./install_gadget.py --all
    endif
  endfunction
  Plug 'puremourning/vimspector', {'for': ['c', 'cpp', 'go', 'python', 'java', 'javascript', 'sh'], 'do': function('BuildVimspector')}

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
      \ 'coc-explorer',
      \ 'coc-git',
      \ 'coc-gitignore',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-tabnine',
      \ 'coc-highlight',
      \ 'coc-snippets',
      \ 'coc-markdownlint',
      \ 'coc-diagnostic',
      \ 'coc-swagger',
      \ 'coc-docker',
      \ 'coc-sh',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-vimlsp',
      \ 'coc-python',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-groovy',
      \ 'coc-phpls',
      \ 'coc-sql',
      \ 'coc-docker',
      \ ]
" }}}
