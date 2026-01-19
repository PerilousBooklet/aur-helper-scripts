#!/bin/bash

if [[ ! -d .chroot ]]; then
  arch-nspawn .chroot/root pacman -Syu
fi

for i in ./packages/*; do
  makechrootpkg --printsrcinfo > .SRCINFO
  makechrootpkg -c -u -n -r ../../.chroot
  PKG=$(basename "$i")
  echo -e "\e[32m[INFO]\e[0m Built $PKG"
done
