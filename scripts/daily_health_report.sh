 #!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/reports/system_health_report_$(date +'%Y-%m-%d').txt"

mkdir -p "$PROJECT_ROOT/reports"

echo "========================================" >> "$REPORT_FILE"
echo " SYSTEM HEALTH REPORT - $(date)" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[ Disk Usage ]" >> "$REPORT_FILE"
df -h / | awk 'NR==2 {print "Usage:", $5, "| Size:", $2, "| Used:", $3, "| Free:", $4}' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[ Top Processes (by memory) ]" >> "$REPORT_FILE"
ps -eo pid,comm,%mem --sort=-%mem | head -5 >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[ Last 5 System Logs ]" >> "$REPORT_FILE"
tail -5 /var/log/syslog >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[ Backup Directory Status ]" >> "$REPORT_FILE"
ls -lh "$PROJECT_ROOT/backups" | tail -5 >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[ Recent Alerts (if any) ]" >> "$REPORT_FILE"
[ -f "$PROJECT_ROOT/reports/log_alerts_report.txt" ] && tail -5 "$PROJECT_ROOT/reports/log_alerts_report.txt" >> "$REPORT_FILE"
[ -f "$PROJECT_ROOT/reports/disk_alerts_report.txt" ] && tail -5 "$PROJECT_ROOT/reports/disk_alerts_report.txt" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Report generated successfully."

