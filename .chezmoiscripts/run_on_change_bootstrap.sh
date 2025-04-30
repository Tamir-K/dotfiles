#!/bin/bash
#
# Provision system baseline

set -euo pipefail

readonly AUTO_CPUFREQ_PATH=$(mktemp -d)
readonly AUTO_CPUFREQ_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"
readonly CODIUM_EXTENSIONS=(
    foxundermoon.shell-format
    james-yu.latex-workshop
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
)

# Install package baseline using ansible
install_packages() {
    sudo apt-get install -y ansible
    source /etc/upstream-release/lsb-release # Get Ubuntu upstream info for Linux Mint
    export DISTRIB_RELEASE DISTRIB_CODENAME
    ansible-playbook mint_package_install.yaml
}

# Install auto-cpufreq daemon from GitHub
install_auto_cpufreq() {
    git clone --depth=1 "${AUTO_CPUFREQ_URL}" "${AUTO_CPUFREQ_PATH}"
    sudo "${AUTO_CPUFREQ_PATH}/auto-cpufreq-installer"
    sudo auto-cpufreq --install
}

# Install VSCodium extensions
install_codium_extensions() {
    printf "%s\n" "${CODIUM_EXTENSIONS[@]}" | xargs -n 1 codium --install-extension
}

# Cleanup temporary files
cleanup() {
    rm -rf "${AUTO_CPUFREQ_PATH}"
}

main() {
    trap cleanup EXIT
    install_packages
    install_codium_extensions
    install_auto_cpufreq
}

main
