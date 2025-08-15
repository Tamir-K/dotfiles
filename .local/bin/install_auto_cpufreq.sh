#!/bin/bash
# install_auto_cpufreq.sh
# Install auto-cpufreq for CPU frequency scaling from GitHub

set -euo pipefail

readonly AUTO_CPUFREQ_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"

install_auto_cpufreq() {
    local temp_dir=$(mktemp -d)
    git clone --depth=1 "${AUTO_CPUFREQ_URL}" "${temp_dir}"
    sudo "${temp_dir}/auto-cpufreq-installer"
    sudo auto-cpufreq --install
    rm -rf "${temp_dir}"
}

main() {
    install_auto_cpufreq
}

main
