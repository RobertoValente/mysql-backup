# mysql-backup
Shell Script for Backup your Database (on External Drive/Locally)

# 📌 How to use (Linux OS)
<em>*can be different for other devices/operating systems than Raspberry Pi Zero W</em>
```console
# Clone this repository
git clone https://github.com/RobertoValente/mysql-backup.git

# Install the MySQL Client (if mysql-client return error, then default-mysql-client should succeed)
sudo apt install mysql-client || sudo apt install default-mysql-client

# Navigate to the folder
cd mysql-backup

# Edit the Variables Values to your own
nano script.sh

# /!\ Explication of Variables
DB_HOST="XXX"   #=> IP Address (Your server should have MySQL Port Enable)
DB_USER="XXX"   #=> MySQL User with privileges to Dump/Export Databases
DB_PASS="XXX"   #=> MySQL User's Password
DB_NAME="XXX"   #=> Database Name to create the Backup
EXTERNAL_DEVICE_PATH="XXX"   #=> Full Path of your External Device for Backup Destination
FOLDERNAME="XXX"   #=> Folder Name that will have the Backups
FILENAME="${DB_NAME}_$(date +'%d-%m-%Y').sql"   #=> Your Backup File will have this name
SEND_DISCORDWEBHOOK="NO"   #=> Options are: YES or NO. This will make the script send Webhooks to a Discord Channel
DISCORD_WEBHOOKURL="XXX"   #=> Your Discord Webhook URL (Learn how to get here: https://youtu.be/K8vgRWZnSZw?si=h7vARBGsyzFS_RTL)

# Make the shell script executable
chmod u+x script.sh

# Execute the script to check if everything is Ok
./script.sh

# You can also check the logs of the script
cat logsBackup.txt
```

# 📌 To Run Infinitely (CronJob Creation)
<em>*can be different for other devices/operating systems than Raspberry Pi Zero W</em>
```console
# To let the script run periodically, we need to create a CronJob
# For it, Raspberry Pi OS (and other Linux OS) have CronJob Service incorporate, so let's setup!

# Get the full path to your script file
pwd

# Open CronTab to configure the CronJob
crontab -e

# Paste on the file, the following line:
<time_configuration> <pwd_command_result>/script.sh

### Example: 0 5 * * * /home/robertovalente/mysql-backup/script.sh
### Result: Everyday at 5AM, the script will be executed!
```
- `<time_configuration>` - Replace to when you want the file to be executed by OS ([learn how to specific the time here](https://betterstack.com/community/questions/how-to-set-up-cron-job-for-specific-time-and-date/))
- `<pwd_command_result>` - Replace to the Output of PWD command (example: /home/robertovalente/mysql-backup)

# 📌 Final Result with Discord Webhook (Screenshot)
<img src="https://i.imgur.com/NYumsGA.png">

- <b>If you need some help,</b> choose a contact method and send me a message: https://github.com/RobertoValente
