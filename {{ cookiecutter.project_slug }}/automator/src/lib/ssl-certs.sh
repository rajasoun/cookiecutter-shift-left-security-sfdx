#!/usr/bin/env bash

# generate_ssl_certificate : Generate SSL Certificate
#                            using openssl and jq
function generate_ssl_certificate_and_key(){
    clean_ssl_certificate_and_key

    # certificate generation configuration file
    source="automator/config/certs.json"
    # configuration variables
    domain=$(jq '.domain' $source | tr -d '"')
    country=$(jq '.certDetails.country' $source | tr -d '"')
    state=$(jq '.certDetails.state' $source | tr -d '"')
    locality=$(jq '.certDetails.locality' $source | tr -d '"')
    organization=$(jq '.certDetails.organization' $source | tr -d '"')
    organizationalunit=$(jq '.certDetails.organizationalunit' $source | tr -d '"')
    email=$(jq '.certDetails.email' $source | tr -d '"')
    keysize=$(jq '.certDetails.keysize' $source | tr -d '"')
    password=$(openssl rand -base64 32)
    prompt "SSL Certificate Password :: $password" > "certs/$domain.password"

    prompt "Generating SSL keys for Domain -> $domain"

    # Generate a key
    openssl genpkey \
        -aes-256-cbc \
        -algorithm RSA \
        -pass pass:"$password" \
        -out "automator/certs/$domain.key" \
        -pkeyopt rsa_keygen_bits:"$keysize"

    # Create crt file
    # IG (ignore) value is purposefully introduced to avoid ignoring the field values in other Operating Systems
    subject="//IG=IGNORE/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$domain/emailAddress=$email"
    openssl req -newkey rsa:"$keysize" \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out "automator/certs/$domain.crt" \
            -keyout "automator/certs/$domain.key" \
            -passin pass:"$password" \
            -subj "$subject"

    prompt "-------------------------------------------------------"
    prompt "--Below is your CRT (available at certs Directory)-"
    prompt "-------------------------------------------------------"
    prompt
    cat "automator/certs/$domain.crt"
}

# clean_ssl_certificate :   Remove SSL Certificate
function clean_ssl_certificate_and_key(){
    prompt "Cleaning certs and keys..."
    rm -fr $SCRIPT_DIR/certs/*.crt $SCRIPT_DIR/certs/*.key $SCRIPT_DIR/certs/*.pass* $SCRIPT_DIR/config/jwt.key.env
}

function _run_main() {
    generate_ssl_certificate_and_key "$@"
    clean_ssl_certificate_and_key "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! _run_main "$@"
  then
    exit 1
  fi
fi
