#!/usr/bin/env bash

INSTALLDIR=$(pwd)
dotfiles_dir="$(dirname $0)"
CMD="${1:-all}"
shift
ARGS="${@}"

source ${dotfiles_dir}/files/scripts/hubinstall
source ${dotfiles_dir}/files/scripts/hashinstall
source ${dotfiles_dir}/files/scripts/gobinaries

isFunction() { declare -F -- "$@" >/dev/null; }

path() {
  mkdir -p "$(dirname "$1")"
  echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

link() {
  create_link "$dotfiles_dir/$1" "${HOME}/$1"
}

create_link() {
  real_file="$(path "$1")"
  link_file="$(path "$2")"

  rm -rf $link_file
  ln -s $real_file $link_file

  echo "$real_file <-> $link_file"
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "${@}"
  else
    gem install "${@}"
    # rbenv rehash
  fi
}

git_clone_or_update() {
  if ! [ -x "$(command -v git)" ]; then
    echo 'You need to install git!' >&2
    exit 1
  fi

  echo ">>> $(basename $2)"
  if [ ! -d  ${2} ]; then
    git clone ${1} ${2}
  else
    cd ${2}
    git pull
    cd ${INSTALLDIR}
  fi
}

getNerdFont() {
  getFromRawGithub 'ryanoasis/nerd-fonts/' "patched-fonts/${1}" 'latest'
}

installEls() {
  installFromRawGithub 'AnthonyDiGirolamo/els'
}

installAwless() {
  pipeBashFromRawGithub 'wallix/awless/master' 'getawless.sh'
  mv awless ~/.local/bin/
}

installFastPath() {
  # https://github.com/mfornasa/docker-fastpath
  mkdir -p ~/.local/bin/
  version='linux'
  arch='-amb64'
  if [[ "$OSTYPE" == "darwin"* ]]; then
    version='osx'
    arch=''
  fi
  curl https://docker-fastpath.s3-eu-west-1.amazonaws.com/releases/${version}/docker-fastpath-${version}${arch}-latest.zip > fastpath.zip
  unzip fastpath.zip
  chmod +x fastpath && mv fastpath ~/.local/bin/
}

installFission() {
  # http://fission.io/
  mkdir -p ~/.local/bin/
  version='linux'
  if [[ "$OSTYPE" == "darwin"* ]]; then
    version='mac'
  fi
  curl http://fission.io/$version/fission > fission && chmod +x fission && mv fission ~/.local/bin/
}

installMinikube() {
  mkdir -p ~/.local/bin/
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64
  chmod +x minikube
  mv minikube ~/.local/bin/
}

installKrew() {
  mkdir -p ${HOME}/.krew/bin
  cd "$(mktemp -d)" &&
  curl -fsSLO "https://storage.googleapis.com/krew/latest/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install --manifest=krew.yaml --archive=krew.tar.gz
  cd ${INSTALLDIR}

  # install krew packages
  kubectl krew update
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    kubectl krew install "${PKG}"
  done < files/pkgs/krew.lst
}

installKubeScripts() {
  git_clone_or_update https://github.com/arunvelsriram/kube-fzf.git ${HOME}/.kube-fzf
  git_clone_or_update https://github.com/kubermatic/fubectl.git ${HOME}/.fubectl
  git_clone_or_update https://github.com/heptiolabs/ktx ${HOME}/.ktx
  # git_clone_or_update https://github.com/alexppg/kbenv.git ${HOME}/.kbenv
  # git_clone_or_update https://github.com/alexppg/helmenv.git ${HOME}/.helmenv

  installKrew

  installFromRawGithub 'johanhaleby/kubetail'
  installFromRawGithub 'ctron/kill-kube-ns'
  # installFromRawGithub 'ahmetb/kubectx'
  # installFromRawGithub 'ahmetb/kubectx' 'kubens'

  installFromGithub 'flavio/kuberlr' "${1}" "${2}"
  # installFromGithub 'Praqma/helmsman' "${1}" "${2}"
  installFromGithub 'shyiko/kubesec' "${1}" "${2}"
  installFromGithub 'kubermatic/kubeone' "${1}" "${2}"
  installFromGithub 'kubernetes-sigs/kustomize' "${1}" "${2}"
  installFromGithub 'kubernetes-sigs/kubebuilder' "${1}" "${2}"
  # installFromGithub 'operator-framework/operator-sdk' "${1}" "${2}"
  installFromGithub 'nutellinoit/kubenvz' "${1}" "${2}"
  installFromGithub 'k14s/ytt' "${1}" "${2}"
  installFromGithub 'jaredallard/localizer' "${1}" "${2}"

  if [ ! -s ${HOME}/.local/bin/kuberlr ]; then
    ln -s ${HOME}/.local/bin/kuberlr ${HOME}/.local/bin/kubectl
  fi

  installHelmPlugins
}

installDCOScli() {
  mkdir -p ~/.local/bin/
  curl -Lo dcos https://downloads.dcos.io/binaries/cli/$(uname -s | tr '[:upper:]' '[:lower:]')/x86-64/latest/dcos
  chmod +x dcos
  mv dcos ~/.local/bin/
}

installGoss() {
  mkdir -p ~/.local/bin/
  curl -fsSL https://goss.rocks/install | GOSS_DST=~/.local/bin sh
}

installDepcon() {
  installFromGithub 'ContainX/depcon' ${1} ${2}
}

installCargo() {
  if ! [ -x "$(command -v cargo)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ${HOME}/.cargo/env
    rustup component add rls rust-analysis rust-src
  fi

  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    cargo install --force "${PKG}"
  done < files/pkgs/cargo.lst
}

installGems() {
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    gem_install_or_update "${PKG}"
  done < files/pkgs/gem.lst
}

installChefGems() {
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    chef gem install "${PKG}"
  done < files/pkgs/chef_gem.lst
}

installPips() {
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    pip install -U "${PKG}"
  done < files/pkgs/pip.lst
}

installNpms() {
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    npm install -g "${PKG}"
  done < files/pkgs/npm.lst
}

cleanGoPkgs() {
  go clean -modcache
  rm -rf ${HOME}/.glide/*
  rm -rf ${GOPATH/:*}/src/*
  rm -rf ${GOPATH/:*}/pkg/*
  rm -rf ${GOPATH/:*}/.cache
  rm -rf ${HOME}/.cache/go-build/
}

installGoPkgs() {
  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    echo ">>> ${PKG}"
    goinstall "${PKG}"
  done < files/pkgs/go.lst
  cd ${INSTALLDIR}
}

installHelmPlugins() {
  if ! [ -x "$(command -v helm)" ]; then
    if [[ "$OSTYPE" == *"android"* ]]; then
      cd ${INSTALLDIR}
      cleanGoPkgs
      echo ">>> helm"
      go get -d -u k8s.io/helm/cmd/helm
      cd ${GOPATH/:*}/src/k8s.io/helm/
      make bootstrap build
      mv bin/* ${GOPATH/:*}/bin/
      echo ">>> Cleanup go sources"
      cd ${INSTALLDIR}
      cleanGoPkgs
    elif [[ "$OSTYPE" != "darwin"* ]]; then
      sudo apt-get install helm
    else
      brew install kubernetes-helm
    fi
  fi

  if [ "$(helm version --short 2>/dev/null | grep -Eo 'Client')" == "Client" ]; then
    helm init --client-only
  fi

  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    helm plugin install "${PKG}"
  done < files/pkgs/helm.lst
}

installTestssl() {
  git_clone_or_update https://github.com/drwetter/testssl.sh.git ${HOME}/.testssl
  if [ ! -s ${HOME}/.local/bin/testssl ]; then
    ln -s ${HOME}/.testssl/testssl.sh ${HOME}/.local/bin/testssl
  fi
}

installScripts() {
  mkdir -p ~/.local/bin/
  cp -r files/scripts/* ${HOME}/.local/bin/
  installFromRawGithub 'huyng/bashmarks' 'bashmarks.sh'
  installFromRawGithub 'ahmetb/goclone'
  # installFromRawGithub 'mykeels/slack-theme-cli' 'slack-theme'
  # installFromRawGithub 'smitt04/slack-dark-theme' 'darkSlack.sh'
  if [[ "$OSTYPE" == *"android"* ]]; then
    termux-fix-shebang ${HOME}/.local/bin/*
  fi
  installTestssl
  git_clone_or_update https://github.com/wookayin/kitty-tmux.git ${HOME}/.kitty-tmux

  if [[ "$OSTYPE" != *"android"* ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      installKubeScripts 'darwin' '64'
    else
      installKubeScripts 'linux' '64'
    fi
  fi
}

installChefVM() {
  git_clone_or_update https://github.com/trobrock/chefvm.git ${HOME}/.chefvm
  ~/.chefvm/bin/chefvm init
}

installAtomPackages() {
  mkdir -p ~/.atom/
  cd ${INSTALLDIR}
  # Backup package list with:
  #   apm list --installed --bare | cut -d'@' -f1 | grep -vE '^$' > atom-packages.lst
  cp files/atom/* ${HOME}/.atom/
  # apm install --packages-file files/pkgs/atom-packages.lst
  cat files/pkgs/atom-packages.lst | grep -Ev '\s*#' | xargs -L1 apm install
}

installVscodeConfig() {
  settings="$HOME/.config/Code/User"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    settings="$HOME/Library/Application Support/Code/User"
  fi
  mkdir -p "$settings"
  cp -r files/vscode/* "$settings/"
}

installVscodePackages() {
  installVscodeConfig

  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    code --install-extension "${PKG}"
  done < files/pkgs/vscode-packages.lst
}

installTmuxConf() {
  cp files/shell/tmux.conf.local ${HOME}/.tmux.conf.local
  git_clone_or_update https://github.com/gpakosz/.tmux.git ${HOME}/.tmux
  if [ ! -s ${HOME}/.tmux.conf ]; then
    ln -s ${HOME}/.tmux/.tmux.conf ${HOME}/.tmux.conf
  fi
}

installVimPlugins() {
  mkdir -p "${HOME}/.vim/config/"
  mkdir -p "${HOME}/.vim/ftdetect/"
  mkdir -p "${HOME}/.vim/ftplugin/"
  mkdir -p "${HOME}/.vim/autoload/"
  mkdir -p "${HOME}/.vim/bundle/"
  mkdir -p "${HOME}/.config/nvim/"

  cd ${INSTALLDIR}

  cp files/vim/vimrc ${HOME}/.vimrc
  cp files/vim/vimrc.local ${HOME}/.vimrc.local
  cp files/vim/coc-settings.json ${HOME}/.vim/
  cp -r files/vim/config/* ${HOME}/.vim/config/
  cp -r files/vim/ft* ${HOME}/.vim/
  if [ ! -s ~/.config/nvim/init.vim ]; then
    ln -s ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim
    ln -s ${HOME}/.vim/autoload/ ${HOME}/.config/nvim/autoload
    ln -s ${HOME}/.vim/ftdetect/ ${HOME}/.config/nvim/ftdetect
    ln -s ${HOME}/.vim/ftplugin/ ${HOME}/.config/nvim/ftplugin
    ln -s ${HOME}/.vim/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
  fi

  # Using vim-plug
  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -sLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PlugInstall +qall
}

installKakPlugins() {
  mkdir -p "${HOME}/.config/kak/plugins/"
  mkdir -p "${HOME}/.config/kak-lsp/"

  git_clone_or_update https://github.com/andreyorst/plug.kak.git ${HOME}/.config/kak/plugins/plug.kak

  cd ${INSTALLDIR}

  cp files/kak/kakrc ${HOME}/.config/kak/kakrc
  cp files/kak/*.kak ${HOME}/.config/kak/
  cp -r files/kak/snippets ${HOME}/.config/kak/
  cp files/kak/kak-lsp.toml ${HOME}/.config/kak-lsp/kak-lsp.toml

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -s $HOME/Library/Preferences/kak-lsp ]; then
      ln -s ${HOME}/.config/kak-lsp $HOME/Library/Preferences/kak-lsp
    fi
  fi

}

installGitConf() {
  source config.sh
  #read -p "Please enter your name (for gitconfig):" NAME
  #read -p "Please enter your email address (for gitconfig):" EMAIL

  # cp files/git/gitconfig ${HOME}/.gitconfig
  sedcmd=''
  for var in NAME EMAIL; do
    printf -v sc 's|${%s}|%s|;' ${var} "${!var//\//\\/}"
    sedcmd+="${sc}"
  done
  cat files/git/gitconfig | sed -e "${sedcmd}" > ${HOME}/.gitconfig
  cp files/git/gitexcludes ${HOME}/.gitexcludes
}

installShellConf() {
  cp files/shell/variables ${HOME}/.variables
  cp files/shell/profile ${HOME}/.profile
  cp -r files/shell/aliases.d/* $HOME/.aliases.d

  #cp files/shell/aliases ${HOME}/.aliases
  sedcmd=''
  for var in $(echo ${CONF}); do
    printf -v sc 's|${%s}|%s|;' ${var} "${!var//\//\\/}"
    sedcmd+="${sc}"
  done
  cat files/shell/aliases | sed -e "${sedcmd}" > ${HOME}/.aliases

  git_clone_or_update https://github.com/ahmetb/kubectl-aliases.git ${HOME}/.kubectl_aliases

  # installFishConf
  installBashConf
  installZshConf
  installTmuxConf
  installGitConf
}

installBashConf() {
  if [ -z "${SHELLVARS}" ]; then
    SHELLVARS=$(comm -3 <(compgen -v | sort) <(compgen -e | sort) | grep -v '^_')
    source config.sh
    CONF=$(comm -3 <(compgen -v | sort) <(compgen -e | sort) | grep -v '^_')
    CONF=$(comm -3 <(echo ${CONF} | tr ' ' '\n' | sort -u ) <(echo ${SHELLVARS} | tr ' ' '\n' | sort -u) | grep -v 'SHELLVARS')
  fi

  mkdir -p ${HOME}/.bash/

  cd ${INSTALLDIR}

  cp files/shell/bash/git_prompt.sh ${HOME}/.bash/
  cp files/shell/bash/git-prompt-colors.sh ${HOME}/.git-prompt-colors.sh
  cp files/shell/bash/shell_prompt.sh ${HOME}/.bash/
  cp files/shell/bash/bashrc ${HOME}/.bashrc
  cp files/shell/bash/bash_profile ${HOME}/.bash_profile

  git_clone_or_update https://github.com/cykerway/complete-alias.git ${HOME}/.bash/complete-alias
  git_clone_or_update https://github.com/magicmonty/bash-git-prompt.git ${HOME}/.bash/bash-git-prompt
  git_clone_or_update https://github.com/jonmosco/kube-ps1.git ${HOME}/.bash/kube-ps1
  git_clone_or_update https://github.com/milkbikis/powerline-shell ${HOME}/.bash/powerline-shell

  source ${HOME}/.bash_profile
}

installFishConf() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt-get update
    sudo apt-get install fish
  else
    brew install fish
  fi
  curl -sfL https://git.io/fundle-install | fish
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
  fisher add fzf edc/bass omf/thefuck omf/wttr omf/vundle ansible-completion docker-completion
  fisher add teapot

  while IFS='' read -r PKG; do
    [[ -z "${PKG}" ]] && continue
    [[ "${PKG}" =~ ^#.*$ ]] && continue
    [[ "${PKG}" =~ ^\\s*$ ]] && continue
    omf install "${PKG}"
  done < files/pkgs/omf.lst
}

installZshConf() {
  ZSH=${ZSH:-${HOME}/.oh-my-zsh}
  ZSH_CUSTOM=${ZSH_CUSTOM:-${ZSH}/custom}

  echo ">>> oh-my-zsh"
  if [ ! -d ${HOME}/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    cd ${HOME}/.oh-my-zsh
    git pull
    cd ${INSTALLDIR}
  fi

  git_clone_or_update https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt"
  if [ ! -s "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
    ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"
  fi
  git_clone_or_update https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
  git_clone_or_update https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
  git_clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
  git_clone_or_update https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
  git_clone_or_update https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM}/plugins/zsh-history-substring-search
  git_clone_or_update https://github.com/hlissner/zsh-autopair.git ${ZSH_CUSTOM}/plugins/zsh-autopair
  git_clone_or_update https://github.com/Aloxaf/fzf-tab.git ${ZSH_CUSTOM}/plugins/fzf-tab

  cp files/shell/zsh/zshrc ${HOME}/.zshrc
  cp files/shell/zsh/zshHighlightStyle ${HOME}/.zshrcHighlightStyle
  cp files/shell/zsh/p10k.zsh ${HOME}/.p10k.zsh
}

createSkeleton() {
  dirs=$(cat config.sh | awk -F\' '{print $2}' | grep 'HOME')
  for d in $(envsubst <<< "${dirs}"); do
    mkdir -p "${d}"
  done

  for dir in $(ls -1d files/config/*/); do mkdir -p ${HOME}/.config/${dir##*/}; done

  [ -d ${HOME}/workingCopies/code ] || ln -s ${HOME}/workingCopies/src ${HOME}/workingCopies/code

  mkdir -p ${HOME}/.local/bin/
  mkdir -p ${HOME}/.local/share/bash-completion
  [ -d ${HOME}/.bin ] || ln -s ${HOME}/.local/bin ${HOME}/.bin

  mkdir -p ${HOME}/.aliases.d
  mkdir -p ${HOME}/.ptpython
  mkdir -p ${HOME}/.atom
  mkdir -p ${HOME}/.kube
}

instrallRangerPlugins() {
  rm -f ${HOME}/.config/ranger/*.{sh,py}
  ranger --copy-config=all
  mkdir -p ${HOME}/.ranger_plugins/
  git_clone_or_update https://github.com/alexanderjeurissen/ranger_devicons.git ${HOME}/.ranger_plugins/ranger_devicons
}

installDotFiles() {
  createSkeleton
  installShellConf
  installScripts

  # Set alacritty themes with:
  # alacritty-colorscheme -C ~/.alacritty-theme/themes -a tomorrow_night_bright.yaml -V
  # a matchin vim theme will also be created in ~/.vimrc_background
  git_clone_or_update https://github.com/eendroroy/alacritty-theme.git ${HOME}/.alacritty-theme


  # kitty themes
  git _clone_or_update https://github.com/dexpota/kitty-themes.git ${HOME}/.kitty-themes

  for dir in $(ls -1d files/config/*/); do
    cp -r files/config/${dir##*/}/* ${HOME}/.config/${dir##*/}/
  done

  cp files/config/kubie.yaml ${HOME}/.kube/kubie.yaml
  cp files/config/starship.toml ${HOME}/.config/starship.toml
  cp files/shell/screenrc ${HOME}/.screenrc
  cp files/atom/* ${HOME}/.atom/
  cp files/ptpython.py ${HOME}/.ptpython/config.py
  cp files/pipecolor.toml ${HOME}/.pipecolor.toml

  installOSSpecific dotfiles

  installVscodeConfig
  installVimPlugins
  instrallRangerPlugins

  if [ -x "$(command -v bat)" ]; then
    mkdir -p "${HOME}/.config/bat/themes"
    git_clone_or_update https://github.com/theymaybecoders/sublime-tomorrow-theme.git "${HOME}/.config/bat/themes/sublime-tomorrow-theme"
    bat cache --build
  fi

  if [ -x "$(command -v mdatp)" ]; then
    for F in $(cat files/mdatp.lst|envsubst); do mdatp exclusion folder add --path ${F}; done
  fi
}

installWebApps() {
  npm install -g nativefier
  nativefier --name 'Whatsapp Web' 'https://web.whatsapp.com/'
  nativefier --name 'Evernote Web' 'https://www.evernote.com/Home.action?login=true&prompt=none&authuser=0#n=66f8e46f-8a98-4294-b42f-8abf8cb9774a&s=s14&ses=4&sh=2&sds=5&'
}

installPackages() {
  installGems
  installPips
  installNpms
  installGoPkgs

  installChefGems
  installChefVM
  installVagrantPlugins
  installAtomPackages
  installVscodePackages
  installGoss
  installEls
}

installOSSpecific(){
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ./osx.sh "${@}"
  elif [[ "$OSTYPE" == *"android"* ]]; then
    ./android.sh "${@}"
  else
    ./linux.sh "${@}"
  fi
}

installAll() {
  if [[ "$OSTYPE" != *"android"* ]]; then
    installPackages
  fi
  # installWebApps
  installDotFiles
}

if isFunction "${CMD}"; then
  $CMD "${ARGS}"
  exit $?
elif isFunction "install${CMD}"; then
  "install${CMD}" "${ARGS}"
  exit $?
fi

case "$CMD" in
  "gems" | "gem")
    installGems
    ;;
  "chef_gems" | "chefgems")
    installChefGems
    ;;
  "pip" | "pips")
    installPips
    ;;
  "npm" | "npms")
    installNpms
    ;;
  "go" | "gopkgs")
    installGoPkgs
    ;;
  "dotfiles")
    installDotFiles
    ;;
  "scripts")
    installScripts
    ;;
  "vimplugins" | "vim")
    installVimPlugins
    ;;
  "KakPlugins" | "kak")
    installKakPlugins
    ;;
  "atompackages" | "apkgs" | "atom" | "apm")
    installAtomPackages
    ;;
  "vscodepackages" | "vscode" | "vspkgs")
    installVscodePackages
    ;;
  "vagrant" | "VagrantPlugins")
    installVagrantPlugins
    ;;
  "helm" | "helmplugins")
    installHelmPlugins
    ;;
  *)
    installOSSpecific "${CMD}" "${ARGS}"
    if [ -z "${CMD}" ] || [[ "${CMD}" == "all" ]]; then
      installAll
    fi
    ;;
esac
