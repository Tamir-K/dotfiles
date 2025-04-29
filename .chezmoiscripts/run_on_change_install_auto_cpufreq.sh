#!/bin/bash
#
# Install auto-cpufreq as a daemon from GitHub

set -euo pipefail

readonly AUTO_CPUFREQ_PATH=$(mktemp -d)
readonly AUTO_CPUFREQ_URL="https://github.com/AdnanHodzic/auto-cpufreq.git"

install_auto_cpufreq() {
    git clone --depth=1 "${AUTO_CPUFREQ_URL}" "${AUTO_CPUFREQ_PATH}"
    sudo "${AUTO_CPUFREQ_PATH}/auto-cpufreq-installer"
    sudo auto-cpufreq --install
}

cleanup() {
    rm -rf "${AUTO_CPUFREQ_PATH}"
}

main() {
    trap cleanup EXIT
    install_auto_cpufreq
}

main
