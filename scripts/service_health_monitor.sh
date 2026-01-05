#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/service_monitor.log"
REPORT_FILE="$PROJECT_ROOT/reports/service_health_report.txt"

SERVICE_NAME="ssh"

mkdir -p "$PROJECT_ROOT/logs" "$PROJECT_ROOT/reports"

echo "----- Service Check: $(date) -----" >> "$LOG_FILE"

STATUS=$(systemctl is-active $SERVICE_NAME)

if [ "$STATUS" != "active" ]; then

    echo "Service '$SERVICE_NAME' is DOWN. Attempting restart..." >> "$LOG_FILE"
    systemctl restart $SERVICE_NAME

    NEW_STATUS=$(systemctl is-active $SERVICE_NAME)

    echo "" >> "$REPORT_FILE"
    echo "⚠️ Service Failure Detected on $(date)" >> "$REPORT_FILE"
    echo "Service: $SERVICE_NAME" >> "$REPORT_FILE"
    echo "Previous State: $STATUS" >> "$REPORT_FILE"
    echo "Restart Result: $NEW_STATUS" >> "$REPORT_FILE"
    echo "-------------------------------------" >> "$REPORT_FILE"

else
    echo "Service '$SERVICE_NAME' is running normally." >> "$LOG_FILE"
fi
