#!/bin/bash
#
# Install chezmoi from deb package and run init

readonly TEMP_DEB_DIR=$(mktemp -d)
readonly CHEZMOI_URL="https://github.com/twpayne/chezmoi/releases/download/v2.62.2/chezmoi_2.62.2_linux_amd64.deb"
readonly GITHUB_USERNAME="Tamir-K"

install_chezmoi() {
    local package_name="${CHEZMOI_URL##*/}"
    curl -fsSL -O --output-dir "${TEMP_DEB_DIR}" "${CHEZMOI_URL}"
    sudo apt-get install -y "${TEMP_DEB_DIR}/${package_name}"
}

setup_dotfiles() {
    chezmoi init --apply $GITHUB_USERNAME
}

cleanup() {
    rm -rf "${TEMP_DEB_DIR}"
}

main() {
    install_chezmoi
    setup_dotfiles
}

main

trap cleanup EXIT
