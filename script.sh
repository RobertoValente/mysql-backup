#!/bin/bash

### ======================================= ###
DB_HOST="XXX"
DB_USER="XXX"
DB_PASS="XXX"
DB_NAME="XXX"
EXTERNAL_DEVICE_PATH="XXX"
FOLDERNAME="XXX"
FILENAME="$(date +'DATABASE_%m-%d-%Y').sql"
### ======================================= ###

if ! ping -q -c 1 -W 1 google.com > /dev/null; then
    echo "/!\ > Not connected to WIFI!"
    exit 1
fi

if [ -d "$EXTERNAL_DEVICE_PATH" ]; then
   ### External Device Connected!

   ### Checking for Backup Folder
   mkdir -p "$EXTERNAL_DEVICE_PATH/$FOLDERNAME"

   ### Making the Backup
   mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "$EXTERNAL_DEVICE_PATH/$FOLDERNAME/$FILENAME"

   ### Checking for Errors on Command Execution
   if [ $? -ne 0 ]; then
      echo "/!\ > Error executing 'mysqldump'!"
      exit 1
   fi
   echo "[$FILENAME] > Backup Created on External Device!"
else
   ### External Device NOT Connected!

   ### Checking for Backup Folder
   mkdir -p "temp$FOLDERNAME"

   ### Making the Backup
   mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "temp$FOLDERNAME/$FILENAME"

   ### Checking for Errors on Command Execution
   if [ $? -ne 0 ]; then
      echo "/!\ > Error executing 'mysqldump'!"
      exit 1
   fi
   echo "[$FILENAME] > Backup Created Locally!"
fi
