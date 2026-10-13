#!/bin/bash

# Check crontab package status
if command -v crontab >/dev/null 2>&1; then
    echo "Crontab is installed."
else
    echo "Crontab is not installed."
    exit 1
fi

# Generate the current user's cron entry
SCRIPT_PATH="$(realpath "$0")"
CRON_ENTRY="30 12 * * * /bin/echo hello"

# Read existing cron jobs
EXISTING_CRON="$(crontab -l 2>/dev/null || true)"

# Add the job only if it does not already exist
if ! printf '%s\n' "$EXISTING_CRON" | grep -Fqx "$CRON_ENTRY"; then
    printf '%s\n' "$EXISTING_CRON" "$CRON_ENTRY" | crontab -
    echo "Cron job added successfully."
else
    echo "Cron job already exists."
fi

# Display current user's cron jobs
crontab -l
