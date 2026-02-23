#!/bin/bash

sudo apt-get install -y wget gpg

cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg
cd -

sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

mkdir -p ~/.config/Code/User

cp $SCRIPT_DIR/configs/vscode.json ~/.config/Code/User/settings.json

code --install-extension github.github-vscode-theme
