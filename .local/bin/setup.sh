#!/bin/bash
# setup.sh
# Provision baseline for a linux mint system

set -euo pipefail

source /etc/upstream-release/lsb-release    # Get Ubuntu upstream info for Linux Mint

readonly KEYRING_DIR="/usr/share/keyrings"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly REPO_FORMAT="deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_DIR}/%s-keyring.gpg] %s\n"
readonly DEPENDENCIES=(extrepo git)
readonly PACKAGES=(
    virt-manager
    wireshark
    steam
    texlive
    texlive-latex-extra
    texlive-fonts-recommended
    torbrowser-launcher
    fzf
    podman
    podman-compose
    gh
)
readonly EXTREPO_REPO_NAMES=(mozilla signal vscodium slack)
readonly EXTREPO_PACKAGES=(signal-desktop codium slack-desktop)
readonly PRISMLAUNCHER_REPO=(
    prismlauncher
    "https://prism-launcher-for-debian.github.io/repo ${DISTRIB_CODENAME} main"
    prismlauncher-archive
    https://prism-launcher-for-debian.github.io/repo/prismlauncher.gpg
)
readonly PRISMLAUNCHER_PACKAGE=(prismlauncher)
readonly CODIUM_EXTENSIONS=(
    james-yu.latex-workshop
    ms-python.python
    ms-python.black-formatter
    ms-toolsai.jupyter
    google.colab
    google.geminicodeassist
)
readonly MEGA_URL="https://mega.nz/linux/repo/xUbuntu_${DISTRIB_RELEASE}/amd64/megasync-xUbuntu_${DISTRIB_RELEASE}_amd64.deb"
readonly ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"

add_apt_repository() {
    local repo_name=$1
    local repo_entry=$2
    local keyring_name=$3
    local key_url=$4
    curl -fsSL "${key_url}" | gpg --dearmor | sudo tee "${KEYRING_DIR}/${keyring_name}-keyring.gpg" > /dev/null
    printf "${REPO_FORMAT}" "${keyring_name}" "${repo_entry}" | sudo tee "${SOURCE_LIST_DIR}/${repo_name}.list" > /dev/null
}

install_deb_from_url() {
    local temp_file=$(mktemp --suffix=.deb)
    local package_url=$1
    curl -fsSL -o "${temp_file}" "${package_url}"
    sudo apt-get install -y "${temp_file}"
    rm -f "${temp_file}"
}

install_dependencies() {
    sudo apt-get update && sudo apt-get install -y "${DEPENDENCIES[@]}"
}

install_regular_packages() {
    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
    sudo usermod -aG libvirt $(whoami) && sudo usermod -aG kvm $(whoami)    # Add user to groups needed for virt-manager
}

install_extrepo_packages() {
    sudo sed -i 's/# - non-free/- non-free/' /etc/extrepo/config.yaml
    printf "%s\n" "${EXTREPO_REPO_NAMES[@]}" | xargs -n 1 sudo extrepo enable
    sudo apt-get update && sudo apt-get install -y "${EXTREPO_PACKAGES[@]}"
}

install_prismlauncher() {
    add_apt_repository "${PRISMLAUNCHER_REPO[@]}"
    sudo apt-get update && sudo apt-get install -y "${PRISMLAUNCHER_PACKAGE[@]}"
}

install_codium_extensions() {
    printf "%s\n" "${CODIUM_EXTENSIONS[@]}" | xargs -n 1 codium --install-extension
}

main() {
    install_dependencies
    install_regular_packages
    install_extrepo_packages
    install_prismlauncher
    install_deb_from_url $MEGA_URL
    install_deb_from_url $ZOOM_URL
    install_codium_extensions
}

main
