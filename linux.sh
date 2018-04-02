#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo 'Looks like you are on OS X'
  echo '  please try the install.sh script'
  exit 1
fi

INSTALLDIR=$(pwd)

fancy_echo() {
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

installDocker() {
  # Don't run this as root as you'll not add your user to the docker group
  sudo apt update
  sudo apt install apt-transport-https ca-certificates software-properties-common curl
  # sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  # echo deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c | awk '{print $2}') main | sudo tee /etc/apt/sources.list.d/docker.list
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt update
  sudo apt install -y linux-image-extra-$(uname -r)
  sudo apt purge lxc-docker docker-engine docker.io
  sudo rm -rf /etc/default/docker
  sudo apt install -y docker-ce
  sudo service docker start
  sudo usermod -aG docker ${USER}
}

installHashicorp() {
  # this is not Linux specific and it would work on macOS but there we can use brew to install all of these and that makes it easier to keep things up to date.
  if [[ "$1" == "vagrant" ]]; then
    ./install.sh vagrant
    return
  fi
  if [[ "$1" == "list" ]]; then
    # List available packages:
    curl --silent https://releases.hashicorp.com/index.json | jq 'keys[]'
    return
  fi
  # Get URLs for most recent versions:
  url=$(curl -s https://releases.hashicorp.com/index.json | jq "{$1}" | grep 'url' | egrep -i "$(uname -s).*$(uname -m | cut -d'_' -f2)" | sort -h | tail -1 | awk -F[\"] '{print $4}')
  cd ${HOME}/.local/bin/
  curl -o package.zip $url
  unzip package.zip
  rm package.zip
  cd ${INSTALLDIR}
}

installTerragrunt() {
  mkdir -p ~/.local/bin/
  project='gruntwork-io/terragrunt'
  name=$(basename ${project})
  arch='amd64'
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  url=$(curl -s https://api.github.com/repos/${project}/releases/latest | jq -r ".assets[] | select(.name | test(\"${os}_${arch}\")) | .browser_download_url")
  curl -Lo $name $url
  chmod +x $name
  mv $name ~/.local/bin/
}

installKubernetes() {
  cd ${HOME}/.local/bin/
  curl -sS https://get.k8s.io | bash
  rm -rf kubernetes.tar.gz
  ln -s ~/.local/bin/kubernetes/client/bin/* ~/.local/bin/
  cd ${INSTALLDIR}
}

installGnomeTerminalProfiles() {
  # gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Ubuntu Mono derivative Powerline 11"
  # gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false

  # Profiles from https://github.com/Mayccoll/Gogh
  export {PROFILE_NAME,PROFILE_SLUG}="TomorrowNightBright" && wget -O xt https://raw.githubusercontent.com/Mayccoll/Gogh/master/themes/tomorrow-night-bright.sh && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="OneDark" && wget -O xt https://raw.githubusercontent.com/Mayccoll/Gogh/master/themes/one-dark.sh && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="MonokaiDark" && wget -O xt https://raw.githubusercontent.com/Mayccoll/Gogh/master/themes/monokai-dark.sh && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="SolarizedDark" && wget -O xt https://raw.githubusercontent.com/Mayccoll/Gogh/master/themes/solarized-dark.sh && chmod +x xt && ./xt && rm xt
  export {PROFILE_NAME,PROFILE_SLUG}="GruvboxDark" && wget -O xt https://raw.githubusercontent.com/Mayccoll/Gogh/master/themes/gruvbox-derk.sh && chmod +x xt && ./xt && rm xt
}

installi3wm() {
  if ! [ -x "$(command -v i3)" ]; then
    sudo apt install i3 i3blocks i3status i3lock compton conky-all alsa-utils mpd mpc ncmpcpp feh lxappearance rxvt-unicode-256color x11-xserver-utils gtk-chtheme qt4-qtconfig xcalib xprintidle npm python-pip arandr
    sudo pip install i3-cycle
    sudo npm i -g i3-alt-tab
  fi

  mkdir -p ${HOME}/.config/i3
  cp -r files/i3/* ${HOME}/.config/i3/

  # if [ -x "$(command -v nautilus)" ] && [ ! -x "$(command -v nautilus-i3)" ]; then
  #   sudo cp files/nautilus-i3 /usr/bin/
  # fi

  if [ ! -s ${HOME}/.i3 ]; then
    ln -s ${HOME}/.config/i3 ${HOME}/.i3
  fi
}

installCerebro() {
  sudo npm install -g cerebro
  sudo npm install -g cerebro-linux-system
  sudo npm install -g cerebro-linux-commands
  sudo npm install -g cerebro-shell
  sudo npm install -g cerebro-fix-path
  sudo npm install -g cerebro-clipboard
  sudo npm install -g cerebro-kill
  sudo npm install -g cerebro-timezones
  sudo npm install -g cerebro-gif
  sudo npm install -g cerebro-imdb
  sudo npm install -g cerebro-ip
  sudo npm install -g cerebro-emoj
  sudo npm install -g cerebro-hash
  sudo npm install -g cerebro-stackoverflow
  sudo npm install -g cerebro-devdocs
}

installLinuxbrew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
}

addExtraRepos() {
  # Google
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
  # Spotify
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
  echo 'deb http://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list
  # Skype
  wget -q -O - https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
  echo 'deb [arch=amd64] https://repo.skype.com/deb stable main' | sudo tee /etc/apt/sources.list.d/skype-stable.list
  # Azure
  AZ_REPO=$(lsb_release -cs)
  sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

}

installPackages() {
  addExtraRepos
  sudo apt update
  cat files/apt-core.lst | grep -v '^$\|^\s*\#' | tr '\n' ' ' | xargs sudo apt install -y
  sudo apt-mark manual $(cat files/apt-core.lst | grep -v '^$\|^\s*\#' | tr '\n' ' ')

  # You might need some extra PPAs for these
  cat files/apt-extra.lst | grep -v '^$\|^\s*\#' | tr '\n' ' ' | xargs sudo apt install -y
  sudo apt-mark manual $(cat files/apt-extra.lst | grep -v '^$\|^\s*\#' | tr '\n' ' ')

  if ! [ -x "$(command -v cerebro)" ]; then
    installCerebro
  fi
  if ! [ -x "$(command -v docker)" ]; then
    installDocker
  fi
  if ! [ -x "$(command -v terraform)" ]; then
    installHashicorp terraform
    installTerragrunt
  fi
  if ! [ -x "$(command -v packer)" ]; then
    installHashicorp packer
  fi
  if ! [ -x "$(command -v kubectl)" ]; then
    installKubernetes
  fi

  curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk

  sudo npm install -g coffee-scrip
  # sudo npm install -g azure-cli
}

installFonts() {
  mkdir -p ${HOME}/.fonts/

  curl -fLo DroidSansMonoForPowerlinePlusNerdFileTypes.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/1.0.0/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
  chmod 664 DroidSansMonoForPowerlinePlusNerdFileTypes.otf
  mv *.otf ${HOME}/.fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  sudo mv PowerlineSymbols.otf /usr/share/fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
  wget https://github.com/powerline/fonts/raw/master/Terminus/PSF/ter-powerline-v16b.psf.gz
  sudo mv ter-powerline-v16b.psf.gz /usr/share/consolefonts/
  if ! [ -d ${HOME}/.fonts/ubuntu-mono-powerline-ttf ]; then
    git clone https://github.com/pdf/ubuntu-mono-powerline-ttf.git ${HOME}/.fonts/ubuntu-mono-powerline-ttf
  else
    cd ${HOME}/.fonts/ubuntu-mono-powerline-ttf
    git pull
    cd ${INSTALLDIR}
  fi
  sudo fc-cache -vf
  cd ${INSTALLDIR}
}

installDotFiles() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'installing git!' >&2
    sudo apt install git
  fi
  if ! [ -x "$(command -v hh)" ]; then
    echo 'installing hh!' >&2
    sudo add-apt-repository ppa:ultradvorka/ppa && sudo apt update && sudo apt install hh
  fi

  mkdir -p ${HOME}/.atom/
  mkdir -p ${HOME}/.config/terminator/
  mkdir -p ${HOME}/.config/i3/

  cd ${INSTALLDIR}

  cp -r files/i3/* ${HOME}/.config/i3/
  if [ ! -s ${HOME}/.i3 ]; then
    ln -s ${HOME}/.config/i3 ${HOME}/.i3
  fi

  cp files/tilda ${HOME}/.config/tilda/config_0
  cp files/terminator.config ${HOME}/.config/terminator/
  if ! [ -s  ${HOME}/.config/terminator/config ]; then
    ln -s ${HOME}/.config/terminator/terminator.config ${HOME}/.config/terminator/config
  fi

  cp files/screenrc ${HOME}/.screenrc
  cp files/atom/* ${HOME}/.atom/

  sudo cp files/bash/bash_aliases_completion /etc/bash_completion.d/
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  sudo mv knife_autocomplete /etc/bash_completion.d/
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  sudo mv kitchen-completion /etc/bash_completion.d/
  sudo chown root:root /etc/bash_completion.d/*

  cd ${INSTALLDIR}
}

installAll() {
  installPackages
  installFonts
  installGnomeTerminalProfiles
  installDotFiles
}

case "$1" in
  "packages" | "pkgs")
    installPackages
    ;;
  "hashicorp")
    installHashicorp $2
    ;;
  "dotfiles")
    installDotFiles
    ;;
  "fonts")
    installFonts
    ;;
  "termProfiles" | "gnomeTermProfiles" | "termColors")
    installGnomeTerminalProfiles
    ;;
  "i3wm" | "i3")
    installi3wm
    ;;
  *)
    installAll
    ;;
esac
