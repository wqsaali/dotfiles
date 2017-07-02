#!/usr/bin/env bash

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo 'Doesnt look like you are on OS X'
  echo '  please try the install.sh script'
  exit 1
fi

INSTALLDIR=$(pwd)

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" ${@}
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      brew upgrade ${@}
    fi
  else
    brew install ${@}
  fi
}

cask_install() {
    fancy_echo "Installing $1 ..."
    brew cask install ${@} --appdir=/Applications
}

brew_is_installed() {
  local name
  name="$(brew_expand_alias "$1")"

  brew list -1 | grep -Fqx "$name"
}

cask_is_installed() {
  local name
  name="$(cask_expand_alias "$1")"

  brew cask list -1 | grep -Fqx "$name"
}

brew_is_upgradable() {
  local name
  name="$(brew_expand_alias "$1")"

  ! brew outdated --quiet "$name" >/dev/null
}

brew_tap() {
  brew tap $1 --repair 2> /dev/null
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/.*\//, ""); gsub(/:/, ""); print $1}'
}

cask_expand_alias() {
  brew cask info "$1" 2>/dev/null | head -1 | awk '{gsub(/.*\//, ""); gsub(/:/, ""); print $1}'
}

brew_launchctl_restart() {
  local name
  name="$(brew_expand_alias "$1")"
  local domain="homebrew.mxcl.$name"
  local plist="$domain.plist"

  mkdir -p "${HOME}/Library/LaunchAgents"
  ln -sfv "/usr/local/opt/$name/$plist" "${HOME}/Library/LaunchAgents"

  if launchctl list | grep -Fq "$domain"; then
    launchctl unload "${HOME}/Library/LaunchAgents/$plist" >/dev/null
  fi
  launchctl load "${HOME}/Library/LaunchAgents/$plist" >/dev/null
}

osConfigs() {
  # Enable Key Repeat
  defaults write -g ApplePressAndHoldEnabled -bool false
  # Set keyboard repeate speed
  defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

  # Dock
  # Add a Stack with Recent Applications
  # defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
  # Enable icon bounce
  # defaults write com.apple.dock no-bouncing -bool true
  # Set dock size and magnification
  defaults write com.apple.dock tilesize -int 48
  defaults write com.apple.dock largesize -int 57
  defaults write com.apple.dock magnification -bool true
  # Enable auto hiding
  defaults write com.apple.dock autohide -bool true
  # Move to the left
  defaults write com.apple.dock orientation left
  killall Dock

  # Reduce Transparency
  defaults write com.apple.universalaccess reduceTransparency -bool true

  # Enable Develop Menu and Web Inspector in Safari
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
    defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
    defaults write -g WebKitDeveloperExtras -bool true
}

installHomebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

