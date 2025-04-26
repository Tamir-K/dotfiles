#!/bin/bash
#
# Install protonup using pipx,
# then install the latest version of protonGE

set -euo pipefail

install_proton() {
    pipx ensurepath 
    pipx install protonup
    protonup -y
}

main() {
    install_proton
}

main
