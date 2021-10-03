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
  Plug 'airblade/vim-rooter'
  Plug 'editorconfig/editorconfig-vim'

  Plug 'breuckelen/vim-resize'
  Plug 't9md/vim-choosewin'

  Plug 'benmills/vimux'
  Plug 'benmills/vimux-golang'

  Plug 'wincent/terminus'
  Plug 'kassio/neoterm'
  Plug 'voldikss/vim-floaterm'

  Plug 'tpope/vim-dispatch'

  Plug 'tpope/vim-fugitive'
  Plug 'rbong/vim-flog'
  Plug 'gregsexton/gitv'
  Plug 'junegunn/gv.vim'

  Plug 'bronson/vim-visual-star-search'

  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
  Plug 'liuchengxu/vista.vim'
  Plug 'vn-ki/coc-clap'

  " Plug 'jremmen/vim-ripgrep'
  Plug 'terryma/vim-multiple-cursors'

  Plug 'ryanoasis/vim-devicons'

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
  " Plug 'pseewald/vim-anyfold'
  " Plug 'pedrohdz/vim-yaml-folds'
  Plug 'chrisbra/vim-diff-enhanced'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " Plug 'rbong/vim-crystalline'

  " Plug 'flazz/vim-colorschemes'
  " Plug 'rainglow/vim'
  " Plug 'rafi/awesome-vim-colorschemes'
  Plug 'chriskempson/base16-vim'
  Plug 'cormacrelf/vim-colors-github'
  Plug 'ghifarit53/tokyonight-vim'

  Plug 'frazrepo/vim-rainbow'
  " Plug 'nvim-treesitter/nvim-treesitter'
  " Plug 'p00f/nvim-ts-rainbow'
  " Plug 'junegunn/rainbow_parentheses.vim'

  Plug 'jamessan/vim-gnupg'
  Plug 'hashivim/vim-hashicorp-tools'
  Plug 'andrewstuart/vim-kubernetes'
  " Plug 'tell-k/vim-autopep8', {'for': 'python'}

  "Plug 'govim/govim', {'for': ['go', 'vim-plug']}
  "Plug 'fatih/vim-go', {'for': ['go', 'vim-plug'], 'do': ':GoUpdateBinaries'}
  " Plug 'arp242/gopher.vim', {'for': ['go', 'vim-plug']}
  Plug 'sebdah/vim-delve', {'for': ['go', 'vim-plug']}

  Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'vim-plug']}
  Plug 'maralla/vim-toml-enhance', {'for': ['toml', 'vim-plug']}
  Plug 'google/vim-jsonnet'
  Plug 'kevinoid/vim-jsonc'
  Plug 'jjo/vim-cue'
  " Plug 'posva/vim-vue'

  Plug 'iamcco/markdown-preview.nvim', {'for': ['markdown', 'vim-plug'], 'do': 'cd app & yarn install' }

  " function! BuildComposer(info)
  "   if a:info.status != 'unchanged' || a:info.force
  "     if has('nvim')
  "       !cargo build --release --locked
  "     else
  "       !cargo build --release --locked --no-default-features --features json-rpc
  "     endif
  "   endif
  " endfunction

  " Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

  " let g:vimspector_base_dir = expand( '<sfile>:p:h' ) . '/vimspector-conf'
  function! BuildVimspector(info)
    if a:info.status == 'installed' || a:info.force
      !./install_gadget.py --all
    endif
  endfunction

  Plug 'puremourning/vimspector', {'for': ['c', 'cpp', 'go', 'python', 'java', 'javascript', 'sh', 'vim-plug'], 'do': function('BuildVimspector')}

  Plug 'sheerun/vim-polyglot'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

  Plug 'tom-doerr/vim_codex'

  call plug#end()

  " Automatically install missing plugins on startup
  autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| endif
" }}}

" coc-extensions {{{
let g:coc_global_extensions = [
      \ 'coc-actions',
      \ '@yaegassy/coc-ansible',
      \ 'coc-apollo',
      \ 'coc-css',
      \ 'coc-dash-complete',
      \ 'coc-diagnostic',
      \ 'coc-docker',
      \ 'coc-dot-complete',
      \ 'coc-emmet',
      \ 'coc-emoji',
      \ 'coc-explorer',
      \ 'coc-floaterm',
      \ 'coc-fzf-preview',
      \ 'coc-gist',
      \ 'coc-git',
      \ 'coc-gitignore',
      \ 'coc-go',
      \ 'coc-graphql',
      \ 'coc-groovy',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-htmlhint',
      \ 'coc-jedi',
      \ 'coc-json',
      \ 'coc-just-complete',
      \ 'coc-lists',
      \ 'coc-lua',
      \ 'coc-markdown-preview-enhanced',
      \ 'coc-markdownlint',
      \ 'coc-marketplace',
      \ '@yaegassy/coc-nginx',
      \ 'coc-pairs',
      \ 'coc-phpls',
      \ 'coc-powershell',
      \ 'coc-prettier',
      \ 'coc-pyls',
      \ 'coc-pyright',
      \ 'coc-rls',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-spell-checker',
      \ 'coc-sql',
      \ 'coc-swagger',
      \ 'coc-tabnine',
      \ 'coc-tag',
      \ 'coc-terminal',
      \ 'coc-toml',
      \ 'coc-tsdetect',
      \ 'coc-tsserver',
      \ 'coc-ultisnips',
      \ 'coc-vetur',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ 'coc-webview',
      \ ]
" }}}
