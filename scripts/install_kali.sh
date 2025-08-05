#!/bin/bash
# install_kali.sh
# Install latest Kali Linux VM for VirtualBox

set -euo pipefail

readonly KALI_LATEST_REPO="https://cdimage.kali.org/current"
readonly KALI_VERSION_PATTERN='href="\K[^"]*-virtualbox-amd64\.7z(?=")'
readonly KALI_LATEST_ARCHIVE=$(curl -fsSL "${KALI_LATEST_REPO}" | grep -oP "${KALI_VERSION_PATTERN}" | head -n1)
readonly KALI_ARCHIVE_URL="${KALI_LATEST_REPO}/${KALI_LATEST_ARCHIVE}"
readonly VM_DIR="${HOME}/VirtualBox VMs"
readonly VBOX_FILE="${VM_DIR}/${KALI_LATEST_ARCHIVE%%.7z}/${KALI_LATEST_ARCHIVE%%.7z}.vbox"

install_kali_vm() {
    local download_dir=$(mktemp -d)
    curl -fsSL -O --output-dir "${download_dir}" "${KALI_ARCHIVE_URL}"
    mkdir -p "${VM_DIR}"
    7z x "${download_dir}/${KALI_LATEST_ARCHIVE}" -o"${VM_DIR}"
    VBoxManage registervm "${VBOX_FILE}"
    rm -rf "${download_dir}"
}

main() {
    install_kali_vm
}

main
