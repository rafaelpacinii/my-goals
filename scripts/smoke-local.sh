#!/usr/bin/env bash
set -euo pipefail

web_url="http://localhost:${WEB_PORT:-3000}"
api_url="http://localhost:${API_PORT:-8080}"
keycloak_url="http://localhost:${KEYCLOAK_PORT:-8180}/realms/goals"
storage_url="http://localhost:${S3_PORT:-8333}/${S3_BUCKET:-goals-log-attachments}"

curl --max-time 15 -fsS "$web_url/api/health" | grep -E '"status"[[:space:]]*:[[:space:]]*"UP"' >/dev/null
curl --max-time 15 -fsS "$web_url/" | grep -F 'API disponível' >/dev/null
curl --max-time 15 -fsS "$api_url/q/health/ready" | grep -E '"status"[[:space:]]*:[[:space:]]*"UP"' >/dev/null
curl --max-time 15 -fsS "$api_url/q/openapi" | grep -F 'openapi: 3.0.4' >/dev/null
curl --max-time 15 -fsS "$keycloak_url/.well-known/openid-configuration" |
  python3 -c 'import json, sys; sys.exit(json.load(sys.stdin)["issuer"] != sys.argv[1])' "$keycloak_url"

curl --max-time 15 --retry 15 --retry-all-errors --retry-max-time 60 --retry-delay 2 -fsSI \
  --aws-sigv4 'aws:amz:us-east-1:s3' \
  --user "${S3_ACCESS_KEY:-goals-local}:${S3_SECRET_KEY:-goals-local-storage}" \
  "$storage_url" >/dev/null
anonymous_status=$(curl --max-time 15 -sSI -o /dev/null -w '%{http_code}' "$storage_url")
if [[ "$anonymous_status" != 403 ]]; then
  printf 'O S3 respondeu HTTP %s ao acesso anônimo. Esperado: 403.\n' "$anonymous_status" >&2
  exit 1
fi

printf '%s\n' 'Web, API, realm OIDC e bucket S3 responderam.'
