#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo 'Looks like you are on OS X'
  echo '  please try the install_osx.sh script'
  exit 1
fi

PWD=$(pwd)

function fancy_echo() {
  # red=`tput setaf 1`
  # green=`tput setaf 2`
  # reset=`tput sgr0`
  # echo "${red}red text ${green}green text${reset}"

  COLOR=1
  if [ ! -z "$2" ]; then
    COLOR=$2
  fi
  tput setaf $COLOR
  echo "$1"
  tput sgr0
}

function installDocker() {
  # Don't run this as root as you'll not add your user to the docker group
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  echo deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c | awk '{print $2}') main | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-get update
  sudo apt-get purge lxc-docker
  sudo apt-get install -y linux-image-extra-$(uname -r)
  sudo rm -rf /etc/default/docker
  sudo apt-get install -y docker-engine
  sudo service docker start
  sudo usermod -aG docker `echo $USER`
}

function installVagrantPlugins() {
  # https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins
  if ! [ -x "$(command -v vagrant)" ]; then
    apt-get install vagrant
  fi
   vagrant plugin install vagrant-list
   vagrant plugin install vagrant-clean
   vagrant plugin install vagrant-box-updater
   vagrant plugin install vagrant-nuke
}

function installHashicorp() {
  cd ${PWD}
  # List available packages with: curl --silent https://releases.hashicorp.com/index.json | jq 'keys[]'
  # Get URLs for most recent versions
  url=$(curl --silent https://releases.hashicorp.com/index.json | jq "{$1}" | egrep "linux.*64" | sort -rh | head -1 | awk -F[\"] '{print $4}')
  cd $HOME/.local/bin/
  curl -o package.zip $url
  unzip package.zip
  rm package.zip
  cd ${PWD}
}

function installKubernetes() {
  cd $HOME/.local/bin/
  curl -sS https://get.k8s.io | bash
  rm -rf kubernetes.tar.gz
  ln -s ~/.local/bin/kubernetes/client/bin/* ~/.local/bin/
  cd ${PWD}
}

function installPacakges() {
  sudo apt-get update
  cat files/apt-core.lst | tr '\n' ' ' | xargs sudo apt-get install -y
  sudo apt-mark manual $(cat files/apt-core.lst | tr '\n' ' ')

  # You might need some extra PPAs for these
  cat files/apt-extra.lst | tr '\n' ' ' | xargs sudo apt-get install -y
  sudo apt-mark manual $(cat files/apt-extra.lst | tr '\n' ' ')

  sudo pip install -U pip setuptools
  sudo pip install -U thefuck
  sudo pip install -U howdoi
  sudo pip install -U Pygment

  if ! [ -x "$(command -v docker)" ]; then
    installDocker
  fi
  if ! [ -x "$(command -v terraform)" ]; then
    installHashicorp terraform
  fi
  if ! [ -x "$(command -v packer)" ]; then
    installHashicorp packer
  fi
  if ! [ -x "$(command -v kubectl)" ]; then
    installKubernetes
  fi

  curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk

  sudo npm install -g coffee-scrip
  sudo npm install -g azure-cli
}

function installFonts() {
  mkdir -p $HOME/.fonts/

  curl -fLo DroidSansMonoForPowerlinePlusNerdFileTypes.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/0.6.0/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
  chmod 664 DroidSansMonoForPowerlinePlusNerdFileTypes.otf
  mv *.otf $HOME/.fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  sudo mv PowerlineSymbols.otf /usr/share/fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
  wget https://github.com/powerline/fonts/raw/master/Terminus/PSF/ter-powerline-v16b.psf.gz
  sudo mv ter-powerline-v16b.psf.gz /usr/share/consolefonts/
  if ! [ -d $HOME/.fonts/ubuntu-mono-powerline-ttf ]; then
    git clone https://github.com/pdf/ubuntu-mono-powerline-ttf.git $HOME/.fonts/ubuntu-mono-powerline-ttf
  else
    cd $HOME/.fonts/ubuntu-mono-powerline-ttf
    git pull
    cd ${PWD}
  fi
  sudo fc-cache -vf
}

function installGnomeTerminalProfiles() {
   # gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Ubuntu Mono derivative Powerline 11"
   # gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false

  # Profiles from https://github.com/Mayccoll/Gogh
  export {PROFILE_NAME,PROFILE_SLUG}="TomorrowNightBright" && wget -O xt http://git.io/v3DRJ && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="OneDark" && wget -O xt http://git.io/vs7Ut && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="MonokaiDark" && wget -O xt http://git.io/v3DBO && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="SolarizedDark" && wget -O xt http://git.io/v3DBQ && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="GruvboxDark" && wget -O xt http://git.io/v6JYg && chmod +x xt && ./xt && rm xt
}

function installDotFiles() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'installing git!' >&2
    sudo apt-get install git
  fi
  if ! [ -x "$(command -v hh)" ]; then
    echo 'installing hh!' >&2
    sudo add-apt-repository ppa:ultradvorka/ppa && sudo apt-get update && sudo apt-get install hh
  fi

  cd ${PWD}
  mkdir -p $HOME/.bash/
  mkdir -p $HOME/.vim/
  mkdir -p $HOME/.vim/ftdetect
  mkdir -p $HOME/.vim/ftplugin
  mkdir -p $HOME/.atom/
  mkdir -p $HOME/.config/terminator/
  mkdir -p $HOME/.config/i3

  cp -r files/i3/* $HOME/.config/i3/
  if [ ! -s $HOME/.i3 ]; then
    ln -s $HOME/.config/i3 $HOME/.i3
  fi

  cp files/tilda $HOME/.config/tilda/config_0
  cp files/terminator.config $HOME/.config/terminator/
  if ! [ -s  $HOME/.config/terminator/config ]; then
    ln -s $HOME/.config/terminator/terminator.config $HOME/.config/terminator/config
  fi

  cp files/git_prompt.sh $HOME/.bash/
  cp files/git-prompt-colors.sh $HOME/.git-prompt-colors.sh
  cp files/shell_prompt.sh $HOME/.bash/
  cp files/bashrc $HOME/.bashrc
  cp files/bash_variables $HOME/.bash_variables
  cp files/bash_profile $HOME/.bash_profile
  cp files/profile $HOME/.profile
  cp files/screenrc $HOME/.screenrc
  cp files/tmux.conf.local $HOME/.tmux.conf.local
  cp -r files/vim/ft* $HOME/.vim/
  cp files/vim/vimrc $HOME/.vimrc
  cp files/vim/vimrc.local $HOME/.vimrc.local
  cp files/atom/* $HOME/.atom/

  sudo cp files/bash_aliases_completion /etc/bash_completion.d/
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  sudo mv knife_autocomplete /etc/bash_completion.d/
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  sudo mv kitchen-completion /etc/bash_completion.d/
  sudo chown root:root /etc/bash_completion.d/*

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

function installi3wm() {
  if ! [ -x "$(command -v i3)" ]; then
    sudo apt install i3 i3blocks i3status i3lock compton conky alsa-utils mpd mpc ncmpcpp feh lxappearance rxvt-unicode-256color x11-xserver-utils gtk-chtheme qt4-qtconfig xcalib xprintidle
  fi

  mkdir -p $HOME/.config/i3
  cp -r files/i3/* $HOME/.config/i3/

  if [ -x "$(command -v nautilus)" ] && [ ! -x "$(command -v nautilus-i3)" ]; then
    sudo cp files/nautilus-i3 /usr/bin/
  fi

  if [ ! -s $HOME/.i3 ]; then
    ln -s $HOME/.config/i3 $HOME/.i3
  fi
}

function installFish() {
  sudo apt-add-repository ppa:fish-shell/release-2
  sudo apt-get update
  sudo apt-get install fish
  curl -sfL https://git.io/fundle-install | fish
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
  fisher fzf edc/bass omf/thefuck omf/wttr omf/vundle ansible-completion docker-completion
  omf install chain
  fisher teapot
}

function installAtomPackages() {
  cd ${PWD}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* $HOME/.atom/
  apm install --packages-file files/atom-packages.lst
}

function installVimPlugins() {
  cd ${PWD}
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
  cd ${PWD}
}

function installAll() {
  installPacakges
  installFonts
  installDotFiles
  installAtomPackages
  installVimPlugins
  installGnomeTerminalProfiles
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
  "termProfiles" | "gnomeTermProfiles")
    installGnomeTerminalProfiles
    ;;
  "i3wm" | "i3")
    installi3wm
    ;;
  *)
    installAll
    ;;
esac
