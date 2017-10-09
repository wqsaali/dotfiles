#!/usr/bin/env bash

# for repo in $(bb list -e '^dcos-.*' | grep 'thingworx' | awk '{print $3}'); do
#   if [ ! -d "$(basename ${repo})" ]; then
#     git clone git@bitbucket.org:${repo}.git
#   else
#     cd $(basename ${repo})
#     git pull
#     cd ..
#   fi
# done

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

proj="${1:non-existing-repo}"
cdir=$(pwd)
page=1
user=$(awk -F "=" '/username/ {print $2}' ~/.bitbucket | tr -d " ")
pass=$(awk -F "=" '/password/ {print $2}' ~/.bitbucket | tr -d " ")
#repos=$(curl -s -u "${user}:${pass}" "${url}&page=${page}" | jq -r '.values[].links.clone[].href | select(contains("http") | not)')
url="https://api.bitbucket.org/2.0/repositories/thingworx-ondemand/?q=project.key=\"${proj}\""
repos=$(curl -s -u "${user}:${pass}" "${url}&page=${page}" | jq -r '.values[].links.clone[] | select(.name | contains("ssh")) | .href')

while [ ! -z "${repos}" ]; do
  for repo in $(echo ${repos}); do
    path=$(basename "${repo}" | cut -d'.' -f1)
    echo -e "${COL_BLUE}-=$path=-${COL_RESET}"
    if [ -d $path ]; then
      echo -e " ${COL_YELLOW}>>>${COL_RESET} Found existing repo pulling latest changes"
      cd $path
      git pull
      cd $cdir
    else
      echo -e " ${COL_RED}>>>${COL_RESET} Repo not found starting clone process"
      mkdir -p $path
      git clone $repo $path
    fi
  done
  page=$((page+1))
  #repos=$(curl -s -u "${user}:${pass}" "${url}&page=${page}" | jq -r '.values[].links.clone[].href | select(contains("http") | not)')
  repos=$(curl -s -u "${user}:${pass}" "${url}&page=${page}" | jq -r '.values[].links.clone[] | select(.name | contains("ssh")) | .href')
done
