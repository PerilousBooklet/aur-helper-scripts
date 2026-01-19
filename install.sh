#!/bin/bash
PKGS=$(find packages/ -maxdepth 1 -type d | sed 's|packages/||g' | sort)
for i in $PKGS; do
  if [[ ! -d "$i" ]]; then
    echo -e "\e[32m[INFO]\e[0m Installing $i"
    sudo pacman -U packages/"$i".pkg.zst.gz
  else
    echo -e "\e[33m[WARNING]\e[0m Package $i is already installed!"
  fi
done
