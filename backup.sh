#!/bin/bash

: '
=========================================================================
Advanced Automated Backup Script (v2) - FULLY COMMENTED VERSION
Author: Ajima Fabian
Email: ajimafabian18@gmail.com
GitHub: https://github.com/Ajima-Fabian

PURPOSE:
--------
This script automatically backs up important directories on your system,
compresses them into .tar.gz files, logs every action, and cleans up
old backups to save disk space.

WHO THIS IS FOR:
----------------
- Beginners learning Bash scripting
- DevOps beginners
- System automation learners

FEATURES:
---------
✔ Automated folder backup
✔ Timestamped backup files (no overwrites)
✔ Logging system for tracking actions
✔ Error handling (success/failure detection)
✔ Disk space check
✔ Automatic cleanup of old backups
✔ Ready for cron scheduling (automation)

HOW IT WORKS:
-------------
1. Define folders to backup
2. Create backup destination
3. Check disk space
4. Loop through each folder
5. Compress folder into .tar.gz file
6. Log success or failure
7. Delete backups older than X days
8. Save logs for tracking

=========================================================================

IMPORTANT LINUX CONCEPTS USED:
-----------------------------
- Variables
- Arrays
- Loops (for)
- Conditionals (if/else)
- Command substitution $(...)
- File testing (-d)
- Exit codes ($?)
- File compression (tar)
- Logging system (tee, >>)
- Find command for cleanup
=========================================================================
'

# =========================
# HEADER OUTPUT
# =========================
# Prints script title and current timestamp for user visibility
echo "===== Advanced Automated Backup Script ====="

# Shows current date and time in a readable format
# %Y = year, %m = month, %d = day, %H = hour, %M = minute, %S = second
echo "Date: $(date +%Y-%m-%d_%H-%M-%S)"
echo ""

# =========================
# CONFIGURATION SECTION
# =========================
# This is where you define what the script will use

# List of directories to backup (ARRAY)
# You can add more folders like:
# "$HOME/Desktop", "$HOME/Downloads", etc.
SOURCE_DIRS=("$HOME/Documents" "$HOME/Pictures")

# Where backups will be stored
BACKUP_DEST="$HOME/backups"

# Log file to track everything the script does
LOG_FILE="$HOME/backup.log"

# Number of days before old backups are deleted
# Example: 7 means delete backups older than 7 days
RETENTION_DAYS=7

# =========================
# SETUP SECTION
# =========================
# Create backup directory if it does not exist
mkdir -p "$BACKUP_DEST"

# Create log file if it does not exist
touch "$LOG_FILE"

# Log the start of the backup process
echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup started" >> "$LOG_FILE"

# =========================
# DISK SPACE CHECK
# =========================
# df -h shows human-readable disk usage
# This helps prevent backups from failing due to low storage
echo "Checking available disk space..."
df -h "$BACKUP_DEST" | tee -a "$LOG_FILE"
echo ""

# =========================
# BACKUP PROCESS (CORE LOGIC)
# =========================
# Loop through each directory in SOURCE_DIRS array

for DIR in "${SOURCE_DIRS[@]}"; do

    # Check if directory exists before trying to backup
    # -d means "directory exists"
    if [ -d "$DIR" ]; then

        # Extract only folder name from full path
        # Example: /home/user/Documents → Documents
        BASENAME=$(basename "$DIR")

        # Generate timestamp for unique backup file name
        TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

        # Create full destination file path
        # Example:
        # backups/Documents_backup_2026-04-19_12-30-00.tar.gz
        DEST="$BACKUP_DEST/${BASENAME}_backup_$TIMESTAMP.tar.gz"

        echo "Backing up: $DIR"

        # =========================
        # CREATE BACKUP FILE
        # =========================
        # tar = archive tool
        # -c = create archive
        # -z = compress using gzip
        # -f = specify filename

        tar -czf "$DEST" "$DIR"

        # Check if last command (tar) succeeded
        # $? = exit status of last command
        # 0 = success, anything else = failure
        if [ $? -eq 0 ]; then

            # Log success message to both terminal and log file
            echo "SUCCESS: $DEST" | tee -a "$LOG_FILE"

        else
            # Log error message if backup fails
            echo "ERROR: Backup failed for $DIR" | tee -a "$LOG_FILE"
        fi

    else
        # If directory does not exist, warn user and log it
        echo "WARNING: Directory not found: $DIR" | tee -a "$LOG_FILE"
    fi

done

# =========================
# CLEANUP OLD BACKUPS
# =========================
echo ""
echo "Cleaning backups older than $RETENTION_DAYS days..."

# find command explanation:
# -type f → only files
# -name "*.tar.gz" → only backup files
# -mtime +7 → older than 7 days
# -exec rm -f {} \; → delete matched files

find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Old backups cleaned" | tee -a "$LOG_FILE"

# =========================
# FINAL STATUS
# =========================
echo ""
echo "Backup process complete."

# Show where logs are stored
echo "Logs saved to: $LOG_FILE"

# Log completion time
echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup finished" >> "$LOG_FILE"

echo "===== DONE ====="
