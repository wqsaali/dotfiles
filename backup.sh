#!/bin/bash

function backupDotFiles() {
  mkdir -p files
  cp $HOME/.config/terminator/terminator.config files/terminator.config
  cp $HOME/.bash/git_prompt.sh files/git_prompt.sh
  cp $HOME/.bash/shell_prompt.sh files/shell_prompt.sh
  cp $HOME/.bashrc files/bashrc
  cp $HOME/.bash_profile files/bash_profile
  cp $HOME/.tmux.conf.local files/tmux.conf.local
  cp $HOME/.screenrc files/screenrc
  cp $HOME/.profile files/profile
  cp $HOME/.vimrc files/vim/vimrc
  cp $HOME/.vimrc.local files/vim/vimrc.local
  cp -r $HOME/.vim/ft* files/vim/
  cp $HOME/.atom/*.cson files/atom/
  cp $HOME/.atom/*.coffee files/atom/
  cp $HOME/.atom/*.less files/atom/
  cp $HOME/.atom/*.json files/atom/
  cp $HOME/.git-prompt-colors.sh files/git-prompt-colors.sh
  cp $HOME/.config/tilda/config_0 files/tilda
  cp /etc/bash_completion.d/docker-enter-completion files/docker-enter-completion
}

function backupAtomPackages() {
  apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > files/atom-packages.lst
}

function backupPPAs() {
  # Get list of PPAs
  echo '#!/bin/bash' > restore-ppas.sh
  echo '#!/bin/bash' > restore-repos.sh
  for APT in `find /etc/apt/ -name \*.list`; do
      grep -Po "(?<=^deb\s).*?(?=#|$)" $APT | while read ENTRY ; do
          HOST=`echo $ENTRY | cut -d/ -f3`
          USER=`echo $ENTRY | cut -d/ -f4`
          PPA=`echo $ENTRY | cut -d/ -f5`
          if [ "ppa.launchpad.net" = "$HOST" ]; then
              echo "sudo apt-add-repository ppa:$USER/$PPA" >> restore-ppas.sh
          else
              echo "sudo apt-add-repository \'${ENTRY}\'" >> restore-repos.sh
          fi
      done
  done
}

function backupPackages() {
  # Get list of installed packages
  apt-mark showauto > files/pkgs_auto.lst
  apt-mark showmanual > files/pkgs_manual.lst
}

function backupAll() {
  backupDotFiles
  backupAtomPackages
  backupPPAs
}

function restorePackages() {
  sudo apt-get update
  cat files/pkgs_manual.lst | tr '\n' '  ' | xargs sudo apt-get install -y
  sudo apt-mark auto $(cat files/pkgs_auto.lst)
  sudo apt-mark manual $(cat files/pkgs_manual.lst)
}

function restoreRepos() {
  bash restore-repos.#!/bin/sh
  bash restore-ppas.sh
}

function restoreDotfiles() {
  bash install.sh dotfiles
}

function restoreAll() {
  restoreRepos
  restorePackages
}

case "$1" in
  "dotfiles" )
    backupDotFiles
    ;;
   "atompackages" | "apkgs" | "atom" )
    backupAtomPackages
    ;;
  "ppas | repos" )
    backupPPAs
    ;;
  "restore" )
    restoreAll
    ;;
  *)
    backupAll
    ;;
esac
