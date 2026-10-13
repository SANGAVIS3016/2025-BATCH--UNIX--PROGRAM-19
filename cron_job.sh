#!/bin/bash

set -e

# Get the absolute path of this script dynamically
SCRIPT_PATH="$(realpath "$0")"

# Define the expected cron job
CRON_ENTRY="* * * * * $SCRIPT_PATH"

# Read existing cron jobs safely
EXISTING_CRON="$(crontab -l 2>/dev/null || true)"

# Add the cron entry only if it does not already exist
if ! printf '%s\n' "$EXISTING_CRON" | grep -Fqx "$CRON_ENTRY"; then
    printf '%s\n' "$EXISTING_CRON" "$CRON_ENTRY" | crontab -
fi

echo "Cron job configured successfully."
