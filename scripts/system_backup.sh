#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$PROJECT_ROOT/logs/system_backup.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR" "$PROJECT_ROOT/logs"

echo "----- Backup Started: $(date) -----" >> "$LOG_FILE"

tar -czf "$BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz" /home/$USER 2>> "$LOG_FILE"

echo "Backup stored at: $BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz" >> "$LOG_FILE"
echo "Backup completed successfully." >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

