#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/os.sh"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/ssl-certs.sh"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/deployer.sh"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/checks.sh"
