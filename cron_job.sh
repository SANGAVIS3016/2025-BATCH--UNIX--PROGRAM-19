#!/bin/bash

# 1. Dynamically get the absolute directory path where this script/repo lives
DIR="$(cd "$(dirname "$0")" && pwd)"

# 2. Construct the absolute path to cron_job.sh dynamically
CRON_JOB_PATH="$DIR/cron_job.sh"

# 3. Create the cron job string using the required schedule (* * * * *)
CRON_ENTRY="* * * * * $CRON_JOB_PATH"

# 4. Check for duplicates and add to crontab safely
(crontab -l 2>/dev/null | grep -v "$CRON_JOB_PATH"; echo "$CRON_ENTRY") | crontab -
