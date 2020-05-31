#!/bin/bash

SYNC=alfred-snippets
SYNC_SRC=Dropbox:/Alfred/Alfred.alfredpreferences/snippets/
SYNC_TRG=$HOME/Documents/snippets/
BIN=$HOME/git/bin
LOG_DIR=/var/log/coderedpanda
LOG_DETAIL=$LOG_DIR/sync-$SYNC-details.log

source $BIN/backup-logger.sh

info "start"

TASK_NAME="Begin rclone"
COMMAND="/usr/bin/rclone sync $SYNC_SRC $SYNC_TRG"
info "task"
$COMMAND >> $LOG_DETAIL 2>&1
result

info "complete"
