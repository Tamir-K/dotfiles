#!/bin/bash
#
# Install latest Kali Linux VM for virtual box

set -euo pipefail

readonly KALI_URL="https://kali.download/virtual-images/kali-latest/kali-linux-latest-virtualbox-amd64.7z"
readonly OVA_FILE="kali-linux-latest.ova"
readonly VM_NAME="KaliLinux"
readonly VM_DIR="${HOME}/VirtualBox VMs"
readonly DOWNLOAD_DIR=$(mktemp -d)


install_kali_vm() {
    local archive_name="${KALI_URL##*/}"
    curl -fsSL -O --output-dir "${DOWNLOAD_DIR}" "${KALI_URL}"
    7z x "${DOWNLOAD_DIR}/${archive_name}" -o "${VM_DIR}"
    VBoxManage import "${VM_DIR}/${OVA_FILE}" --vsys 0 --vmname "${VM_NAME}"
    VBoxManage modifyvm "$VM_NAME" --memory 2048 --vram 16 --nic1 nat
}

cleanup() {
    rm -rf "${DOWNLOAD_DIR}"
}

main() {
    trap cleanup EXIT
    install_kali_vm
}

main
