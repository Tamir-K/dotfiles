#!/bin/bash
#
# Provision system baseline

set -euo pipefail

readonly AUTO_CPUFREQ_PATH=$(mktemp -d)
readonly AUTO_CPUFREQ_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"

# Install package baseline using ansible
install_packages() {
    sudo apt-get install -y ansible
    source /etc/upstream-release/lsb-release    # Get Ubuntu upstream info for Linux Mint
    export DISTRIB_RELEASE DISTRIB_CODENAME
    ansible-playbook mint_package_install.yaml
}

# Install auto-cpufreq daemon from GitHub
install_auto_cpufreq() {
    git clone --depth=1 "${AUTO_CPUFREQ_URL}" "${AUTO_CPUFREQ_PATH}"
    sudo "${AUTO_CPUFREQ_PATH}/auto-cpufreq-installer"
    sudo auto-cpufreq --install
}

# Cleanup temporary files
cleanup() {
    rm -rf "${AUTO_CPUFREQ_PATH}"
}

main() {
    trap cleanup EXIT
    install_packages
    install_auto_cpufreq
}

main
