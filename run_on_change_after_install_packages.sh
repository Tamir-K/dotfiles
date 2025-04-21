#!/bin/bash -e

readonly KEYRING_DIR="/usr/share/keyrings"
readonly REPO_FORMAT="deb [signed-by=${KEYRING_DIR}/%s-keyring.gpg] %s %s %s"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly CUSTOM_REPOS_FILE="${SOURCE_LIST_DIR}/custom_repos.list"
readonly TEMP_DEB_DIR="/tmp/debfiles"
readonly UBUNTU_RELEASE=$(grep '^DISTRIB_RELEASE=' /etc/upstream-release/lsb-release | cut -d'=' -f2)   # Get Ubuntu upstream version for Linux Mint
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
readonly REPOS=(
    "signal-xenial  https://updates.signal.org/desktop/apt xenial main                      signal-desktop          https://updates.signal.org/desktop/apt/keys.asc"
    "vscodium       https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main  vscodium-archive        https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg"
    "prebuilt-mpr   https://proget.makedeb.org prebuilt-mpr ${UBUNTU_CODENAME}              prebuilt-mpr-archive    https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub"
    "megasync       https://mega.nz/linux/repo/xUbuntu ${UBUNTU_RELEASE} ./                meganz-archive          https://mega.nz/keys/MEGA_signing.key"
)
readonly ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"

download_repo_key() {
    local keyring_name=$1 key_url=$2
    curl -fsSL "$key_url" | gpg --dearmor | sudo tee "${KEYRING_DIR}/$keyring_name-keyring.gpg" > /dev/null
}

install_deb_from_url() {
    local package_url=$1
    curl -fsSL -O --create-dirs --output-dir "${TEMP_DEB_DIR}" "$package_url"
    sudo apt-get install -y "${TEMP_DEB_DIR}/$(basename "$package_url")"
}

main() {
    for repo in "${REPOS[@]}"; do
        download_repo_key $(awk '{print $5, $6}' <<< "$repo")
    done
    printf '%s\n' "${REPOS[@]}" | awk -v fmt="$REPO_FORMAT" '{printf fmt "\n", $5, $2, $3, $4}' | sudo tee "${CUSTOM_REPOS_FILE}" > /dev/null
    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
    install_deb_from_url "$ZOOM_URL"
    pipx ensurepath && pipx install protonup && protonup -y
}

main
