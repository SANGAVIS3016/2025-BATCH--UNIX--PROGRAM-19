#!/bin/bash

# Define the exact cron job line required for your assignment
CRON_JOB="0 * * * * /path/to/cron_job.sh"

# Ensure exactly one entry exists by filtering out any existing instance and re-adding it
(crontab -l 2>/dev/null | grep -v -F "$CRON_JOB"; echo "$CRON_JOB") | crontab -
