#!/bin/bash

info () {
  case $1 in
    start)
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP START >>>>>" >> $LOG_DETAIL 2>&1
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP START >>>>>" ;;
    complete)
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP COMPLETE >>>>>" >> $LOG_DETAIL 2>&1
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP COMPLETE >>>>>" ;;
    fail)
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") || ERROR || Exiting."
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP FAIL >>>>>" >> $LOG_DETAIL 2>&1
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") <<<<< BACKUP FAIL >>>>>"
	    exit 1 ;;
    task)
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") || INFO || $TASK_NAME"
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") || INFO || $COMMAND" ;;
    *)
	    echo "$(/bin/date "+%Y-%m-%d %H:%M:%S UTC") || UNKNOWN ||" ;;
  esac
}

result () {
  if test ! $? = 0
  then
      info "fail"
  fi
}

if test ! -d $LOG_DIR
then
    echo "ERROR: $LOG_DIR does not exist. Exiting."
    exit 1
fi

if test ! -f $LOG_DETAIL
then
    touch $LOG_DETAIL
    if test ! $? = 0
    then
        echo "ERROR: Could not create ${LOG_DETAIL} - check permissions of ${LOG_DIR}"
	exit 1
    fi	
fi
