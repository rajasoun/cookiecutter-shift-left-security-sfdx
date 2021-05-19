#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/src/load.sh"

function list_internal_functions() {
    declare -F | awk '{print $NF}' | grep -E  "^_"
}

function _help() {
    declare -F | awk '{print $NF}' | sort | grep -E -v "^_"
}

if [ "_$1" = "_" ]; then
    prompt "${BOLD}${UNDERLINE}Utility Script to Individualy execute functions${NC}"
    _help
else
    "$@"
fi
