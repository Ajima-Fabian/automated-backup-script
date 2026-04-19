#!/bin/bash
: '
=========================================================================
Advanced Automated Backup Script (v2)
Author: Ajima Fabian
Email: ajimafabian18@gmail.com
GitHub: https://github.com/Ajima-Fabian

Features:
- Timestamped backups
- Logging system
- Error handling
- Old backup cleanup
- Disk usage check
- Safer quoting & fixes
- Cron-ready automation

License: MIT License
=========================================================================
'

echo "===== Advanced Automated Backup Script ====="
echo "Date: $(date +%Y-%m-%d_%H-%M-%S)"
echo ""

# =========================
# CONFIGURATION
# =========================
SOURCE_DIRS=("$HOME/Documents" "$HOME/Pictures")
BACKUP_DEST="$HOME/backups"
LOG_FILE="$HOME/backup.log"
RETENTION_DAYS=7

# =========================
# SETUP
# =========================
mkdir -p "$BACKUP_DEST"
touch "$LOG_FILE"

echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup started" >> "$LOG_FILE"

# =========================
# DISK SPACE CHECK
# =========================
echo "Checking available disk space..."
df -h "$BACKUP_DEST" | tee -a "$LOG_FILE"
echo ""

# =========================
# BACKUP PROCESS
# =========================
for DIR in "${SOURCE_DIRS[@]}"; do

    if [ -d "$DIR" ]; then

        BASENAME=$(basename "$DIR")
        TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

        DEST="$BACKUP_DEST/${BASENAME}_backup_$TIMESTAMP.tar.gz"

        echo "Backing up: $DIR"

        tar -czf "$DEST" "$DIR"

        if [ $? -eq 0 ]; then
            echo "SUCCESS: $DEST" | tee -a "$LOG_FILE"
        else
            echo "ERROR: Backup failed for $DIR" | tee -a "$LOG_FILE"
        fi

    else
        echo "WARNING: Directory not found: $DIR" | tee -a "$LOG_FILE"
    fi

done

# =========================
# CLEANUP OLD BACKUPS
# =========================
echo ""
echo "Cleaning backups older than $RETENTION_DAYS days..."

find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Old backups cleaned" | tee -a "$LOG_FILE"

# =========================
# FINAL STATUS
# =========================
echo ""
echo "Backup process complete."
echo "Logs saved to: $LOG_FILE"

echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup finished" >> "$LOG_FILE"

echo "===== DONE ====="
