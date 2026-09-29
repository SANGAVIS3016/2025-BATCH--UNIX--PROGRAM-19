#!/bin/bash

OUTPUT_FILE="/tmp/cron_assignment_output.txt"

echo "Cron job executed at: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
