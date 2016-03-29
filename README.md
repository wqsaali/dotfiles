# Dotfiles

Waht's included:
- a bashrc file
- installs https://github.com/magicmonty/bash-git-prompt.git 
- a custom theme for bash-git-prompt
- a vimrc file
- a bash_alias file

The install script will install my custom dotfiles but also some extra packages and fonts, you can select what to install by passing an argument to the install script:
```
./install dotfiles # will install the dotfiles only (.vimrc .bashrc etc...)
./install fonts # will install some powerline patched fonts
./install vimplugins # will install the vim plugins from the vimrc
./install packages # will install the packages listes in files/packages.lst
```

Before running the install script you should take a look at the config.sh file and edit it to your prefererences


