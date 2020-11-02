#!/bin/bash

SYNC=alfred-snippets
TS=$(date +%Y%m%d-%H%MCT)
SYNC_SRC=Dropbox:/Alfred/Alfred.alfredpreferences/snippets
SYNC_TRG=$HOME/Snippets
BIN=/usr/local/coderedpanda/bin
LOG_DIR=/var/log/coderedpanda
LOG_DETAIL=$LOG_DIR/sync-$SYNC-details.log.$TS

source $BIN/backup-logger.sh

mkdir -p $SYNC_TRG

info "start"

TASK_NAME="Run rclone to sync Alfred snippets"
COMMAND="/usr/bin/rclone sync $SYNC_SRC $SYNC_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"
