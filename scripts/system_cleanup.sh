#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/system_cleanup.log"

mkdir -p "$PROJECT_ROOT/logs"

echo "----- System Cleanup Started: $(date) -----" >> "$LOG_FILE"

sudo apt-get clean
sudo journalctl --vacuum-time=7d
rm -rf ~/.cache/thumbnails/*
find /tmp -type f -atime +7 -delete

echo "Cleanup completed successfully." >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"
