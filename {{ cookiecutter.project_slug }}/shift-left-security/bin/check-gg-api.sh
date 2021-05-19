#!/usr/bin/env sh

#shellcheck disable=SC2046
export $(grep -E -v '^#' .env | xargs)
curl -H "Authorization: Token ${GITGUARDIAN_API_KEY}" "${GITGUARDIAN_API_URL}/v1/health"
