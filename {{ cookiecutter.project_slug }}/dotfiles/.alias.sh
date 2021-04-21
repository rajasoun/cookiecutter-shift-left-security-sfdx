#!/usr/bin/env sh

ghelp() {
	echo "
- - - - - - - - - - - - - -
Git Convenience Shortcuts:
- - - - - - - - - - - - - -
ghelp 		- List all Git Convenience commands and prompt symbols
gsetup		- Install Git Flow & pre-commit hooks
gaa   		- Add all changes (including untracted files) to staging
cz c  		- Git Commit
gba   		- List of local and remote branches
code_churn	- Frequency of change to code base

- - - - - - - - - - - - - -
"
}

_init_git() {
	echo "Not Git Repository"
	echo "Intializing Git & Git Flow"
	git init
	git flow init
}

_install_git_hooks() {
	echo "Git Repository..."
	echo "Installing Git Hooks"
	pre-commit install --hook-type  commit-msg
	pre-commit install-hooks
}

gsetup() {
	if [ "$(git rev-parse --is-inside-work-tree)" = true ]; then
		_install_git_hooks
	else
		_init_git
		_install_git_hooks
	fi
}

# Gits Churn -  "frequency of change to code base"
#
# $ ./git-churn.bash
# 30 src/multipass/actions.bash
# 38 test/test_integration.bats
# 97 .github/workflows/pipeline.yml
#
# This means that
# actions.bash has changed 30 times.
# pipeline.yml has changed 97 times.
#
# Show churn for specific directories:
#   $ $ ./git-churn.bash src
#
# Show churn for a time range:
#   $ $ ./git-churn.bash --since='1 month ago'
#
# All standard arguments to git log are applicable
code_churn() {
	git log --all -M -C --name-only --format='format:' "$@" | sort | grep -v '^$' | uniq -c | sort -n
}
