#!/usr/bin/env bash

# Checks if the ORG_ALIAS environment variable is not Empty or Null
function is_org_alias_set() {
    # Check if ORG_ALIAS is passed as a parameter to script
    # if not raise error
    [[ -z "$ORG_ALIAS" ]] && raise_error "ORG_ALIAS is not Set... Exiting ❌" && return 1
    return 0
}

# promt error message and exit
function raise_error(){
  echo -e "${RED}${1}${NC}" >&2
  exit 1
}

# Checks if the commands jq, openssl and docker are found
function check_preconditions() {
  _is_command_found jq
  _is_command_found openssl
  # _is_command_found docker
  _is_command_found sfdx
  _is_command_found cci
  prompt "Preconditions Check ✅"
  return 0
}

# Wrapper To Aid TDD
function _run_main(){
    _is_org_alias_set "$@"
    raise_error "$@"
    check_preconditions "$@"
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! _run_main "$@"
  then
    exit 1
  fi
fi
