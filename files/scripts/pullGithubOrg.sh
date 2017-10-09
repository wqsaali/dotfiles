#!/usr/bin/env bash

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"
COL_GREY=$ESC_SEQ"38;5;245m"

TOKEN=${1}
if [[ ! -z $TOKEN ]]; then
  TOKEN="?access_token=${TOKEN}"
fi
ORG=$(basename $(pwd))

repos=$(curl -s https://api.github.com/orgs/${ORG}/repos${TOKEN} | jq -r '.[].name')

for repo in $repos; do
  upstream=''
  fork=$(curl -s https://api.github.com/orgs/${ORG}/repos${TOKEN} |jq -r ".[] | select(.name == \"${repo}\")| .fork")
  if [ $fork == "true" ]; then
    upstream=$(curl -s https://api.github.com/repos/${ORG}/${repo}${TOKEN} | jq -r '.parent.ssh_url')
  fi
  if [ ! -d ${repo} ]; then
    url=$(curl -s https://api.github.com/orgs/${ORG}/repos${TOKEN} |jq -r ".[] | select(.name == \"${repo}\")| .ssh_url")
    git clone ${url}
    if [[ ! -z $upstream ]]; then
      cd ${repo}
      echo -e "${COL_YELLOW}>>>${COL_RESET} Adding remote upstream ${upstream}"
      git remote add upstream ${upstream}
      git fetch --all
      cd ..
    fi
  else
    echo -e "${COL_YELLOW}>>>${COL_RESET} Updating ${repo}"
    cd ${repo}
    if [[ ! -z $upstream ]]; then
      if ! git remote | grep -qv 'upstream' &> /dev/null; then
        echo -e "${COL_YELLOW}>>>${COL_RESET} Adding remote upstream ${upstream}"
        git remote add upstream ${upstream}
      fi
    fi
    echo -ne "$COL_GREY"
    git pull --all
    echo -ne "$COL_RESET"
    cd ..
  fi
  if [[ ! -z $upstream ]]; then
    cd ${repo}
    echo -e "${COL_BLUE}>>>${COL_RESET} Status:"
    echo -e "    This branch is ${COL_YELLOW}$(git rev-list upstream/master..origin/master --count)${COL_RESET} commits ahead and ${COL_RED}$(git rev-list origin/master..upstream/master --count)${COL_RESET} commits behind of Upstream.\n"
    cd ..
  fi
  sleep 1
done
