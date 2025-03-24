#!/bin/bash -e

# Constants for directory paths
KEYRING_DIR="/usr/share/keyrings"
SOURCE_LIST_DIR="/etc/apt/sources.list.d"
TEMP_DEB_DIR="/tmp/debfiles"

# Get Ubuntu upstream version and codename for Linux Mint
UBUNTU_RELEASE=$(grep '^DISTRIB_RELEASE=' /etc/upstream-release/lsb-release | cut -d'=' -f2)
UBUNTU_CODENAME=$(grep '^DISTRIB_CODENAME=' /etc/upstream-release/lsb-release | cut -d'=' -f2)

# List of packages to install
PACKAGES=(
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
)

# URLs for external packages
SIGNAL_KEY_URL="https://updates.signal.org/desktop/apt/keys.asc"
SIGNAL_REPO="https://updates.signal.org/desktop/apt xenial main"
VSCODIUM_KEY_URL="https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg"
VSCODIUM_REPO="https://download.vscodium.com/debs vscodium main"
MPR_KEY_URL="https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub"
MPR_REPO="https://proget.makedeb.org prebuilt-mpr ${UBUNTU_CODENAME}"
MEGA_URL="https://mega.nz/linux/repo/xUbuntu_${UBUNTU_RELEASE}/amd64/megasync-xUbuntu_${UBUNTU_RELEASE}_amd64.deb"
ZOOM_URL="https://zoom.us/client/6.4.1.587/zoom_amd64.deb"

# Function to add a GPG key
add_gpg_key() {
    local keyring_name=$1
    local key_url=$2
    echo "Adding GPG key for ${keyring_name} from ${key_url}"
    curl -fsSL "$key_url" | gpg --dearmor | sudo dd of="${KEYRING_DIR}/${keyring_name}-keyring.gpg"
}

# Function to add a repository source
add_apt_source() {
    local repo_entry=$1
    local list_name=$2
    local keyring_name=$3
    echo "Adding APT source ${list_name} with keyring ${keyring_name}"
    echo "deb [signed-by=${KEYRING_DIR}/${keyring_name}-keyring.gpg ] $repo_entry" | sudo tee "${SOURCE_LIST_DIR}/${list_name}.list" > /dev/null
}

# Function to add a repository with both keyring and apt source
add_repository() {
    local repo_entry=$1
    local list_name=$2
    local keyring_name=$3
    local key_url=$4
    add_gpg_key "$keyring_name" "$key_url"
    add_apt_source "$repo_entry" "$list_name" "$keyring_name"
}

# Function to install deb package from URL
install_deb_from_url() {
    local package_url=$1
    local package_name=$(basename "$package_url")
    echo "Downloading and installing ${package_name} from ${package_url}"
    curl -fsSL -O --create-dirs --output-dir "${TEMP_DEB_DIR}" "$package_url"
    sudo apt-get install -y "${TEMP_DEB_DIR}/${package_name}"
}

# Main function to encapsulate the script logic
main() {
    # Ensure curl and gnupg are installed for key handling
    sudo apt-get install -y curl gnupg

    # Add repositories
    add_repository "$SIGNAL_REPO" "signal-xenial" "signal-desktop" "$SIGNAL_KEY_URL"
    add_repository "$VSCODIUM_REPO" "vscodium" "vscodium-archive" "$VSCODIUM_KEY_URL"
    add_repository "$MPR_REPO" "prebuilt-mpr" "prebuilt-mpr-archive" "$MPR_KEY_URL"

    # Update and install the packages
    echo "Updating package lists and installing packages"
    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"

    # Install additional deb packages from URLs
    install_deb_from_url "$MEGA_URL"
    install_deb_from_url "$ZOOM_URL"

    # Install protonup and the latest version of ProtonGE
    echo "Installing protonup and updating ProtonGE"
    pipx install protonup && protonup -y
}

# Execute the main function
main