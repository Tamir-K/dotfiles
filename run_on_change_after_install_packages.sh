#!/bin/bash -e

# Constants
readonly KEYRING_DIR="/usr/share/keyrings"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly TEMP_DEB_DIR="/tmp/debfiles"
readonly UBUNTU_RELEASE=$(grep '^DISTRIB_RELEASE=' /etc/upstream-release/lsb-release | cut -d'=' -f2) # Get Ubuntu upstream version for Linux Mint
readonly UBUNTU_CODENAME=$(grep '^DISTRIB_CODENAME=' /etc/upstream-release/lsb-release | cut -d'=' -f2) # Get Ubuntu upstream codename for Linux Mint
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
readonly SIGNAL_KEY_URL="https://updates.signal.org/desktop/apt/keys.asc"
readonly SIGNAL_REPO="https://updates.signal.org/desktop/apt xenial main"
readonly VSCODIUM_KEY_URL="https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg"
readonly VSCODIUM_REPO="https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main"
readonly MPR_KEY_URL="https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub"
readonly MPR_REPO="https://proget.makedeb.org prebuilt-mpr ${UBUNTU_CODENAME}"
readonly MEGA_KEY_URL="https://mega.nz/keys/MEGA_signing.key"
readonly MEGA_REPO="https://mega.nz/linux/repo/xUbuntu_${UBUNTU_RELEASE}/ ./"
readonly ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"

# Functions
add_apt_repository() {
    local repo_name=$1 repo_entry=$2 keyring_name=$3 key_url=$4
    curl -fsSL "$key_url" | gpg --dearmor | sudo tee "${KEYRING_DIR}/${keyring_name}-keyring.gpg" > /dev/null
    echo "deb [signed-by=${KEYRING_DIR}/${keyring_name}-keyring.gpg ] $repo_entry" | sudo tee "${SOURCE_LIST_DIR}/${repo_name}.list" > /dev/null
}

install_deb_from_url() {
    local package_url=$1
    curl -fsSL -O --create-dirs --output-dir "${TEMP_DEB_DIR}" "$package_url"
    sudo apt-get install -y "${TEMP_DEB_DIR}/$(basename "$package_url")"
}

main() {
    add_apt_repository "signal-xenial" "$SIGNAL_REPO" "signal-desktop" "$SIGNAL_KEY_URL"
    add_apt_repository "vscodium" "$VSCODIUM_REPO" "vscodium-archive" "$VSCODIUM_KEY_URL"
    add_apt_repository "prebuilt-mpr" "$MPR_REPO" "prebuilt-mpr-archive" "$MPR_KEY_URL"
    add_apt_repository "megasync" "$MEGA_REPO" "meganz-archive" "$MEGA_KEY_URL"

    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"

    install_deb_from_url "$ZOOM_URL"

    pipx ensurepath && pipx install protonup && protonup -y
}

main