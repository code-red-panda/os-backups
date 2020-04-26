#!/bin/bash

BACKUP=joplin
BACKUP_NAME=$(date +$BACKUP-%Y-%m-%d-%H-%M-CT)
BACKUP_PATH=$HOME/Desktop
BACKUP_TRG=$BACKUP_PATH/$BACKUP_NAME
BIN=$HOME/git/bin
DROPBOX=Dropbox:/Backups/$BACKUP
EMAIL=jake@coderedpanda.cloud
LOG_DIR=/var/log/coderedpanda
LOG_DETAIL=$LOG_DIR/backup-$BACKUP-details.log
RETENTION=7d

source $BIN/backup-logger.sh

info "start"

TASK_NAME="Create backup directories"
COMMAND="/bin/mkdir -p $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Synchronize Joplin"
COMMAND="/usr/local/bin/joplin sync"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Export raw backup"
COMMAND="/usr/local/bin/joplin --log-level debug export --format raw $BACKUP_TRG"
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

TASK_NAME="Copy backup to Dropbox"
COMMAND="/usr/local/bin/rclone copy $BACKUP_TRG.tar.gz.gpg $DROPBOX"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Purge old Dropbox backups"
COMMAND="/usr/local/bin/rclone delete --min-age=$RETENTION $DROPBOX"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

TASK_NAME="Remove local backup copies"
COMMAND="/bin/rm -rf $BACKUP_TRG*"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"
