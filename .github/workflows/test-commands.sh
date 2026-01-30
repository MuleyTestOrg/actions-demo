#!/usr/bin/env bash

set -euo pipefail

# ----------------------------
# Input variables
# ----------------------------
ORG_ID="9d4e58fd-82a8-4f2c-b29b-7f6b41ec392f"
ENV_NAME="PreProd"

ANYPOINT_PLATFORM_CLIENT_ID_MAP='{
  "9d4e58fd-82a8-4f2c-b29b-7f6b41ec392f_DEV": {
    "client_id": "DevTestId123",
    "client_secret": "DevTestSecret123"
  },
  "9d4e58fd-82a8-4f2c-b29b-7f6b41ec392f_IT": {
    "client_id": "ITTestId123",
    "client_secret": "ITTestSecret123"
  },
  "9d4e58fd-82a8-4f2c-b29b-7f6b41ec392f_UAT": {
    "client_id": "UATTestId123",
    "client_secret": "UATTestSecret123"
  },
  "9d4e58fd-82a8-4f2c-b29b-7f6b41ec392f_PROD": {
    "client_id": "PRODTestId123",
    "client_secret": "PRODTestSecret123"
  }
}'

# ----------------------------
# Build dynamic key
# ----------------------------
KEY="${ORG_ID}_${ENV_NAME}"

# ----------------------------
# Extract values using jq
# ----------------------------
ANYPOINT_PLATFORM_CLIENT_ID=$(echo "$ANYPOINT_PLATFORM_CLIENT_ID_MAP" \
  | jq -r --arg key "$KEY" '.[$key].client_id')

ANYPOINT_PLATFORM_CLIENT_SECRET=$(echo "$ANYPOINT_PLATFORM_CLIENT_ID_MAP" \
  | jq -r --arg key "$KEY" '.[$key].client_secret')

# ----------------------------
# Output results
# ----------------------------
echo "ORG_ID: $ORG_ID"
echo "ENV_NAME: $ENV_NAME"
echo "KEY: $KEY"
echo "CLIENT_ID: $ANYPOINT_PLATFORM_CLIENT_ID"
echo "CLIENT_SECRET: $ANYPOINT_PLATFORM_CLIENT_SECRET"