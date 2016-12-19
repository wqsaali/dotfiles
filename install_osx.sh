#!/bin/bash

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo 'Doesnt look like you are on OS X'
  echo '  please try the install.sh script'
  exit 1
fi

PWD=$(pwd)

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      brew upgrade "$@"
    fi
  else
    brew install "$@"
  fi
}

cask_install() {
    fancy_echo "Installing $1 ..."
    brew cask install "$@ --appdir=/Applications"
}

brew_is_installed() {
  local name
  name="$(brew_expand_alias "$1")"

  brew list -1 | grep -Fqx "$name"
}

brew_is_upgradable() {
  local name
  name="$(brew_expand_alias "$1")"

  ! brew outdated --quiet "$name" >/dev/null
}

brew_tap() {
  brew tap "$1" --repair 2> /dev/null
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/.*\//, ""); gsub(/:/, ""); print $1}'
}

brew_launchctl_restart() {
  local name
  name="$(brew_expand_alias "$1")"
  local domain="homebrew.mxcl.$name"
  local plist="$domain.plist"

  mkdir -p "$HOME/Library/LaunchAgents"
  ln -sfv "/usr/local/opt/$name/$plist" "$HOME/Library/LaunchAgents"

  if launchctl list | grep -Fq "$domain"; then
    launchctl unload "$HOME/Library/LaunchAgents/$plist" >/dev/null
  fi
  launchctl load "$HOME/Library/LaunchAgents/$plist" >/dev/null
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
    rbenv rehash
  fi
}

function installPacakges() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'You need to install git!' >&2
    xcode-select --install
    exit 1
  fi
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew_tap 'caskroom/cask'
  brew_tap 'homebrew/services'
  brew_tap 'neovim/neovim'
  brew update

  curl -s https://raw.githubusercontent.com/stephennancekivell/brew-update-notifier/master/install.sh | sh

  while read -r PKG; do
    brew_install_or_upgrade "$PKG"
  done < brew.lst

  while read -r PKG; do
    cask_install "$PKG"
  done < cask.lst

  sudo echo $(brew --prefix)/bin/bash >> /etc/shells && \
  chsh -s $(brew --prefix)/bin/bash

  sudo pip install -U pip setuptools
  # sudo pip install -U thefuck
  sudo pip install -U howdoi
  sudo pip install -U Pygment
  # sudo pip install -U awscli

  sudo npm install -g coffee-scrip
  sudo npm install -g azure-cli

  fancy_echo "Cleaning up old Homebrew formulae ..."
  brew cleanup
  brew cask cleanup
}

function installFonts() {
  curl -fLo DroidSansMonoForPowerlinePlusNerdFileTypes.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/0.6.0/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
  sudo chmod 664 DroidSansMonoForPowerlinePlusNerdFileTypes.otf
  mv *.otf $HOME/Library/Fonts
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  sudo mv PowerlineSymbols.otf /usr/share/fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
  wget https://github.com/powerline/fonts/raw/master/Terminus/PSF/ter-powerline-v16b.psf.gz
  sudo mv ter-powerline-v16b.psf.gz /usr/share/consolefonts/
  if ! [ -d $HOME/Library/Fonts/ubuntu-mono-powerline-ttf ]; then
    git clone https://github.com/pdf/ubuntu-mono-powerline-ttf.git $HOME/Library/Fonts/ubuntu-mono-powerline-ttf
  else
    cd $HOME/Library/Fonts/ubuntu-mono-powerline-ttf
    git pull
    cd ${PWD}
  fi
}

function installDotFiles() {
  mkdir -p $HOME/.bash/
  cp files/git_prompt.sh $HOME/.bash/
  cp files/shell_prompt.sh $HOME/.bash/
  cp files/bashrc $HOME/.bashrc
  cp files/bash_profile $HOME/.bash_profile
  cp files/screenrc $HOME/.screenrc
  cp files/tmux.conf.local $HOME/.tmux.conf.local
  cp files/profile $HOME/.profile
  mkdir -p $HOME/.vim/ftdetect
  mkdir -p $HOME/.vim/ftplugin
  cp -r files/vim/ft* $HOME/.vim/
  cp files/vim/vimrc $HOME/.vimrc
  cp files/vim/vimrc.local $HOME/.vimrc.local
  cp files/atom/* $HOME/.atom/
  cp files/git-prompt-colors.sh $HOME/.git-prompt-colors.sh
  cp files/bash_aliases_completion $HOME/.bash/
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  mv knife_autocomplete $HOME/.bash/
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  mv kitchen-completion $HOME/.bash/

  SHELLVARS=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  source config.sh
  CONF=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  CONF=$(comm -3 <(echo $CONF | tr ' ' '\n' | sort -u ) <(echo $SHELLVARS | tr ' ' '\n' | sort -u) | grep -v 'SHELLVARS')
  #read -p "Please enter your name (for gitconfig):" NAME
  #read -p "Please enter your email address (for gitconfig):" EMAIL

  #cp files/bash_aliases $HOME/.bash_aliases
  sedcmd=''
  for var in $(echo $CONF);do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/bash_aliases | sed -e "$sedcmd" > $HOME/.bash_aliases

  # cp files/gitconfig $HOME/.gitconfig
  sedcmd=''
  for var in NAME EMAIL;do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/gitconfig | sed -e "$sedcmd" > $HOME/.gitconfig

  if [ ! -d  $HOME/.bash/bash-git-prompt ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash/bash-git-prompt
  else
    cd $HOME/.bash/bash-git-prompt
    git pull
    cd ${PWD}
  fi

  if [ ! -d  $HOME/.bash/powerline-shell ]; then
    git clone https://github.com/milkbikis/powerline-shell $HOME/.bash/powerline-shell
  else
    cd $HOME/.bash/powerline-shell
    git pull
    cd ${PWD}
  fi

  if [ ! -d  $HOME/.tmux ]; then
    git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
  else
    cd $HOME/.tmux/
    git pull
    cd ${PWD}
  fi
  if [ ! -s $HOME/.tmux.conf ]; then
    ln -s $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
  fi
}

function installFish() {
  brew install fish
  curl -sfL https://git.io/fundle-install | fish
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
  fisher fzf edc/bass omf/thefuck omf/wttr omf/vundle ansible-completion docker-completion
  omf install chain
  fisher teapot
}

function installAtomPackages() {
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-apt.lst
  cp files/atom/* $HOME/.atom/
  apm install --packages-file files/atom-apt.lst
}

function installVimPlugins() {
  mkdir -p $HOME/.vim/ftdetect
  mkdir -p $HOME/.vim/ftplugin
  mkdir -p $HOME/.vim/bundle/
  cp files/vim/vimrc $HOME/.vimrc
  cp files/vim/vimrc.local $HOME/.vimrc.local
  cp -r files/vim/ft* $HOME/.vim/

  if [ ! -d  $HOME/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  fi

  vim +PluginInstall +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  ./install.py
}

function installAll() {
  installPacakges
  installFonts
  installDotFiles
  installVimPlugins
  installAtomPackages
}

case "$1" in
  "packages" | "pkgs")
    installPacakges
    ;;
  "dotfiles")
   installDotFiles
    ;;
  "fish")
   installFish
    ;;
  "fonts")
    installFonts
    ;;
  "vimplugins" | "vim")
    installVimPlugins
    ;;
  "atompackages" | "apkgs" | "atom")
    installAtomPackages
    ;;
  *)
    installAll
    ;;
esac
