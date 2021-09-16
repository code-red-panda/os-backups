#!/bin/sh



volume_name="$1"
frequency="$2"
interval="$3"



echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT PURGE STATUS: [ START ]"



if test "$frequency" = "Daily"
then
    retention="$interval days"

elif test "$frequency" = "Weekly"
then
    retention="$interval weeks"

else
      echo "`date "+%Y-%m-%d %H:%M:%S"` ERROR::[$volume_name] Invalid argument: $frequency. Allowed values are "Daily" or "Weekly". Exiting."
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT PURGE STATUS: [ FAILED ]"
      exit 1

fi



snapshot_list="/tmp/snapshot-list"

echo -n > $snapshot_list
echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Retrieving ${frequency,} snapshots ..."
aws ec2 describe-snapshots --filter "Name=tag:Metadata,Values='$volume_name,AutoBackup,$frequency'" --query "Snapshots[*].[SnapshotId,StartTime]" --output text > $snapshot_list
  if test $? = 0
  then
      snapshot_total=`wc -l < $snapshot_list`
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] $snapshot_total snapshots retreived."

  else
      echo "`date "+%Y-%m-%d %H:%M:%S"` ERROR::[$volume_name] Snapshots not retreived. Exiting."
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT PURGE STATUS: [ FAILED ]"
      exit 1

  fi



purge_date=`date --date="$retention ago" +%s`
counter=0
IFS=$'\n'

echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Checking for snapshots older than $retention ( `date --date="$retention ago" +%Y-%m-%d` ) ..."
for snapshot in $(< $snapshot_list)
do
    snapshot_id=`echo $snapshot | awk '{print $1}'`
    snapshot_date=`echo $snapshot | awk '{print $2}' | awk -F "T" '{printf "%s\n", $1}' | xargs -iX date --date=X +%s`

    if (( $snapshot_date <= $purge_date ))
    then
        let counter++
        aws ec2 delete-snapshot --snapshot-id $snapshot_id
          if test $? = 0
          then
              echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Purged snapshot $snapshot_id ( `echo $snapshot_date | xargs -iX date --date=@X +%Y-%m-%d` )"

          else
              echo "`date "+%Y-%m-%d %H:%M:%S"` ERROR::[$volume_name] Failed to purge snapshot $snapshot_id ( `echo $snapshot_date | xargs -iX date --date=@X +%Y-%m-%d` ). Exiting."
              echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] $counter snapshots purged before this error."
              echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT PURGE STATUS: [ FAILED ]"
              exit 1

          fi

    fi

done



if test $counter = 0
then
    echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] No snapshots found to purge."

else
    echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] $counter snapshots purged."

fi

echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT PURGE STATUS: [ COMPLETED ]"
