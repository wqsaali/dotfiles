#!/usr/bin/env bash

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
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64 && chmod +x minikube && mv minikube ~/.local/bin/
}

installGems() {
  while read -r PKG; do
    gem_install_or_upgrade "$PKG"
  done < files/gem.lst
}

installScripts() {
  mkdir -p $HOME/.local/bin/
  cp -r files/scripts/* $HOME/.local/bin/
}

installAtomPackages() {
  cd ${INSTALLDIR}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* $HOME/.atom/
  apm install --packages-file files/atom-packages.lst
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

case "$1" in
  "gems")
    installGems
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
  "fission")
    installFission
    ;;
  *)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      ./osx.sh $@
    else
      ./linux.sh $@
    fi
    ;;
esac
