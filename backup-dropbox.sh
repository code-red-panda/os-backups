#!/bin/bash

BACKUP=dropbox
TS=$(date +%Y%m%d-%H%MCT)
BACKUP_SRC=Dropbox:/
BACKUP_TRG=Pi3:/mnt/md0/Dropbox
BIN=/usr/local/coderedpanda/bin
LOG_DIR=/var/log/coderedpanda
LOG_DETAIL=$LOG_DIR/backup-$BACKUP-details.log.$TS

source $BIN/backup-logger.sh

info "start"

TASK_NAME="Begin rclone"
COMMAND="/usr/local/bin/rclone sync $BACKUP_SRC $BACKUP_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"
