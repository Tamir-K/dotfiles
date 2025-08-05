#!/bin/bash
# apt_utils.sh
# Utility functions for the apt package manager

readonly KEYRING_DIR="/usr/share/keyrings"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly REPO_FORMAT="deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_DIR}/%s-keyring.gpg] %s\n"

add_apt_repository() {
    local repo_name=$1
    local repo_entry=$2
    local keyring_name=$3
    local key_url=$4
    curl -fsSL "${key_url}" | gpg --dearmor | sudo tee "${KEYRING_DIR}/${keyring_name}-keyring.gpg" > /dev/null
    printf "${REPO_FORMAT}" "${keyring_name}" "${repo_entry}" | sudo tee "${SOURCE_LIST_DIR}/${repo_name}.list" > /dev/null
}

install_deb_from_url() {
    local temp_file=$(mktemp --suffix=.deb)
    local package_url=$1
    curl -fsSL -o "${temp_file}" "${package_url}"
    sudo apt-get install -y "${temp_file}"
    rm -f "${temp_file}"
}
