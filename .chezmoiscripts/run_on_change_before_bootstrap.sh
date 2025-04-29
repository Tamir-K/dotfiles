#!/bin/bash
#
# Apply basic changes to system

set -euo pipefail


main() {
    sudo apt-get install -y ansible
    source /etc/upstream-release/lsb-release # Get Ubuntu upstream info for Linux Mint
    export DISTRIB_RELEASE DISTRIB_CODENAME
    ansible-playbook mint_package_install.yaml
}

main
