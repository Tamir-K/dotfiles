#!/bin/bash
#
# setup.sh
# Provision baseline for a linux mint system

set -euo pipefail

source /etc/upstream-release/lsb-release # Get Ubuntu upstream info for Linux Mint

readonly DEPENDENCIES=(extrepo git)
readonly PACKAGES=(
    virtualbox
    wireshark
    steam
    texlive-full
    torbrowser-launcher
    signal-desktop
    codium
    prismlauncher
)
readonly EXTERNAL_PACKAGES=(
    "https://mega.nz/linux/repo/xUbuntu_${DISTRIB_RELEASE}/amd64/megasync-xUbuntu_${DISTRIB_RELEASE}_amd64.deb" # Mega
    "https://zoom.us/client/latest/zoom_amd64.deb"  # Zoom
)
readonly EXTREPO_NAMES=(signal vscodium)
readonly CODIUM_EXTENSIONS=(
    foxundermoon.shell-format
    james-yu.latex-workshop
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
)
readonly AUTO_CPUFREQ_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"

install_deb_from_url() {
    local temp_file=$(mktemp --suffix=.deb)
    local package_url=$1
    trap 'rm -f "${temp_file}"' EXIT
    curl -fsSL -o "${temp_file}" "${package_url}"
    sudo apt-get install -y "${temp_file}"
}

install_packages() {
    sudo apt-get install -y "${DEPENDENCIES[@]}"
    sudo sed -i 's/# - non-free/- non-free/' /etc/extrepo/config.yaml
    printf "%s\n" "${EXTREPO_NAMES[@]}" | xargs -n 1 sudo extrepo enable # Enable extrepo repositories
    source add_prebuilt_mpr.sh
    sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}"
    printf "%s\n" "${EXTERNAL_PACKAGES[@]}" | xargs -n 1 install_deb_from_url # Install external packages
    printf "%s\n" "${CODIUM_EXTENSIONS[@]}" | xargs -n 1 codium --install-extension # Install Codium extensions
}

install_auto_cpufreq() {
    local temp_dir=$(mktemp -d)
    trap "rm -rf '${temp_dir}'" EXIT
    git clone --depth=1 "${AUTO_CPUFREQ_URL}" "${temp_dir}"
    sudo "${temp_dir}/auto-cpufreq-installer"
    sudo auto-cpufreq --install
}

main() {
    install_packages
    install_auto_cpufreq
    source install_kali.sh
}

main
