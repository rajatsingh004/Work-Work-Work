#!/usr/bin/env bash
set -euo pipefail

: "${CHECKMARX_TOKEN:?Provide the scanner token through the CI secret store}"
: "${CHECKMARX_PROJECT_NAME:=demo-service}"
: "${CHECKMARX_BASE_URL:=https://checkmarx.example.com}"

# Keep scanner installation/version managed by the CI agent image or pinned tool installer.
# The wrapper is intentionally the integration point because CLI flags vary by Checkmarx release.
if ! command -v cx >/dev/null 2>&1; then
  echo "Checkmarx CLI 'cx' is not installed on this agent" >&2
  exit 127
fi

cx scan create --project-name "$CHECKMARX_PROJECT_NAME" \
  --base-uri "$CHECKMARX_BASE_URL" \
  --source-dir . \
  --apikey "$CHECKMARX_TOKEN" \
  --threshold "sast-high=0; sast-medium=0"
