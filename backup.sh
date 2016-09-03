#!/bin/bash

function installDotFiles (){
  cp $HOME/.config/terminator/terminator.config files/terminator.config
  cp $HOME/.bash/git_prompt.sh files/git_prompt.sh
  cp $HOME/.bash/shell_prompt.sh files/shell_prompt.sh
  cp $HOME/.bashrc files/bashrc
  cp $HOME/.screenrc files/screenrc
  cp $HOME/.profile files/profile
  cp $HOME/.vimrc files/vimrc
  cp $HOME/.atom/*.cson files/atom/
  cp $HOME/.atom/*.coffee files/atom/
  cp $HOME/.atom/*.less files/atom/
  cp $HOME/.atom/*.json files/atom/
  cp $HOME/.git-prompt-colors.sh files/git-prompt-colors.sh
  cp /etc/bash_completion.d/docker-enter-completion files/docker-enter-completion
}

function backupAtomPackages (){
  apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > files/atom-packages.lst
}
