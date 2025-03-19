#!/bin/bash

curl -fsSL https://christitus.com/linux | sh -s -- --config ~/.config/linutil.toml

apt install -y git virtualbox wireshark steam pipx texlive-full

pipx install protonup

protonup

wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megasync-xUbuntu_24.04_amd64.deb && apt install -y "$PWD/megasync-xUbuntu_24.04_amd64.deb"
rm megasync-xUbuntu_24.04_amd64.deb

flatpak install -y org.prismlauncher.PrismLauncher