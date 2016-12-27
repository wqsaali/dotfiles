#!/usr/bin/env bash
sudo rm -f /tmp/update.txt; tput setaf 6; echo "Initializing.. Please Wait"
sudo apt-get update >> /tmp/update.txt 2>&1; awk '( /E:|W:/ && /launchpad/ && /404/ ) { print substr($5,26) }' /tmp/update.txt > /tmp/awk.txt; awk -F '/' '{ print $1"/"$2 }' /tmp/awk.txt > /tmp/awk1.txt; sort -u /tmp/awk1.txt > /tmp/awk2.txt
tput sgr0
if [ -s /tmp/awk2.txt ]
then
  tput setaf 1
  printf "PPA's going to be removed\n%s\n" "$(cat /tmp/awk2.txt)"
  tput sgr0
  while read -r line; do echo "sudo add-apt-repository -r ppa:$line"; done < /tmp/awk2.txt > /tmp/out
  bash /tmp/out
else
  tput setaf 1
  echo "No PPA's to be removed"
  tput sgr0
fi
rm -f /tmp/update.txt
rm -f /tmp/awk*.txt
rm -rf /tmp/out
