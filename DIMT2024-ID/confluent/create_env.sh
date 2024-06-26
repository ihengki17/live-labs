#!/bin/bash

current_dir=$(pwd)
parent_dir=$(dirname "$current_dir")

accounts_file="${parent_dir}/.accounts"
env_file="${parent_dir}/.env"

# Check if .accounts file exists
if [ ! -f "$accounts_file" ]; then
    echo "$accounts_file not found."
    exit 1
fi

# Define the environment variable content
env_content=$(cat <<EOF
CCLOUD_API_KEY=api-key
CCLOUD_API_SECRET=api-secret
CCLOUD_BOOTSTRAP_ENDPOINT=kafka-cluster-endpoint

SR_URL=schema-registry-url
SR_AUTH_BASIC_USER_INFO=USER_INFO
SR_USER_INFO=sr-info

EOF
)

# Combine the environment variable content with .accounts and write to .env
echo "$env_content" | cat - "$accounts_file" > "$env_file"

echo "Created an environment file named: $env_file"
