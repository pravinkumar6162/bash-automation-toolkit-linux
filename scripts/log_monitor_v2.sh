#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/log_monitor.log"
REPORT_FILE="$PROJECT_ROOT/reports/log_alerts_report.txt"
STATE_FILE="$PROJECT_ROOT/logs/last_log_position.state"
SYSLOG="/var/log/syslog"

mkdir -p "$PROJECT_ROOT/logs" "$PROJECT_ROOT/reports"

echo "----- Log Monitor Run: $(date) -----" >> "$LOG_FILE"

# If first run, start reading from end of file
if [ ! -f "$STATE_FILE" ]; then
    echo "Initializing log monitor state file" >> "$LOG_FILE"
    wc -l < "$SYSLOG" > "$STATE_FILE"
    echo "First run - no alerts checked" >> "$LOG_FILE"
    exit 0
fi

# Read last processed line number
LAST_POS=$(cat "$STATE_FILE")
CURRENT_POS=$(wc -l < "$SYSLOG")

# Update state for next run
echo "$CURRENT_POS" > "$STATE_FILE"

# Extract new log entries only
NEW_LOGS=$(sed -n "$LAST_POS,$CURRENT_POS p" "$SYSLOG" | grep -iE "error|failed|warning")

if [ -z "$NEW_LOGS" ]; then
    echo "No new issues detected." >> "$LOG_FILE"
    exit 0
fi

echo "" >> "$REPORT_FILE"
echo "🚨 Log Alerts Detected on $(date)" >> "$REPORT_FILE"
echo "--------------------------------------" >> "$REPORT_FILE"
echo "$NEW_LOGS" >> "$REPORT_FILE"

echo "Alerts recorded in report file." >> "$LOG_FILE"
