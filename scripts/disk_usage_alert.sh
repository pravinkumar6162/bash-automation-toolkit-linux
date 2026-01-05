#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/disk_usage.log"
REPORT_FILE="$PROJECT_ROOT/reports/disk_alerts_report.txt"

THRESHOLD=80   # alert when disk usage exceeds %

mkdir -p "$PROJECT_ROOT/logs" "$PROJECT_ROOT/reports"

echo "----- Disk Check: $(date) -----" >> "$LOG_FILE"

# Get disk usage (root filesystem only)
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
MOUNT=$(df -h / | awk 'NR==2 {print $6}')

if [ "$USAGE" -ge "$THRESHOLD" ]; then

    echo "Disk usage above threshold: $USAGE% on $MOUNT" >> "$LOG_FILE"

    echo "" >> "$REPORT_FILE"
    echo "⚠️ Disk Alert on $(date)" >> "$REPORT_FILE"
    echo "Usage: $USAGE% on mount $MOUNT" >> "$REPORT_FILE"
    echo "-----------------------------------" >> "$REPORT_FILE"

else
    echo "Disk usage normal: $USAGE% on $MOUNT" >> "$LOG_FILE"
fi
