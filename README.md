# Dotfiles

**What's included:**
- a bashrc file
- a set of bash aliases
- installs https://github.com/magicmonty/bash-git-prompt.git
- a custom theme for bash-git-prompt
- installs https://github.com/gpakosz/.tmux
- a custom theme for tmux
- a vimrc file
- Atom configuration including list of installed packages
- a bash_alias file
- i3 and compton configuration files
- i3blocks scripts
- Hammerspoon configuration scripts

Some of the included aliases:
```
json-diff # Usage: json-diff file1 file2 [section_on_file1] [section_on_file2]
json-merge # Usage json-merge file1 file2

git-pull-all # Executes git pull on each sub-folder of the current folder

docker-killall # kill all running docker containers
docker-rm-all # remove all docker containers
docker-rmi-all # remove all docker images
docker-cleanup # all of the above

extract # archive extraction made easy
back # go back to the previous folder
calc # a simple bash calculator
Cat # syntax highlighting cat
wttr # displays the whether forecast

vim-update # update all active vim plugins

# Linux specific
apt-upgrade # apt update, upgrade and cleanup, including removing unused kernels

# macOS specific
brew-upgrade # upgrade all installed brew formulas
cask-upgrade # upgrade all installed brew cask formulas
cask # alias for brew cask
```

The install script supports both OS X and Linux (Ubuntu) and will install my custom dotfiles but also some extra packages and fonts, you can select what to install by passing an argument to the install script:
```
./install all # to bootstrap a new workstation
./install dotfiles # will install the dotfiles only (.vimrc .bashrc etc...)
./install fonts # will install some powerline patched fonts
./install vimplugins # will install the vim plugins from the vimrc
./install atompackages # will install the atom plugins and configuration
./install packages # will install the packages listed in files/apt.lst (or brew.lst and cask.lst if running on macOS)
./install i3 # will install and configure i3
```

**NOTE:** Before running the install script you **should** take a **look at** the **config.sh** file and edit it to your preferences

The backup script can backup and restore your:
- List of deb repos
- Installed packages
- Atom packages
- Dotfiles

Usage examples:
```
./backup.sh dotfiles # Will backup your dotfiles, the ones managed by the install.sh script
./backup.sh atom # Will backup your atom configuration files and installed package list
./backup.sh repos # Will backup your deb package repos
```
