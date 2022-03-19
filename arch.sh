#!/usr/bin/env bash

installPackages() {
  pacman -Syu
  cat files/pkgs/pacman.lst | grep -v '^$\|^\s*\#' | tr '\n' ' ' | xargs sudo pacman -S
}
