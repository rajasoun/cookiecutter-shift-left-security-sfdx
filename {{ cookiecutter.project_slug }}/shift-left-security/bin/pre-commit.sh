#!/usr/bin/env sh

export "$(cat .env | xargs)"

command_exists () {
  command -v "$1" >/dev/null 2>&1
}

# check if python3 exists locally
if command_exists pre-commit && test -t 1; then
    pre-commit run --all-files
    git diff --staged --name-only --diff-filter=ARM | xargs git add
    exit 0
fi

echo "ERROR: pre-commit missing. Pls Install, refer README.md"
exit 1
