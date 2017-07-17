#!/usr/bin/env bash

if [[ "$OSTYPE" == *"android"* ]]; then
  echo 'Looks like you are on Android'
  echo '  please try the install.sh script'
  exit 1
fi

INSTALLDIR=$(pwd)

installPackages() {
  apt update && apt upgrade
  cat files/pkg.lst | tr '\n' ' ' | xargs apt install -y
}

installDotFiles() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'installing git!' >&2
    apt install git
  fi

  mkdir -p ${HOME}/.termux/
  cd ${INSTALLDIR}

  cp -r files/termux/* ${HOME}/.termux/

  # sudo cp files/bash/bash_aliases_completion /etc/bash_completion.d/
  # curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  # sudo mv knife_autocomplete /etc/bash_completion.d/
  # curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  # sudo mv kitchen-completion /etc/bash_completion.d/
  # sudo chown root:root /etc/bash_completion.d/*

  cd ${INSTALLDIR}
}

osConfigs() {
  termux-setup-storage
}

installAll() {
  installPackages
  installDotFiles
  osConfigs
}

case "$1" in
  "packages" | "pkgs")
    installPackages
    ;;
  "dotfiles")
    installDotFiles
    ;;
  *)
    installAll
    ;;
esac
