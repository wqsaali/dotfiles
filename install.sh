#!/usr/bin/env bash

path() {
  mkdir -p "$(dirname "$1")"
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

dotfiles_dir="$(dirname $0)"

link() {
  create_link "$dotfiles_dir/$1" "$HOME/$1"
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
    gem update "$@"
  else
    gem install "$@"
    # rbenv rehash
  fi
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

installGems() {
  while read -r PKG; do
    gem_install_or_upgrade "$PKG"
  done < files/gem.lst
}

installPips() {
  while read -r PKG; do
    pip install -U "$PKG"
  done < files/pip.lst
}

installScripts() {
  mkdir -p $HOME/.local/bin/
  cp -r files/scripts/* $HOME/.local/bin/
  curl -Lo testssl testssl.sh
  chmod +x testssl
  mv testssl $HOME/.local/bin/
}

installAtomPackages() {
  cd ${INSTALLDIR}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* $HOME/.atom/
  apm install --packages-file files/atom-packages.lst
}

installVagrantPlugins() {
  # https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins
  if ! [ -x "$(command -v vagrant)" ]; then
    if [[ "$OSTYPE" != "darwin"* ]]; then
      sudo apt-get install vagrant
    else
      brew cask install vagrant --appdir=/Applications
    fi
  fi
   vagrant plugin install vagrant-list
   vagrant plugin install vagrant-clean
   vagrant plugin install vagrant-box-updater
   vagrant plugin install vagrant-nuke
   vagrant plugin install vagrant-vbguest
}

installVimPlugins() {
  cd ${INSTALLDIR}
  mkdir -p $HOME/.vim/ftdetect
  mkdir -p $HOME/.vim/ftplugin
  mkdir -p $HOME/.vim/bundle/
  mkdir -p $HOME/.config/nvim
  cp files/vim/vimrc $HOME/.vimrc
  cp files/vim/vimrc.local $HOME/.vimrc.local
  cp -r files/vim/ft* $HOME/.vim/
  ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim

  if [ ! -d  $HOME/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  fi

  vim +PluginInstall +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  ./install.py
  cd ${INSTALLDIR}
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
  installScripts
  installVagrantPlugins
  installAtomPackages
  installVimPlugins
}

case "$1" in
  "gems" | "gem")
    installGems
    ;;
  "pip" | "pips")
    installPips
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
      ./osx.sh $@
    else
      ./linux.sh $@
    fi
    ;;
esac
