#!/bin/bash

mkdir -p ~/.local/share/fonts

cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip Hack.zip -d HackFont
cp HackFont/*.ttf ~/.local/share/fonts
rm -rf Hack.zip HackFont

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -rf CascadiaMono.zip CascadiaFont

fc-cache
cd -
