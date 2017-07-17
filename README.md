# Dotfiles

### What's included:
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

### The install script
The install script supports macOS, Linux (Ubuntu) and Android (Termux) and will install my custom dotfiles but also some extra packages and fonts, you can select what to install by passing an argument to the install script:
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

### The backup script
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

### For more information check out the other README files and the code.
```
.
├── README.md
└── files
    ├── bash
    │   └── README.md
    ├── hammerspoon
    │   └── README.md
    └── i3
        └── README.md
```
