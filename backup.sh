#!/bin/bash
: '
=========================================================================
Automated Backup Script
Author: Ajima Fabian
Email: your-email@example.com
GitHub: https://github.com/yourusername

Description:
Automates backups of specified directories with timestamps and logs.
Supports scheduling with cron for fully automated backups.

License: MIT License
=========================================================================
'

echo "===== Automated Backup Script ====="
echo "Date: $(date)"
echo ""

# Directories to backup (edit this array)
SOURCE_DIRS=("$HOME/Documents" "$HOME/Pictures")  # Add any directories you want
BACKUP_DEST="$HOME/backups"                       # Destination directory
LOG_FILE="$HOME/backup.log"

# Create backup destination if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Backup process
for DIR in "${SOURCE_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        BASENAME=$(basename "$DIR")
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        DEST="$BACKUP_DEST/${BASENAME}_backup_$TIMESTAMP.tar.gz"
        tar -czf "$DEST" "$DIR"
        if [ $? -eq 0 ]; then
            echo "✅ Backup successful: $DEST" | tee -a "$LOG_FILE"
        else
            echo "❌ Backup failed for $DIR" | tee -a "$LOG_FILE"
        fi
    else
        echo "⚠️  Source directory does not exist: $DIR" | tee -a "$LOG_FILE"
    fi
done

echo ""
echo "Backup process complete. Logs saved to $LOG_FILE"
echo "===== Backup Complete ====="
