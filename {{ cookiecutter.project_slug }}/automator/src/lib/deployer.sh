#!/usr/bin/env bash

APP_NAME=$(basename "$(git rev-parse --show-toplevel)")
WEB_AUTH_FILE="automator/config/devhuborg.env.json"

# welcome_prompt : Welcome prompt
function welcome_prompt(){
    prompt ""
    HEADING="${GREEN}Automation to setup org : ${UNDERLINE}$ORG_ALIAS${NC}"
    prompt "$HEADING ${GREEN}Through cci for app : ${UNDERLINE}$APP_NAME${NC}"
    prompt ""
}

# tear_down : Delete, Remove & Prune specified Org
function tear_down() {
    is_org_alias_set
    prompt "Cleaning scratch org..."
    rm -fr ~/.cumulusci && \
    cci org default --unset && \
    cci org scratch_delete "$ORG_ALIAS" && \
    cci org remove "$ORG_ALIAS" && \
    cci org prune && \

    scratch_orgs_count="$(sfdx force:org:list --json | jq -r '.scratchOrgs' | jq length)" && \
    [ "$scratch_orgs_count" != 0 ] \
        && prompt "Tear Down Failed... Scratch Org Count != 0" \
        && return 1
    return 0
}

# force_logout_from_dev_hub_orgs : Logout from all Dev Hub Orgs to ensure predtictability
#                                  when deploying to full code base
function force_logout_from_dev_hub_orgs(){
    # Force Logout from Dev Hub ORGs
    prompt "DevHub org Auth List"
    sfdx auth:list
    prompt "Forcefull Logout of All Dev Hub Orgs"
    for user in $(sfdx auth:list --json | jq -r '.result[].username' ); do
        sfdx auth:logout -u "$user" -p
    done
}

function generate_cci_key(){
    local CUMULUSCI_KEY_FILE="automator/config/cci.env.key"
    if [ ! -f "$CUMULUSCI_KEY_FILE" ]; then
        prompt "${BLUE}Generating Cumulus CI Key${NC}"
        # shellcheck disable=SC2001
        CUMULUSCI_KEY="$(sed "s/[^a-zA-Z0-9]//g" <<< "$(openssl rand -base64 20)" | cut -c1-16)"
        echo "CUMULUSCI_KEY=$CUMULUSCI_KEY" > $CUMULUSCI_KEY_FILE
    fi
    export "$(grep -E -v '^#' automator/config/cci.env.key | xargs)"
    env | grep CUMULUSCI_KEY
}

# web_auth : Authorize Dev Hub Org
function _web_auth(){
    is_org_alias_set
    if [ "$(sfdx auth:list --json | jq -r '.result'  | jq length)"  != 0 ]; then
        force_logout_from_dev_hub_orgs
    fi
    prompt "Authorize Dev hub org and provide it with an alias"
    # --setalias : set an alias for the authenticated org
    # --setdefaultdevhubusername :
    #                set the authenticated org as the default dev hub org for scratch org creation
    sfdx auth:web:login --setalias "$APP_NAME-org-$ORG_ALIAS" --setdefaultdevhubusername
    username=$(sfdx auth:list --json | jq -r '.result[].username')
    _store_web_auth_json "$username"
}

# store_web_auth_json : Store Web Auth in json format for cli based auth later
function _store_web_auth_json(){
    username=$1
    prompt "Store Web Auth to $WEB_AUTH_FILE"
    sfdx force:org:display -u "$username" --verbose --json > "$WEB_AUTH_FILE"
}

# auth_from_file : Authorize an org using an SFDX auth URL stored within a file
function _auth_from_file(){
    is_org_alias_set
    prompt "Authenticating From File: $WEB_AUTH_FILE"
    sfdx auth:sfdxurl:store \
        -f $WEB_AUTH_FILE \
        --setalias "$APP_NAME-org-$ORG_ALIAS" \
        --setdefaultdevhubusername
}

# auth : Authorize an org - Wrapper command
function auth_to_dev_hub_org(){
    is_org_alias_set
    force_logout_from_dev_hub_orgs
    if [ -f "$WEB_AUTH_FILE" ]; then
        _auth_from_file || \
            ( prompt "Authentication From File Failed... Switching to Web Auth" && _web_auth)
    else
        _web_auth
    fi
}

# prepare_to_deploy : Teardown and Authorise Dev Hub Org
function prepare_to_deploy(){
    is_org_alias_set        || raise_error "deployer.sh -> prepare_to_deploy -> is_org_alias_set ❌"
    welcome_prompt          || raise_error "deployer.sh -> prepare_to_deploy -> welcome_prompt ❌"
    generate_cci_key        || raise_error "deployer.sh -> prepare_to_deploy -> generate_cci_key ❌"
    tear_down               || raise_error "deployer.sh -> prepare_to_deploy -> tear_down ❌"
    auth_to_dev_hub_org     || raise_error "deployer.sh -> prepare_to_deploy -> auth_to_dev_hub_org ❌"
}

# full_deploy : Full Deployment to the specified org
function full_deploy(){
    is_org_alias_set
    prompt "Deploy code to scratch org..."
    cci flow run dev_org --org "$ORG_ALIAS" || raise_error "deployer.sh -> full_deploy ❌"
}

# assign_permission_set : Assign specified permission set(s) to the default user
function assign_permission_sets(){
    api_names=$1
    is_org_alias_set
    prompt "Assigning permission sets...using cci "
    cci task run assign_permission_sets \
        --api_names "$api_names" \
        --org "$ORG_ALIAS"
}

# auto_configure_org : Automatic Configuration of teh specified Org
#                      JWT Bearer Auth Flow for connected app
function auto_configure_org(){
    is_org_alias_set
    prompt "Configuring JWT Bearer Auth Flow for Connected App"
    cci task run robot \
        -o suites robot/setup/jwt_bearer_auth_flow.robot  \
        --org "$ORG_ALIAS"
}

# set_org_name : Set name for the Org
function set_org_alias_from_cli() {
  read -rp "${BLUE}ORG Name: ${NC}" ORG_ALIAS
  export ORG_ALIAS
}

# set_org_name : Set name for the Org
function set_org_alias() {
  ORG_ALIAS=$1
  export ORG_ALIAS
}

# set defaulty org
function set_default_org(){
    is_org_alias_set
    cci org default "$ORG_ALIAS"
}

# get_org_name : Get name for the Org
function get_org_alias() {
    prompt "ORG_ALIAS :: $ORG_ALIAS"
}

# open defaut org in browser
function open_org_in_browser(){
    prompt "Opening org : $ORG_ALIAS in Browser" && \
    cci org browser
}

# Wrapper To Aid TDD
function _run_main() {
    welcome_prompt "$@"
    tear_down "$@"
    force_logout_from_dev_hub_orgs "$@"
    generate_cci_key "$@"
    web_auth "$@"
    store_web_auth_json "$@"
    auth_from_file "$@"
    auth_to_dev_hub_org "$@"
    full_deploy "$@"
    assign_permission_sets "$@"
    auto_configure_org "$@"
    set_org_alias_from_cli "$@"
    get_org_alias "$@"
    set_default_org "$@"
    open_org_in_browser "$@"
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! _run_main "$@"
  then
    exit 1
  fi
fi
