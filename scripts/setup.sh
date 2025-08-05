#!/bin/bash
# setup.sh
# Provision baseline for a linux mint system

set -euo pipefail

source /etc/upstream-release/lsb-release    # Get Ubuntu upstream info for Linux Mint
source ${HOME}/scripts/apt_utils.sh     # Get apt util functions

readonly DEPENDENCIES=(extrepo git)
readonly PACKAGES=(
    virtualbox
    wireshark
    steam
    texlive-full
    torbrowser-launcher
    p7zip
    fzf
    signal-desktop
    codium
    prismlauncher
)
readonly MEGA_URL="https://mega.nz/linux/repo/xUbuntu_${DISTRIB_RELEASE}/amd64/megasync-xUbuntu_${DISTRIB_RELEASE}_amd64.deb"
readonly ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"
readonly EXTREPO_NAMES=(signal vscodium)
readonly MPR_REPO=(
    prebuilt-mpr
    "https://proget.makedeb.org prebuilt-mpr ${DISTRIB_CODENAME}"
    prebuilt-mpr-archive
    https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub
)
readonly CODIUM_EXTENSIONS=(
    foxundermoon.shell-format
    james-yu.latex-workshop
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
)

install_packages() {
    sudo apt-get install -y "${DEPENDENCIES[@]}"
    sudo sed -i 's/# - non-free/- non-free/' /etc/extrepo/config.yaml
    printf "%s\n" "${EXTREPO_NAMES[@]}" | xargs -n 1 sudo extrepo enable # Enable extrepo repositories
    add_apt_repository "${MPR_REPO[@]}"
    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
    install_deb_from_url $MEGA_URL
    install_deb_from_url $ZOOM_URL
    printf "%s\n" "${CODIUM_EXTENSIONS[@]}" | xargs -n 1 codium --install-extension # Install Codium extensions
}

main() {
    install_packages
    bash "${HOME}/scripts/install_auto_cpufreq.sh"
    bash "${HOME}/scripts/install_kali.sh"
}

main
