# 📦 Automated Backup Script

## 📖 Overview
This is a simple and efficient **Bash-based backup automation script** that allows you to back up important directories into compressed archive files with timestamps.

It is designed for **Linux environments** and can be easily scheduled using `cron` for fully automated backups.

---

## 🚀 Features
- 📁 Backup multiple directories at once  
- 🕒 Timestamped backup files  
- 📦 Compressed archives (`.tar.gz`)  
- 📝 Logging of backup activities  
- ⚠️ Error handling for missing directories  
- 🔄 Easy automation with cron jobs  

---

## 🛠️ Requirements
- Linux OS (RHEL, Ubuntu, Debian, etc.)
- Bash shell
- `tar` installed (comes pre-installed on most systems)

---

## 📂 Project Structure
'''bash
backup-script/
│── backup.sh
│── README.md
'''
---

## 📥 Installation & Setup

### 1. Clone the Repository
'''bash
git clone https://github.com/Ajima-Fabian/automated-backup-script.git
cd automated-backup-script 
'''

---

### 2. Make script Executable
'''bash
chmod +x backup.sh
'''

---

### 3. Edit Backup Directories 
Open the script and modifications this section:

SOURCE_DIRS=("$HOME/Documents" "$HOME/Pictures")
BACKUP_DEST="$HOME/backups"

---

### 4. Run the script
'''bash
./backup.sh
'''
