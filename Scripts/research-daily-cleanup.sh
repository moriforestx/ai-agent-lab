#!/usr/bin/env bash
set -euo pipefail

# research-daily-cleanup.sh
# Cleanup staging directories older than 7 days
# Run via cron daily or manually

ROOT="/home/local/AI-Agent-Lab"
STAGE_BASE="$ROOT/.openclaw-stage"

if [ ! -d "$STAGE_BASE" ]; then
  echo "No staging base directory: $STAGE_BASE"
  exit 0
fi

# Date threshold: 7 days ago
THRESHOLD_DATE=$(date -d '-7 days' +%F)

# Find and remove staging dirs older than 7 days
# Pattern: research-daily-YYYY-MM-DD and research-daily-YYYY-MM-DD-retry-*
found=0
while IFS= read -r -d '' dir; do
  basename_dir="$(basename "$dir")"
  if [[ "$basename_dir" =~ research-daily-([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    dir_date="${BASH_REMATCH[1]}"
    if [[ "$dir_date" < "$THRESHOLD_DATE" ]]; then
      echo "Removing old staging: $dir (date: $dir_date)"
      rm -rf "$dir"
      found=1
    fi
  fi
done < <(find "$STAGE_BASE" -maxdepth 1 -type d -name 'research-daily-*' -print0)

if [ $found -eq 0 ]; then
  echo "No staging directories older than 7 days to clean up."
else
  echo "Cleanup complete."
fi
