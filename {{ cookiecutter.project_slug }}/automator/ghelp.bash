#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/automator/src/lib/os.sh"

function ghelp() {
	echo "
- - - - - - - - - - - - - -
Git Convenience Shortcuts:
- - - - - - - - - - - - - -
ghelp 		- List all Git Convenience commands and prompt symbols
gsetup		- Install Git Flow & pre-commit hooks
code_churn	- Frequency of change to code base
alias		- List all Alias
- - - - - - - - - - - - - -
"
}

function _git_local_config(){
	git config --local user.name "$USER"
	git config --local user.email "$USER@cisco.com"
}

function _teardown_git_flow(){
	git config --remove-section "gitflow.path"
	git config --remove-section "gitflow.prefix"
	git config --remove-section "gitflow.branch"
}

function _init_git_flow() {
	if $(git flow config >/dev/null 2>&1)
	then
		prompt "Git Flow Already Initialized..."
	else
		prompt "Git Flow Not Initialized. Initializing..."
		git flow init -d
	fi
}

function _install_git_hooks() {
	prompt "Git Repository..."
	prompt "Installing Git Hooks"
	pre-commit uninstall
	git config --unset-all core.hooksPath
	pre-commit install --hook-type  commit-msg
	pre-commit install-hooks
	npm config set registry http://registry.npmjs.org/ --global
	npm install --prefix ./shift-left-security
}

function _check_gg_api(){
	prompt "Checking Git Guardian API Validity"
	source ".env"
	curl -H "Authorization: Token ${GITGUARDIAN_API_KEY}" "${GITGUARDIAN_API_URL}/v1/health"
}

function _populate_dot_env() {
	cp .env.sample .env
	prompt "${GREEN}To Get the GG Key Join with Cisco eMail : https://eurl.io/#L1zXw5q-Z ${NC}"
	prompt "${BOLD}Enter Git Guardian API Key: ${NC}"
	read -r GG_KEY
	_file_replace_text "__________FILL ME__________" "$GG_KEY" "$(git rev-parse --show-toplevel)/.env"
	_check_gg_api
}

function gsetup() {
	if [ "$(git rev-parse --is-inside-work-tree)" = true  ]; then
		if [[ $(git diff --stat) != '' ]]; then
			prompt "${RED} Git Working Tree Not Clean. Aborting setup !!! ${NC}"
		else
			start=$(date +%s)
			prompt "Git Working Tree Clean"
			_git_local_config
			_init_git_flow
			_install_git_hooks
			_populate_dot_env
			end=$(date +%s)
			runtime=$((end-start))
			prompt "==================================================="
			echo -e "gsetup DONE in  $(_display_time $runtime) ✅ "
			prompt "==================================================="
		fi
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
function code_churn() {
	git log --all -M -C --name-only --format='format:' "$@" | sort | grep -v '^$' | uniq -c | sort -n
}

#-------------------------------------------------------------
# Git Alias Commands
#-------------------------------------------------------------
alias gss="git status -s"
alias gaa="git add --all"
alias gc="git commit"
alias gclean="git fetch --prune origin && git gc"
