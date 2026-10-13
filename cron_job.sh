#!/bin/bash

# Get full directory path dynamically
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_SCRIPT="$SCRIPT_DIR/cron_job.sh"

# Check if the job already exists to prevent duplicate entries
(crontab -l 2>/dev/null | grep -v "$CRON_SCRIPT"; echo "* * * * * $CRON_SCRIPT") | crontab -
