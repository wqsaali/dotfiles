#!/usr/bin/env bash

token=${1}
cdir=$(pwd)
page=1

test -z $token && echo "Token is required." 1>&2 && exit 1

repos=$(curl -s --header "PRIVATE-TOKEN: $token" "http://gitlab.production.smartbox.com/api/v3/projects/owned?per_page=100&page=$page" | jq .[].ssh_url_to_repo | tr -d '"')

while [ ! -z "$repos" ]; do
  for repo in  $(echo $repos); do
    path=$(echo $repo | cut -d ':' -f2 | cut -d'.' -f1)
    echo "-=$path=-"
    if [ -d $path ]; then
      echo "  Found existing repo pulling latest changes"
      cd $path
      git pull
      cd $cdir
    else
      echo "  Repo not found starting clone process"
      mkdir -p $path
      git clone $repo $path
    fi
  done
  page=$((page+1))
  repos=$(curl -s --header "PRIVATE-TOKEN: $token" "http://gitlab.production.smartbox.com/api/v3/projects/owned?per_page=100&page=$page" | jq .[].ssh_url_to_repo | tr -d '"')
done
