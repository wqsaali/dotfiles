#!/usr/bin/env bash

function backupDotFiles() {
  mkdir -p files
  cp ${HOME}/.bash/git_prompt.sh files/bash/git_prompt.sh
  cp ${HOME}/.bash/shell_prompt.sh files/bash/shell_prompt.sh
  cp ${HOME}/.bashrc files/bash/bashrc
  cp ${HOME}/.bash_profile files/bash/bash_profile
  cp ${HOME}/.bash_variables files/bash/bash_variables
  cp ${HOME}/.git-prompt-colors.sh files/bash/git-prompt-colors.sh
  cp /etc/bash_completion.d/bash_aliases_completion files/bash/bash_aliases_completion
  cp ${HOME}/.profile files/profile
  cp ${HOME}/.tmux.conf.local files/tmux.conf.local
  cp ${HOME}/.screenrc files/screenrc
  cp ${HOME}/.vimrc files/vim/vimrc
  cp ${HOME}/.vimrc.local files/vim/vimrc.local
  cp -r ${HOME}/.vim/ft* files/vim/
  cp ${HOME}/.atom/*.cson files/atom/
  cp ${HOME}/.atom/*.coffee files/atom/
  cp ${HOME}/.atom/*.less files/atom/
  cp ${HOME}/.atom/*.json files/atom/
  cp ${HOME}/.config/tilda/config_0 files/tilda
  cp ${HOME}/.config/terminator/terminator.config files/terminator.config
  cp -r ${HOME}/.config/i3/* files/i3/
  cp -r ${HOME}/.hammerspoon/* files/hammerspoon/
  cp ${HOME}/.slate files/slate/slate
  cp ${HOME}/.slate.js files/slate/slate.js
  cp ${HOME}/.ptpython/config.py files/ptpython.py
}

function backupTermux() {
  pkg list-installed | cut -d '/' -f1 | grep -v '\.\.\.'| sort -u > files/pkg.lst
  cp -r ${HOME}/.termux/* files/termux/
}

function backupIterm() {
  defaults read com.googlecode.iterm2 > files/iterm/com.googlecode.iterm2.plist
}

function restoreIterm() {
  cp files/iterm/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
  plutil -convert binary1 ~/Library/Preferences/com.googlecode.iterm2.plist
  defaults read com.googlecode.iterm2
}

function exportItermColors() {
  cdir=$(pwd)
  mkdir -p files/iterm
  cd files/iterm
  # rm -f *
  /usr/libexec/PlistBuddy -c "print :'Custom Color Presets'" \
    ~/Library/Preferences/com.googlecode.iterm2.plist | grep '^    \w' | \
    ruby -e 'puts STDIN.read.gsub(/\s=\sDict\s{/,"").gsub(/^\s+/,"")' > list.txt
  while read THEME; do
    echo "exporting ${THEME}"
    /usr/libexec/PlistBuddy -c "print :'Custom Color Presets':'$THEME'" \
      ~/Library/Preferences/com.googlecode.iterm2.plist | \
      ruby -e "puts STDIN.read.strip.gsub(/Dict {/, '{')
        .gsub(/([A-Z][a-z0-9\\s]+)\\s=\\s/i, %Q{'\\\\1' = })
        .gsub(/(\\d(?:\.\\d+)?)$/, %Q{'\\\\1';})
        .gsub(/}\\n/, %Q(};\n))" > "$THEME.itermcolors"
  done < list.txt
  rm list.txt
  cd ${cdir}
}

function importItermColors() {
  cdir=$(pwd)
  cd files/iterm
  for f in *.itermcolors; do
    THEME=$(basename "${f%.*}")
    echo "importing ${THEME}"
    defaults write -app iTerm 'Custom Color Presets' -dict-add "$THEME" "$(cat "${f}")"
  done
  cd ${cdir}
}

function backupAtomPackages() {
  apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > files/atom-packages.lst
  cp ${HOME}/.atom/*.cson files/atom/
  cp ${HOME}/.atom/*.coffee files/atom/
  cp ${HOME}/.atom/*.less files/atom/
  cp ${HOME}/.atom/*.json files/atom/
}

function backupPPAs() {
  # Get list of PPAs
  echo '#!/usr/bin/env bash' > restore-ppas.sh
  echo '#!/usr/bin/env bash' > restore-repos.sh
  for APT in `find /etc/apt/ -name \*.list`; do
      grep -Po "(?<=^deb\s).*?(?=#|$)" $APT | while read ENTRY ; do
          HOST=`echo $ENTRY | cut -d/ -f3`
          USER=`echo $ENTRY | cut -d/ -f4`
          PPA=`echo $ENTRY | cut -d/ -f5`
          if [ "ppa.launchpad.net" = "$HOST" ]; then
              echo "sudo apt-add-repository ppa:$USER/$PPA" >> restore-ppas.sh
          else
              echo "sudo apt-add-repository \"${ENTRY}\"" >> restore-repos.sh
          fi
      done
  done
  echo 'sudo apt update' >> restore-ppas.sh
  echo 'sudo apt update' >> restore-repos.sh
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
  cat files/pkgs_manual.lst | tr '\n' ' ' | xargs sudo apt-get install -y
  sudo apt-mark auto $(cat files/pkgs_auto.lst | tr '\n' ' ')
  sudo apt-mark manual $(cat files/pkgs_manual.lst | tr '\n' ' ')
}

function backupHomeDir() {
  if [ ! -d "$1" ]; then
    echo "$1 is not a valid directory"
  fi
  FOLDER=$(echo "$1"|sed 's/\/$//g')
  sudo rsync -aP --exclude-from=rsync-homedir-excludes.txt ${HOME}/ $FOLDER/
}

function restoreRepos() {
  bash restore-repos.sh
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
  "ppas" | "repos" )
    backupPPAs
    ;;
  "termux" )
    backupTermux
    ;;
  "homedir" | "home" )
    backupHomeDir $2
    ;;
 "iterm" | "iterm2" )
   backupIterm
   ;;
 "itermColors" | "iterm2Colors" )
   exportItermColors
   ;;
  "restore" )
    restoreAll
    ;;
  *)
    backupAll
    ;;
esac
