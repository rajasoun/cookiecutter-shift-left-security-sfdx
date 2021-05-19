#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/src/load.sh"

FILE="automatorconfig/jwt.key.env"
# shellcheck source=/dev/null
source "$FILE"

# Set parameters
# Defaults to dev org
org_env=${1:-dev}
ORG_ALIAS=${1:-dev}
ORG_ALIAS="$(jq '.orgName' "orgs/$org_env.json" | tr -d '"')"

# Force Logout from Dev Hub ORGs
# force_logout_from_dev_hub_orgs && \

# Login via JWT Bearer Flow
echo "SFDX Login via JWT " && \

# Ref: https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm
echo "" && \
echo "Generating SSL Certificates" && \
generate_ssl_certificate_and_key && \
echo "" && \

# ToDo: Technical Debt : Manual Intervention Required for Popup - Priority #1
# ToDo: Technical Debt : Change sfdx to cci if possible - Priority #3
# Auto Configure Org for JWT Bearer Auth Flow
auto_configure_org "$ORG_ALIAS" && \

if test -f "$FILE"; then
    echo "$FILE exists"
    echo "Connecting to $ORG_ALIAS"
    sfdx auth:jwt:grant \
      --clientid "$CLIENT_ID" \
      --jwtkeyfile "$CERTS_KEY_PATH" \
      --username "$USER_NAME" \
      --instanceurl "$INSTANCE_URL" \
      --setdefaultdevhubusername \
      --setalias "$ORG_ALIAS-jwt"
fi
echo ""
