#!/bin/bash



volume_name="$1"
frequency="$2"



echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT CREATE STATUS: [ START ]"



echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Retrieving volume ID ..."
volume_id=`aws ec2 describe-volumes --filter "Name=tag:Name,Values='$volume_name'" --query "Volumes[*].VolumeId" --output text`
  if test $? = 0
  then
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] $volume_id retreived."

  else
      echo "`date "+%Y-%m-%d %H:%M:%S"` ERROR::[$volume_name] Volume ID not retreived. Exiting."
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT CREATE STATUS: [ FAILED ]"
      exit 1

  fi



echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Creating snapshot ..."
aws ec2 create-snapshot --volume-id $volume_id --description $volume_name --tag-specifications "ResourceType=snapshot,Tags=[{Key=Metadata,Value='$volume_name,AutoBackup,$frequency'},{Key=Name,Value='$volume_name'}]"
  if test $? = 0
  then
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::[$volume_name] Snapshot created."

  else
      echo "`date "+%Y-%m-%d %H:%M:%S"` ERROR::[$volume_name] Snapshot not created. Exiting."
      echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT CREATE STATUS: [ FAILED ]"
      exit 1

  fi



echo "`date "+%Y-%m-%d %H:%M:%S"` INFO::>>>>>>>>>>>>>>>>>> SNAPSHOT CREATE STATUS: [ COMPLETED ]"
