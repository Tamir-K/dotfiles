#!/bin/bash
#
# Add custom APT repositories and install packages

set -euo pipefail

# Get Ubuntu upstream info for Linux Mint
source /etc/upstream-release/lsb-release 

readonly KEYRING_DIR="/usr/share/keyrings"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly TEMP_DEB_DIR=$(mktemp -d)
readonly REPO_FORMAT="deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_DIR}/%s-keyring.gpg] %s\n"
readonly PACKAGES=(
    git
    virtualbox
    wireshark
    steam
    pipx
    texlive-full
    torbrowser-launcher
    signal-desktop
    codium
    prismlauncher
    megasync
    nemo-megasync
)
readonly SIGNAL_REPO=(
    signal-xenial
    "https://updates.signal.org/desktop/apt xenial main"
    signal-desktop
    https://updates.signal.org/desktop/apt/keys.asc
)
readonly VSCODIUM_REPO=(
    vscodium
    "https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main"
    vscodium-archive
    https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
)
readonly MEGA_REPO=(
    megasync
    "https://mega.nz/linux/repo/xUbuntu_${DISTRIB_RELEASE}/ ./"
    meganz-archive
    https://mega.nz/keys/MEGA_signing.key
)
readonly MPR_REPO=(
    prebuilt-mpr
    "https://proget.makedeb.org prebuilt-mpr ${DISTRIB_CODENAME}"
    prebuilt-mpr-archive
    https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub
)
readonly ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"
readonly CHEZMOI_URL="https://github.com/twpayne/chezmoi/releases/download/v2.62.2/chezmoi_2.62.2_linux_amd64.deb"

add_apt_repository() {
    local repo_name=$1
    local repo_entry=$2
    local keyring_name=$3
    local key_url=$4
    curl -fsSL "${key_url}" | gpg --dearmor | sudo tee "${KEYRING_DIR}/${keyring_name}-keyring.gpg" > /dev/null
    printf "${REPO_FORMAT}" "${keyring_name}" "${repo_entry}" | sudo tee "${SOURCE_LIST_DIR}/${repo_name}.list" > /dev/null
}

install_deb_from_url() {
    local package_url=$1
    local package_name="${package_url##*/}"
    curl -fsSL -O --output-dir "${TEMP_DEB_DIR}" "${package_url}"
    sudo apt-get install -y "${TEMP_DEB_DIR}/${package_name}"
}

add_repositories() {
    add_apt_repository "${SIGNAL_REPO[@]}"
    add_apt_repository "${VSCODIUM_REPO[@]}"
    add_apt_repository "${MEGA_REPO[@]}"
    add_apt_repository "${MPR_REPO[@]}"
}

install_packages() {
    sudo apt-get update
    sudo apt-get install -y "${PACKAGES[@]}"
    install_deb_from_url "${ZOOM_URL}"
    install_deb_from_url "${CHEZMOI_URL}"
}

cleanup() {
    rm -rf "${TEMP_DEB_DIR}"
}

main() {
    add_repositories
    install_packages
}

main

trap cleanup EXIT
