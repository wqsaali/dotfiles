#!/usr/bin/env bash

if [[ $OSTYPE != *"android"* ]]; then
  echo 'Doesnt look like you are on Android'
  echo '  please try the install.sh script'
  exit 1
fi

INSTALLDIR=$(pwd)

installPackages() {
  apt update && apt upgrade
  cat files/pkgs/pkg.lst | grep -Ev '\s*#' | tr '\n' ' ' | xargs apt install -y

  ./install.sh gopkgs
  pip install -U pip
  pip install -U pipx
  pip install -U neovim
  # pip install -U awscliv2
  # export CARGO_BUILD_TARGET=aarch64-linux-android
  # pipx install git+https://github.com/aws/aws-cli.git@v2
  installAwsCli
}

installAwsCli() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install -i ~/.local/aws-cli -b ~/.local/bin --update
  rm -rf aws
  rm awscliv2.zip
}

installDotFiles() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'installing git!' >&2
    apt install git
  fi

  mkdir -p "${HOME}/.termux/"
  cd "${INSTALLDIR}" || exit

  cp -r files/termux/* "${HOME}/.termux/"

  cp files/shell/bash/bash_aliases_completion "${PREFIX}/etc/bash_completion.d/"
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  mv knife_autocomplete "${PREFIX}/etc/bash_completion.d/"
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  mv kitchen-completion "${PREFIX}/etc/bash_completion.d/"

  termux-fix-shebang /data/data/com.termux/files/usr/etc/bash_completion.d/*
  # grep -lir --exclude-dir=.git '#!' ${HOME}/.bash/ | xargs -n 1 termux-fix-shebang

  cd "${INSTALLDIR}" || exit
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
