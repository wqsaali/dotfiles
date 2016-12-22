# Dotfiles

What's included:
- a bashrc file
- installs https://github.com/magicmonty/bash-git-prompt.git
- installs https://github.com/gpakosz/.tmux
- a custom theme for bash-git-prompt
- a vimrc file
- Atom configuration including list of installed packages
- a bash_alias file

The install script will install my custom dotfiles but also some extra packages and fonts, you can select what to install by passing an argument to the install script:
```
./install dotfiles # will install the dotfiles only (.vimrc .bashrc etc...)
./install fonts # will install some powerline patched fonts
./install vimplugins # will install the vim plugins from the vimrc
./install atompackages # will install the atom plugins and configuration
./install packages # will install the packages listed in files/apt.lst
```

Before running the install script you **should** take a **look at** the **config.sh** file and edit it to your prefererences

The backup script can backup and restore your:
- List of deb repos
- Installed packages
- Atom packages
- Dotfiles

Usage examples:
```
./backup.sh dotfiles # Will backup your dotfiles, the ones managed by the install.sh script
./backup.sh atom
./backup.sh repos
```
