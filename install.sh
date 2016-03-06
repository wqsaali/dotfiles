#!/bin/bash

function installPacakges (){
  sudo apt-mark manual $(cat packages.lst)

  sudo pip install -U pip setuptools
  sudo pip install -U thefuck
}

function installFonts (){
  mkdir -p $HOME/.fonts/

  curl -fLo DroidSansMonoForPowerlinePlusNerdFileTypes.otf https://raw.githubusercontent.com/ryanoasis/nerd-fonts/0.6.0/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
  sudo chmod 664 DroidSansMonoForPowerlinePlusNerdFileTypes.otf
  mv *.otf $HOME/.fonts/
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  sudo mv PowerlineSymbols.otf /usr/share/fonts/
  sudo fc-cache -vf
  sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
}

function installDotFiles (){
  mkdir -p $HOME/.bash/

  cp terminator.config $HOME/.config/terminator/
  cp git_prompt.sh $HOME/.bash/
  cp shell_prompt.sh $HOME/.bash/
  cp bashrc $HOME/.bashrc
  cp profile $HOME/.profile
  cp vimrc $HOME/.vimrc
  cp git-prompt-colors.sh $HOME/.git-prompt-colors.sh

  SHELLVARS=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  source config.sh
  CONF=$(comm -3 <(compgen -v | sort) <(compgen -e | sort)|grep -v '^_')
  CONF=$(comm -3 <(echo $CONF | tr ' ' '\n' | sort -u ) <(echo $SHELLVARS | tr ' ' '\n' | sort -u) | grep -v 'SHELLVARS')
  #read -p "Please enter your name (for gitconfig):" NAME
  #read -p "Please enter your email address (for gitconfig):" EMAIL

  #cp bash_aliases $HOME/.bash_aliases
  sedcmd=''
  for var in $(echo $CONF);do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat bash_aliases | sed -e "$sedcmd" > $HOME/.bash_aliases

  # cp gitconfig $HOME/.gitconfig
  sedcmd=''
  for var in NAME EMAIL;do
    printf -v sc 's|${%s}|%s|;' $var "${!var//\//\\/}"
    sedcmd+="$sc"
  done
  cat gitconfig | sed -e "$sedcmd" > $HOME/.gitconfig

  if [ ! -d  $HOME/.bash/powerline-shell ]; then
    git clone https://github.com/milkbikis/powerline-shell $HOME/.bash/powerline-shell
  fi
  if [ ! -d  $HOME/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  fi
}

function installVimPlugins (){
  mkdir -p $HOME/.vim/bundle/

  if [ ! -d  $HOME/.bash/bash-git-prompt ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash/bash-git-prompt
  fi

  vim +PluginInstall +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  ./install.py
}

function installAll (){
  installPacakges
  installFonts
  installDotFiles
  installVimPlugins
}

case "$1" in
  "packages" | "pkgs")
    installPacakges
    ;;
  "dotfiles")
   installDotFiles
    ;;
  "fonts")
    installFonts
    ;;
  "vimplugins")
    installVimPlugins
    ;;
  *)
    installAll
    ;;
esac
