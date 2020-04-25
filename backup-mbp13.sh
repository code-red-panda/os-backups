#!/bin/bash

########## Crontab ##########
### # MBP13 Backup
### 8 14 * * * $HOME/git/bin/backup-mbp13.sh >> /var/log/coderedpanda/backup-mbp13.log 2>&1
############################

BACKUP=mbp13
BACKUP_NAME=$(date +$BACKUP-%Y-%m-%d_%H-%M-CT)
BACKUP_PATH=$HOME/Desktop
BACKUP_SRC=$HOME/
BACKUP_TRG=$BACKUP_PATH/$BACKUP_NAME
DROPBOX=$HOME/Dropbox/Backups/$BACKUP
EMAIL=jake@coderedpanda.cloud
EXCLUDE=$BACKUP_TRG/exclude-list.txt
RETENTION_DAYS=7
LOG_DIR=/var/log/coderedpanda
LOG_DETAIL=$LOG_DIR/backup-$BACKUP-details.log

source backup-logger.sh

info "start"

TASK_NAME="Create backup directories"
COMMAND="/bin/mkdir -p $BACKUP_TRG/ssh $BACKUP_TRG/ssh/config.d"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Create exclude list"
COMMAND="/bin/cat <<EOF >$BACKUP_TRG/exclude-list.txt"
info "task"
/bin/cat <<EOF > $BACKUP_TRG/exclude-list.txt
# Hidden files and directories
.*

# Mac standard directories
Applications
Desktop
Downloads
iTunes
Library
Movies
Music
Pictures
Public

# My custom directories
Dropbox
Git
VirtualBox VMs
vm
EOF
result

TASK_NAME="Begin rsync"
COMMAND="/usr/bin/rsync -avzP --exclude-from=$EXCLUDE $BACKUP_SRC $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Copy SSH configs"
COMMAND="/usr/bin/scp -r $HOME/.ssh/config $HOME/.ssh/ms_config $HOME/.ssh/config.d $BACKUP_TRG/ssh"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Tar backup"
COMMAND="/usr/bin/tar czf $BACKUP_TRG.tar.gz $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Encrypt backup to Dropbox"
COMMAND="/usr/local/bin/gpg --output $DROPBOX/$BACKUP_NAME.tar.gz.gpg --encrypt --recipient $EMAIL $BACKUP_TRG.tar.gz"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Purge old Dropbox backups"
COMMAND="/usr/bin/find $DROPBOX -mtime +$RETENTION_DAYS -delete"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Remove local backup copies"
COMMAND="/bin/rm -rf $BACKUP_TRG*"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"