installPackages() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'You need to install git!' >&2
    xcode-select --install
    exit 1
  fi
  sudo spctl --master-disable
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  while read -r TAP; do
    [[ "${TAP}" =~ ^#.*$ ]] && continue
    [[ "${TAP}" =~ ^\\s*$ ]] && continue
    brew_tap "${TAP}"
  done < files/tap.lst

  brew update

  /bin/bash "$(curl -fsSL  https://raw.githubusercontent.com/stephennancekivell/brew-update-notifier/master/install.sh)"

  while read -r PKG; do
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    brew_install_or_upgrade "${PKG}"
  done < files/brew.lst

  while read -r PKG; do
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    cask_install "${PKG}"
  done < files/cask.lst

  echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells > /dev/null
  chsh -s $(brew --prefix)/bin/bash

  # sudo npm install -g coffee-scrip
  # sudo npm install -g azure-cli

  # gettext is installed as a dependency but it's not linked
  brew link gettext --force

  fancy_echo "Cleaning up old Homebrew formulae ..."
  brew cleanup
  brew cask cleanup
}

function installIterm() {
  cask_install "iterm2"
  cp files/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  plutil -convert binary1 ~/Library/Preferences/com.googlecode.iterm2.plist
  defaults read com.googlecode.iterm2
}

installFonts() {
  mkdir -p ${HOME}/Library/Fonts
  curl -fLo DroidSansMonoForPowerlinePlusNerdFileTypes.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/0.6.0/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
  chmod 664 DroidSansMonoForPowerlinePlusNerdFileTypes.otf
  mv *.otf ${HOME}/Library/Fonts
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  sudo mv PowerlineSymbols.otf ${HOME}/Library/Fonts/
  if ! [ -d ${HOME}/Library/Fonts/ubuntu-mono-powerline-ttf ]; then
    git clone https://github.com/pdf/ubuntu-mono-powerline-ttf.git ${HOME}/Library/Fonts/ubuntu-mono-powerline-ttf
  else
    cd ${HOME}/Library/Fonts/ubuntu-mono-powerline-ttf
    git pull
    cd ${INSTALLDIR}
  fi
  cd ${INSTALLDIR}
}

installDotFiles() {
  mkdir -p ${HOME}/.bash/
  mkdir -p ${HOME}/.vim/
  mkdir -p ${HOME}/.vim/ftdetect
  mkdir -p ${HOME}/.vim/ftplugin
  mkdir -p ${HOME}/.vim/autoload
  mkdir -p ${HOME}/.atom/

  cd ${INSTALLDIR}

  cp files/bash/git_prompt.sh ${HOME}/.bash/
  cp files/bash/git-prompt-colors.sh ${HOME}/.git-prompt-colors.sh
  cp files/bash/shell_prompt.sh ${HOME}/.bash/
  cp files/bash/bashrc ${HOME}/.bashrc
  cp files/bash/bash_variables ${HOME}/.bash_variables
  cp files/bash/bash_profile ${HOME}/.bash_profile
  cp files/profile ${HOME}/.profile
  cp files/screenrc ${HOME}/.screenrc
  cp files/tmux.conf.local ${HOME}/.tmux.conf.local
  cp -r files/vim/ft* ${HOME}/.vim/
  cp files/vim/vimrc ${HOME}/.vimrc
  cp files/vim/vimrc.local ${HOME}/.vimrc.local
  cp files/atom/* ${HOME}/.atom/
  cp files/slate/slate ${HOME}/.slate
  cp files/slate/slate.js ${HOME}/.slate.js
  cp -r files/hammerspoon/* ${HOME}/.hammerspoon/

  sudo cp files/bash/bash_aliases_completion /usr/local/etc/bash_completion.d/
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  sudo mv knife_autocomplete /usr/local/etc/bash_completion.d/
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  sudo mv kitchen-completion /usr/local/etc/bash_completion.d/

  SHELLVARS=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  source config.sh
  CONF=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  CONF=$(comm -3 <(echo $CONF | tr ' ' '\n' | sort -u ) <(echo $SHELLVARS | tr ' ' '\n' | sort -u) | grep -v 'SHELLVARS')
  #read -p "Please enter your name (for gitconfig):" NAME
  #read -p "Please enter your email address (for gitconfig):" EMAIL

  #cp files/bash/bash_aliases ${HOME}/.bash_aliases
  sedcmd=''
  for var in $(echo $CONF);do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/bash/bash_aliases | sed -e "$sedcmd" > ${HOME}/.bash_aliases

  # cp files/gitconfig ${HOME}/.gitconfig
  sedcmd=''
  for var in NAME EMAIL;do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/gitconfig | sed -e "$sedcmd" > ${HOME}/.gitconfig
  cp files/gitexcludes ${HOME}/.gitexcludes

  if [ ! -d  ${HOME}/.bash/bash-git-prompt ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git ${HOME}/.bash/bash-git-prompt
  else
    cd ${HOME}/.bash/bash-git-prompt
    git pull
    cd ${INSTALLDIR}
  fi

  if [ ! -d  ${HOME}/.bash/powerline-shell ]; then
    git clone https://github.com/milkbikis/powerline-shell ${HOME}/.bash/powerline-shell
  else
    cd ${HOME}/.bash/powerline-shell
    git pull
    cd ${INSTALLDIR}
  fi

  if [ ! -d  ${HOME}/.tmux ]; then
    git clone https://github.com/gpakosz/.tmux.git ${HOME}/.tmux
  else
    cd ${HOME}/.tmux/
    git pull
    cd ${INSTALLDIR}
  fi
  if [ ! -s ${HOME}/.tmux.conf ]; then
    ln -s ${HOME}/.tmux/.tmux.conf ${HOME}/.tmux.conf
  fi

  if [ ! -d  ${HOME}/.reslate ]; then
    git clone https://github.com/lunixbochs/reslate.git ${HOME}/.reslate
  else
    cd ${HOME}/.reslate/
    git pull
    cd ${INSTALLDIR}
  fi
  cd ${INSTALLDIR}
}

installAll() {
  installPackages
  installFonts
  installIterm
  installDotFiles
}

case "$1" in
  "packages" | "pkgs")
    installPackages
    ;;
  "dotfiles")
   installDotFiles
    ;;
  "fonts")
    installFonts
    ;;
  *)
    installAll
    ;;
esac
