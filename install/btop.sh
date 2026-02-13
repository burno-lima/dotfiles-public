#!/bin/bash

sudo apt install -y btop

mkdir -p ~/.config/btop
cp $SCRIPT_DIR/configs/btop/btop.conf ~/.config/btop/btop.conf