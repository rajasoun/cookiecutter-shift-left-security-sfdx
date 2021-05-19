#!/usr/bin/env bash

NC=$'\e[0m' # No Color
BOLD=$'\033[1m'
UNDERLINE=$'\033[4m'
RED=$'\e[31m'
GREEN=$'\e[32m'
BLUE=$'\e[34m'

# Create Directory if the given directory does not exists
# @param $1 The directory to create
function _create_directory_if_not_exists() {
  DIR_NAME=$1
  ## Create Directory If Not Exists
  if [ ! -d "$DIR_NAME" ]; then
    mkdir -p "$DIR_NAME"
  fi
}

# Displays Time in misn and seconds
function _display_time {
  local T=$1
  local D=$((T / 60 / 60 / 24))
  local H=$((T / 60 / 60 % 24))
  local M=$((T / 60 % 60))
  local S=$((T % 60))
  ((D > 0)) && printf '%d days ' $D
  ((H > 0)) && printf '%d hours ' $H
  ((M > 0)) && printf '%d minutes ' $M
  ((D > 0 || H > 0 || M > 0)) && printf 'and '
  printf '%d seconds\n' $S
}

# Returns true (0) if the given file exists contains the given text and false (1) otherwise. The given text is a
# regular expression.
function _file_contains_text {
  local -r text="$1"
  local -r file="$2"
  grep -q "$text" "$file"
}

# Replace a line of text that matches the given regular expression in a file with the given replacement.
# Only works for single-line replacements.
function _file_replace_text {
  local -r original_text_regex="$1"
  local -r replacement_text="$2"
  local -r file="$3"

  local args=()
  args+=("-i")

  if _is_os_darwin; then
    # OS X requires an extra argument for the -i flag (which we set to empty string) which Linux does no:
    # https://stackoverflow.com/a/2321958/483528
    args+=("")
  fi

  args+=("s|$original_text_regex|$replacement_text|")
  args+=("$file")

  sed "${args[@]}" >/dev/null
}

# Returns true (0) if this is an OS X server or false (1) otherwise.
function _is_os_darwin {
  [[ $(uname -s) == "Darwin" ]]
}

# Returns true (0) if this the given command/app is installed and on the PATH or false (1) otherwise.
function _is_command_found {
  local -r name="$1"
  command -v "$name" >/dev/null ||
    raise_error "${RED}$name is not installed. Exiting...${NC}"
}

# Wrapper function for echo
function prompt() {
  echo -e "${1}" >&2
}

# Example colour function
function all_colors() {
  prompt "$BOLD $UNDERLINE Colour Formatting Example $NC"
  prompt "$RED R $NC $GREEN A  $NC $BLUE J $NC $RED A. $BLUE $NC S"
}

# ls, with chmod-like permissions and more.
# @param $1 The directory to ls
function lls() {
  #If Not Paramter is Passed assumes current directory
  local LLS_PATH=${1:-"."}
  prompt "${GREEN} ls with chmod-like permissions ${NC}"
  # shellcheck disable=SC2012 # Reason: This is for human consumption
  ls -AHl "$LLS_PATH" | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/) \
                            *2^(8-i));if(k)printf(\"%0o \",k);print}"
}

# Run Pre Commit and Git Add on Changed Files
function run_pre_commit() {
  pre-commit run --all-files
  git diff --staged --name-only --diff-filter=ARM | xargs git add
  exit 0
}

# Wrapper To Aid TDD
function _run_main() {
  _create_directory_if_not_exists "$@"
  _is_command_found "$@"
  _display_time "$@"
  _file_exists "$@"
  _file_contains_text "$@"
  _file_replace_text "$@"
  _is_os_darwin "$@"
  prompt "$@"
  all_colors "$@"
  lls "$@"
  run_pre_commit "$@"
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if ! _run_main "$@"; then
    exit 1
  fi
fi
