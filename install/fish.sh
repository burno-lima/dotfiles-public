#!/bin/bash

sudo apt install -y fish
chsh -s "$(command -v fish)"

# Fisher installation
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'

# Tide installation
fish -c 'fisher install IlanCosman/tide@v6'

cp $SCRIPT_DIR/fish/config.fish ~/.config/fish/config.fish