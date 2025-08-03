#!/bin/bash
#
# add_prebuilt_mpr.sh
# Add the prebuilt MPR Debian repo to the source list

source /etc/upstream-release/lsb-release # Get Ubuntu upstream info for Linux Mint

readonly KEYRING_DIR="/usr/share/keyrings"
readonly SOURCE_LIST_DIR="/etc/apt/sources.list.d"
readonly REPO_FORMAT="deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_DIR}/%s-keyring.gpg] %s\n"
readonly MPR_REPO=(
    prebuilt-mpr
    "https://proget.makedeb.org prebuilt-mpr ${DISTRIB_CODENAME}"
    prebuilt-mpr-archive
    https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub
)

add_apt_repository() {
    local repo_name=$1
    local repo_entry=$2
    local keyring_name=$3
    local key_url=$4
    curl -fsSL "${key_url}" | gpg --dearmor | sudo tee "${KEYRING_DIR}/${keyring_name}-keyring.gpg" > /dev/null
    printf "${REPO_FORMAT}" "${keyring_name}" "${repo_entry}" | sudo tee "${SOURCE_LIST_DIR}/${repo_name}.list" > /dev/null
}

add_apt_repository "${MPR_REPO[@]}"