#!/bin/bash

### ======================================= ###
DB_HOST="XXX"
DB_USER="XXX"
DB_PASS="XXX"
DB_NAME="XXX"
EXTERNAL_DEVICE_PATH="XXX"
FOLDERNAME="XXX"
FILENAME="$(date +'DATABASE_%m-%d-%Y').sql"
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

   if [ "$where" = "locally" ]; then
      mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "temp$FOLDERNAME/$FILENAME"
   else
      mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > "$EXTERNAL_DEVICE_PATH/$FOLDERNAME/$FILENAME"
   fi
}

if [ -d "$EXTERNAL_DEVICE_PATH" ]; then
   ### External Device Connected!

   ### Checking for Backup Folder
   mkdir -p "$EXTERNAL_DEVICE_PATH/$FOLDERNAME"

   ### Making the Backup
   createBackup "external"

   ### Checking for Errors on Command Execution
   if [ $? -ne 0 ]; then
      sendMessage "[$FILENAME] > Error while executing command: mysqldump"
      exit 1
   fi
   sendMessage "[$FILENAME] > Backup Created on External Device!"
else
   ### External Device NOT Connected!

   ### Checking for Backup Folder
   mkdir -p "temp$FOLDERNAME"

   ### Making the Backup
   createBackup "locally"

   ### Checking for Errors on Command Execution
   if [ $? -ne 0 ]; then
      sendMessage "[$FILENAME] > Error while executing command: mysqldump"
      exit 1
   fi
   sendMessage "[$FILENAME] > Backup Created Locally!"
fi
