#!/usr/bin/env bash

INSTALLDIR=$(pwd)
dotfiles_dir="$(dirname $0)"

path() {
  mkdir -p "$(dirname "$1")"
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

link() {
  create_link "$dotfiles_dir/$1" "${HOME}/$1"
}

create_link() {
  real_file="$(path "$1")"
  link_file="$(path "$2")"

  rm -rf $link_file
  ln -s $real_file $link_file

  echo "$real_file <-> $link_file"
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update ${@}
  else
    gem install ${@}
    # rbenv rehash
  fi
}

installFromGithub() {
  mkdir -p ~/.local/bin/
  project="${1}"
  os=${2:-$(uname -s | tr '[:upper:]' '[:lower:]')}
  arch="${3:-64}"
  name="${4:-$(basename ${project})}"
  url=$(curl -s https://api.github.com/repos/${project}/releases/latest | jq -r ".assets[] | select(.name | test(\"${os}.*${arch}\")) | .browser_download_url")
  curl -Lo $name $url
  chmod +x $name
  mv $name ~/.local/bin/
}

installEls() {
  mkdir -p ~/.local/bin/
  curl -O https://raw.githubusercontent.com/AnthonyDiGirolamo/els/master/els
  chmod +x els
  mv els ~/.local/bin/
}

installFastPath() {
  # https://github.com/mfornasa/docker-fastpath
  mkdir -p ~/.local/bin/
  version='linux'
  arch='-amb64'
  if [[ "$OSTYPE" == "darwin"* ]]; then
    version='osx'
    arch=''
  fi
  curl https://docker-fastpath.s3-eu-west-1.amazonaws.com/releases/${version}/docker-fastpath-${version}${arch}-latest.zip > fastpath.zip
  unzip fastpath.zip
  chmod +x fastpath && mv fastpath ~/.local/bin/
}

installFission() {
  # http://fission.io/
  mkdir -p ~/.local/bin/
  version='linux'
  if [[ "$OSTYPE" == "darwin"* ]]; then
    version='mac'
  fi
  curl http://fission.io/$version/fission > fission && chmod +x fission && mv fission ~/.local/bin/
}

installMinikube() {
  mkdir -p ~/.local/bin/
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64
  chmod +x minikube
  mv minikube ~/.local/bin/
}

installKubetail() {
  mkdir -p ~/.local/bin/
  curl -Lo kubetail https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail
  chmod +x kubetail
  mv kubetail ~/.local/bin/
}

installDCOScli() {
  mkdir -p ~/.local/bin/
  curl -Lo dcos https://downloads.dcos.io/binaries/cli/$(uname -s | tr '[:upper:]' '[:lower:]')/x86-64/latest/dcos
  chmod +x dcos
  mv dcos ~/.local/bin/
}

installGoss() {
  mkdir -p ~/.local/bin/
  curl -fsSL https://goss.rocks/install | GOSS_DST=~/.local/bin sh
}

installDepcon() {
  installFromGithub 'ContainX/depcon' ${1} ${2}
}

installGems() {
  while read -r PKG; do
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    gem_install_or_upgrade "${PKG}"
  done < files/gem.lst
}

installPips() {
  while read -r PKG; do
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    pip install -U "${PKG}"
  done < files/pip.lst
}

installNpms() {
  while read -r PKG; do
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    npm install -g "${PKG}"
  done < files/npm.lst
}

installScripts() {
  mkdir -p ${HOME}/.local/bin/
  cp -r files/scripts/* ${HOME}/.local/bin/
  curl -Lo testssl testssl.sh
  chmod +x testssl
  mv testssl ${HOME}/.local/bin/
}

installAtomPackages() {
  mkdir -p ${HOME}/.atom/
  cd ${INSTALLDIR}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* ${HOME}/.atom/
  apm install --packages-file files/atom-packages.lst
}

installTmuxConf() {
  cp files/tmux.conf.local ${HOME}/.tmux.conf.local
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
}

installVagrantPlugins() {
  # https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins
  if ! [ -x "$(command -v vagrant)" ]; then
    if [[ "$OSTYPE" != "darwin"* ]]; then
      sudo apt-get install vagrant
    else
      brew cask install vagrant --appdir=/Applications
      brew install vagrant-completion
    fi
  fi
   vagrant plugin install vagrant-list
   vagrant plugin install vagrant-clean
   vagrant plugin install vagrant-box-updater
   vagrant plugin install vagrant-nuke
   vagrant plugin install vagrant-vbguest
   vagrant plugin install vagrant-hostmanager
}

installVimPlugins() {
  mkdir -p ${HOME}/.vim/ftdetect/
  mkdir -p ${HOME}/.vim/ftplugin/
  mkdir -p ${HOME}/.vim/autoload/
  mkdir -p ${HOME}/.vim/bundle/
  mkdir -p ${HOME}/.config/nvim/

  cd ${INSTALLDIR}

  cp files/vim/vimrc ${HOME}/.vimrc
  cp files/vim/vimrc.local ${HOME}/.vimrc.local
  cp -r files/vim/ft* ${HOME}/.vim/
  if [ ! -s ~/.config/nvim/init.vim ]; then
    ln -s ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim
  fi

  # Using vim Vundle
  # if [ ! -d  ${HOME}/.vim/bundle/Vundle.vim ]; then
  #   git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  # fi
  #
  # vim +PluginInstall +qall
  # cd ${HOME}/.vim/bundle/YouCompleteMe
  # ./install.py
  # cd ${INSTALLDIR}

  # Using vim-plug
  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PlugInstall +qall
}

installGitConf() {
  #read -p "Please enter your name (for gitconfig):" NAME
  #read -p "Please enter your email address (for gitconfig):" EMAIL

  # cp files/gitconfig ${HOME}/.gitconfig
  sedcmd=''
  for var in NAME EMAIL; do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/gitconfig | sed -e "$sedcmd" > ${HOME}/.gitconfig
  cp files/gitexcludes ${HOME}/.gitexcludes
}

installBashConf() {
  if [[ -z "$SHELLVARS" ]]; then
    SHELLVARS=$(comm -3 <(compgen -v | sort) <(compgen -e | sort) | grep -v '^_')
    source config.sh
    CONF=$(comm -3 <(compgen -v | sort) <(compgen -e | sort) | grep -v '^_')
    CONF=$(comm -3 <(echo $CONF | tr ' ' '\n' | sort -u ) <(echo $SHELLVARS | tr ' ' '\n' | sort -u) | grep -v 'SHELLVARS')
  fi

  mkdir -p ${HOME}/.bash/

  cd ${INSTALLDIR}

  cp files/bash/git_prompt.sh ${HOME}/.bash/
  cp files/bash/git-prompt-colors.sh ${HOME}/.git-prompt-colors.sh
  cp files/bash/shell_prompt.sh ${HOME}/.bash/
  cp files/bash/bashrc ${HOME}/.bashrc
  cp files/bash/bash_variables ${HOME}/.bash_variables
  cp files/bash/bash_profile ${HOME}/.bash_profile
  cp files/profile ${HOME}/.profile

  #cp files/bash/bash_aliases ${HOME}/.bash_aliases
  sedcmd=''
  for var in $(echo $CONF); do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat files/bash/bash_aliases | sed -e "$sedcmd" > ${HOME}/.bash_aliases

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
}

installFish() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt-get update
    sudo apt-get install fish
  else
    brew install fish
  fi
  curl -sfL https://git.io/fundle-install | fish
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
  fisher fzf edc/bass omf/thefuck omf/wttr omf/vundle ansible-completion docker-completion
  omf install chain
  fisher teapot
}

installDotFiles() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'You need to install git!' >&2
    exit 1
  fi
  installVimPlugins
  installTmuxConf
  installGitConf
  installBashConf

  if [[ "$OSTYPE" == "darwin"* ]]; then
    ./osx.sh ${@}
  elif [[ "$OSTYPE" == *"android"* ]]; then
    ./android.sh ${@}
  else
    ./linux.sh ${@}
  fi
}

installAll() {
  if [[ "$OSTYPE" != *"android"* ]]; then
    installGems
    installPips
    installNpms
    installScripts
    installVagrantPlugins
    installAtomPackages
    installGoss
    installEls
  fi
    installVimPlugins
    installTmuxConf
    installDotFiles
}

case "$1" in
  "gems" | "gem")
    installGems
    ;;
  "pip" | "pips")
    installPips
    ;;
  "npm" | "npms")
    installNpms
    ;;
  "vagrant" | "VagrantPlugins")
    installVagrantPlugins
    ;;
  "vimplugins" | "vim")
    installVimPlugins
    ;;
  "tmuxconf" | "tmux")
    installTmuxConf
    ;;
  "dotfiles")
    installDotFiles
    ;;
  "atompackages" | "apkgs" | "atom" | "apm")
    installAtomPackages
    ;;
  "scripts")
    installScripts
    ;;
  "minikube")
    installMinikube
    ;;
  "dcos"|"dcos-cli"|"dcoscli")
    installDCOScli
    ;;
  "depcon")
    if [[ "$OSTYPE" == "darwin"* ]]; then
      installDepcon 'osx' '64'
    else
      installDepcon 'linux' '64'
    fi
    ;;
  "goss")
    installGoss
    ;;
  "kubetail")
    installKubetail
    ;;
  "fission")
    installFission
    ;;
  "fish")
   installFish
    ;;
  "all")
    if [[ "$OSTYPE" == "darwin"* ]]; then
      ./osx.sh
    elif [[ "$OSTYPE" == *"android"* ]]; then
      ./android.sh
    else
      ./linux.sh
    fi
    installAll
    ;;
  *)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      ./osx.sh ${@}
    elif [[ "$OSTYPE" == *"android"* ]]; then
      ./android.sh ${@}
    else
      ./linux.sh ${@}
    fi
    ;;
esac
