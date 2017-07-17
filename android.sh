#!/data/data/com.termux/files/usr/bin/env bash

if [[ "$OSTYPE" != *"android"* ]]; then
  echo 'Doesnt look like you are on Android'
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

  cp files/bash/bash_aliases_completion ${PREFIX}/etc/bash_completion.d/
  curl -sfLo knife_autocomplete https://raw.githubusercontent.com/wk8/knife-bash-autocomplete/master/knife_autocomplete.sh
  mv knife_autocomplete ${PREFIX}/etc/bash_completion.d/
  curl -sfLo kitchen-completion https://raw.githubusercontent.com/MarkBorcherding/test-kitchen-bash-completion/master/kitchen-completion.bash
  mv kitchen-completion ${PREFIX}/etc/bash_completion.d/

  termux-fix-shebang /data/data/com.termux/files/usr/etc/bash_completion.d/*

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
