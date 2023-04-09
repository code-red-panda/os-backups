#!/bin/bash

BACKUP=mac
TS=$(date +%Y%m%d-%H%MCT)
BACKUP_NAME=$BACKUP-$TS
BACKUP_SRC=$HOME/
BACKUP_TRG=/tmp/$BACKUP_NAME
BIN=/usr/local/bin
#DROPBOX=Dropbox:/Backups/$BACKUP
ICLOUD=$HOME/iCloud/Backups/$BACKUP
EMAIL=setMe@email.com
EXCLUDE=$BACKUP_TRG/exclude-list.txt
LOG_DIR=/var/log/os-backups
LOG_DETAIL=$LOG_DIR/backup-$BACKUP-details.log.$TS
RETENTION=7d

source $BIN/backup-logger.sh

info "start"

TASK_NAME="Create backup directories"
COMMAND="/bin/mkdir -p $BACKUP_TRG/ssh $BACKUP_TRG/ssh/config.d $BACKUP_TRG/config"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Create exclude list"
COMMAND="/bin/cat <<EOF >$BACKUP_TRG/exclude-list.txt"
info "task"
/bin/cat <<EOF > $BACKUP_TRG/exclude-list.txt
# Hidden files and directories
.*

# Mac security disallows this
Desktop

# Mac standard directories
Downloads
iTunes
Library
Movies
Music
Pictures
Public

# Custom directories
Alfred
Albert
Bin
Dropbox
iCloud
Projects
VirtualBox VMs
EOF
result

TASK_NAME="Begin rsync"
COMMAND="/usr/bin/rsync -avzP --exclude-from=$EXCLUDE $BACKUP_SRC $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Copy SSH configs"
COMMAND="/usr/bin/scp -r $HOME/.ssh/config $HOME/.ssh/config.d $BACKUP_TRG/ssh"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Copy .config"
COMMAND="/usr/bin/scp -r $HOME/.config/ $BACKUP_TRG/config"
COMMAND="/usr/bin/rsync -avzP --exclude='*.socket' $HOME/.config/ $BACKUP_TRG/config"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Tar backup"
COMMAND="/usr/bin/tar czf $BACKUP_TRG.tar.gz $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Encrypt backup"
COMMAND="/usr/local/bin/gpg --output $BACKUP_TRG.tar.gz.gpg --encrypt --recipient $EMAIL $BACKUP_TRG.tar.gz"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Copy backup to iCloud"
COMMAND="/usr/local/bin/rclone move $BACKUP_TRG.tar.gz.gpg $ICLOUD"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Purge old iCloud backups"
COMMAND="/usr/local/bin/rclone delete --min-age=$RETENTION $ICLOUD"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Remove local backup copies"
COMMAND="/bin/rm -rf $BACKUP_TRG*"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"
