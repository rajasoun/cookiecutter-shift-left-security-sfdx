#!/usr/bin/env sh

export "$(cat .env | xargs)"
curl -H "Authorization: Token ${GITGUARDIAN_API_KEY}" "${GITGUARDIAN_API_URL}/v1/health"
