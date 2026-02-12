#!/bin/bash

# Only install on Ubuntu (Mint and Debian already have it by default)
if grep -q "Ubuntu" /etc/os-release; then
  sudo apt install -y flatpak
  sudo apt install -y gnome-software-plugin-flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi
