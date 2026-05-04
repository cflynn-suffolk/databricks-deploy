#!/usr/bin/env bash
set -euo pipefail

if [ -z "${DATABRICKS_REPO_BRANCH:-}" ]; then
  echo "::error::Missing required input: databricks-repo-branch"
  exit 1
fi

if [ -z "${DATABRICKS_TOKEN:-}" ]; then
  echo "::error::Missing required input: databricks-token"
  exit 1
fi

if [ -z "${DATABRICKS_HOST:-}" ]; then
  echo "::error::Missing required input: databricks-host"
  exit 1
fi

if [ -z "${DATABRICKS_REPO_ID:-}" ]; then
  echo "::error::Missing required input: databricks-repo-id"
  exit 1
fi

DATABRICKS_HOST="${DATABRICKS_HOST%/}"
URL="${DATABRICKS_HOST}/api/2.0/repos/${DATABRICKS_REPO_ID}"

echo "Deploying Databricks repo ${DATABRICKS_REPO_ID} to branch '${DATABRICKS_REPO_BRANCH}'"

HTTP_RESPONSE="$(curl --silent --show-error --write-out "\n%{http_code}" \
  --request PATCH "$URL" \
  --header "Authorization: Bearer ${DATABRICKS_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{\"branch\":\"${DATABRICKS_REPO_BRANCH}\"}")"

HTTP_BODY="$(printf '%s' "$HTTP_RESPONSE" | sed '$d')"
HTTP_STATUS="$(printf '%s' "$HTTP_RESPONSE" | tail -n 1)"

if [ "$HTTP_STATUS" -lt 200 ] || [ "$HTTP_STATUS" -ge 300 ]; then
  echo "::error::Databricks deploy failed with HTTP status ${HTTP_STATUS}"
  echo "$HTTP_BODY"
  exit 1
fi

echo "Databricks deploy succeeded."
echo "$HTTP_BODY"
