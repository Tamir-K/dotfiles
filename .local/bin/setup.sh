#!/bin/bash
# setup.sh
# Provision baseline for a Fedora system

set -euo pipefail

readonly RPM_FUSION=(
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
)
readonly OPENSUSE_BUILD_SERVICE_SIGNAL_REPO="https://download.opensuse.org/repositories/network:im:signal/Fedora_$(rpm -E %fedora)/network:im:signal.repo"
readonly PACKAGES=(
    git
    virt-manager
    wireshark
    steam
    texlive-scheme-full
    torbrowser-launcher
    p7zip
    fzf
    zoxide
    signal-desktop
    codium
    prismlauncher
    "https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/x86_64/megasync-Fedora_$(rpm -E %fedora).x86_64.rpm" # MegaSync
    "https://zoom.us/client/latest/zoom_x86_64.rpm" # Zoom
)
readonly CODIUM_EXTENSIONS=(
    foxundermoon.shell-format
    james-yu.latex-workshop
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
)

enable_rpm_fusion() {
    sudo dnf install -y "${RPM_FUSION[@]}"
    sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
}

add_vscodium_repo() {
    sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
}

install_packages() {
    enable_rpm_fusion
    sudo dnf config-manager addrepo --from-repofile="${OPENSUSE_BUILD_SERVICE_SIGNAL_REPO}"
    add_vscodium_repo
    sudo dnf copr enable -y g3tchoo/prismlauncher
    sudo dnf install -y "${PACKAGES[@]}"
    sudo usermod -aG libvirt $(whoami) && sudo usermod -aG kvm $(whoami) # Add user to groups needed for virt-manager
    printf "%s\n" "${CODIUM_EXTENSIONS[@]}" | xargs -n 1 codium --install-extension # Install Codium extensions
}

main() {
    install_packages
    ./install_auto_cpufreq.sh
}

main
