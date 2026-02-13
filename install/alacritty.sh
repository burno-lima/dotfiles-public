#!/bin/bash

sudo apt install -y alacritty

mkdir -p ~/.config/alacritty
mkdir -p ~/.config/alacritty/themes
cp $SCRIPT_DIR/configs/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp $SCRIPT_DIR/configs/alacritty/themes/solarized_osaka_dark.toml ~/.config/alacritty/themes/solarized_osaka_dark.toml

source $SCRIPT_DIR/set-alacritty-default.sh