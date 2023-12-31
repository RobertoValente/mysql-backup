#!/bin/bash

### ======================================= ###
DB_HOST="XXX"
DB_USER="XXX"
DB_PASS="XXX"
DB_NAME="XXX"
EXTERNAL_DEVICE_PATH="XXX"
FOLDERNAME="XXX"
FILENAME="${DB_NAME}_$(date +'%d-%m-%Y').sql"
SEND_DISCORDWEBHOOK="NO" # Options: YES or NO
DISCORD_WEBHOOKURL="XXX"
### ======================================= ###

sendMessage() {
   local message=$1

   if [ "$SEND_DISCORDWEBHOOK" = "YES" ]; then
      if ! ping -q -c 1 -W 1 google.com > /dev/null; then
         echo "/!\ > Not connected to WIFI!" >> logsBackup.txt
         exit
      else
         curl -X POST $DISCORD_WEBHOOKURL  -H "Content-Type: application/json" -d "{\"content\": \"\`\`\`css\n${message}\`\`\`\"}"
      fi
   fi
   echo "$message" >> logsBackup.txt
}

createBackup() {
   local where=$1
   local filenametemp=$2

   if [ "$where" = "locally" ]; then
      mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "temp$FOLDERNAME/$filenametemp"
   else
      mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "$EXTERNAL_DEVICE_PATH/$FOLDERNAME/$filenametemp"
   fi
}

checkErrorsAfterBackup() {
   local filenametemp=$2

   if [ $? -ne 0 ]; then
         sendMessage "[$filenametemp] > Error while executing command: mysqldump"
         exit 1
   fi
}

if [ -d "$EXTERNAL_DEVICE_PATH" ]; then
   ### External Device Connected!

   ### Checking for Backup Folder
   mkdir -p "$EXTERNAL_DEVICE_PATH/$FOLDERNAME"

   ### Making the Backup
   createBackup "external" "$FILENAME"

   ### Checking for Errors on Command Execution
   checkErrorsAfterBackup "$FILENAME"

   ### Send Successful Message
   sendMessage "[$FILENAME] > Backup Created on External Device!"
else
   ### External Device NOT Connected!

   ### Checking for Backup Folder
   mkdir -p "temp$FOLDERNAME"

   ### Making the Backup
   createBackup "locally" "$FILENAME"

   ### Checking for Errors on Command Execution
   checkErrorsAfterBackup "$FILENAME"

   ### Send Successful Message
   sendMessage "[$FILENAME] > Backup Created Locally!"
fi
