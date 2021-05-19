#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/src/load.sh"

# Set ORG - dev is default
ORG_ALIAS=${1:-dev}
API_NAMES="ApplicationProfiler,Dashboard_Admin"

set_org_alias "$ORG_ALIAS"                      && \
check_preconditions                             && \
prepare_to_deploy                               && \
full_deploy                                     && \
assign_permission_sets $API_NAMES               && \
set_default_org                                 && \
open_org_in_browser                             && \
prompt "!!!!!!!!"

EXIT_CODE="$?"
if [[ -n "$EXIT_CODE" && "$EXIT_CODE" -eq 0 ]]; then
  prompt "Deployment Success ✅"
else
  prompt "Deployment Failed ❌"
fi
