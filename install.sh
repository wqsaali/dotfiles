#!/usr/bin/env bash

INSTALLDIR=$(pwd)

path() {
  mkdir -p "$(dirname "$1")"
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

dotfiles_dir="$(dirname $0)"

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
  cd ${INSTALLDIR}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* ${HOME}/.atom/
  apm install --packages-file files/atom-packages.lst
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
  cd ${INSTALLDIR}
  mkdir -p ${HOME}/.vim/ftdetect
  mkdir -p ${HOME}/.vim/ftplugin
  mkdir -p ${HOME}/.vim/autoload/
  mkdir -p ${HOME}/.vim/bundle/
  mkdir -p ${HOME}/.config/nvim
  cp files/vim/vimrc ${HOME}/.vimrc
  cp files/vim/vimrc.local ${HOME}/.vimrc.local
  cp -r files/vim/ft* ${HOME}/.vim/
  ln -s ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim

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

installAll() {
  installGems
  installPips
  installNpms
  installScripts
  installVagrantPlugins
  installAtomPackages
  installVimPlugins
  installEls
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
    else
      ./linux.sh
    fi
    installAll
    ;;
  *)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      ./osx.sh ${@}
    else
      ./linux.sh ${@}
    fi
    ;;
esac
