#!/bin/bash

# This script deploys a Mule application to Anypoint Platform.
# It checks if the application already exists and either updates it or deploys a new one.

# Exit immediately if a command exits with a non-zero status.
set -e


# --- Assigning Arguments to Variables ---
APP_NAME=$1
DEPLOYMENT_TARGET=$2
RUNTIME_VERSION=$3
ASSET_VERSION=$4
BUS_GROUP_ID=$5
REPLICA_SIZE=$6

# Validate that jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it using 'brew install jq' on your Mac."
    exit 1
fi

echo "---"
echo "Configuring Anypoint CLI..."
echo "---"

echo "---"
echo "Checking for existing application: '$APP_NAME'"
echo "---"

# Note: The logic has been corrected to handle the jq filter properly.
# The list command's output needs to be piped to jq.
APP_ID=$(anypoint-cli-v4 runtime-mgr:application:list --output json | jq '.[] | select(.name == "'"$APP_NAME"'") | .id' | tr -d '"')

if [[ -n "$APP_ID" ]]; then
    echo "Application '$APP_NAME' already exists. AppId: $APP_ID. Updating..."
    # Corrected the modify command to use the captured APP_ID and simplified variable names
    anypoint-cli-v4 runtime-mgr:application:modify "$APP_ID" --artifactId "$APP_NAME" --assetVersion "$ASSET_VERSION" --groupId "$BUS_GROUP_ID" --replicaSize "$REPLICA_SIZE"
else
    echo "Application '$APP_NAME' not found. Deploying a new application..."
    echo "anypoint-cli-v4 runtime-mgr:application:deploy '$APP_NAME' '$DEPLOYMENT_TARGET' '$RUNTIME_VERSION' '$APP_NAME' --assetVersion '$ASSET_VERSION' --groupId '$BUS_GROUP_ID' --replicaSize '$REPLICA_SIZE'"
    anypoint-cli-v4 runtime-mgr:application:deploy "$APP_NAME" "$DEPLOYMENT_TARGET" "$RUNTIME_VERSION" "$APP_NAME" --assetVersion "$ASSET_VERSION" --groupId "$BUS_GROUP_ID" --replicaSize "$REPLICA_SIZE"
fi

echo "---"
echo "Deployment process finished."
echo "---"