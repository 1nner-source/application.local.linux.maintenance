#!/bin/bash

# Backup storage directory
backupfolder=/home/usrname/DB_backup
logfile=/home/usrname/DB_backup/logs/db_backup.log

# MySQL_usr
user=sql_user
# MySQL_psswd
password=sql_usr_pass

# Number of days to store the backup
keep_day=15
sqlfile=$backupfolder/all-database-$(date +%Y-%m-%d_%H-%M-%S).sql
zipfile=$backupfolder/all-database-$(date +%Y-%m-%d_%H-%M-%S).zip
echo Starting Backup [$(date +%Y-%m-%d_%H-%M-%S)] >> $logfile

# Create a backup
/usr/bin/mysqldump -u$user -p$password --all-databases >> $sqlfile
if [ "$?" -eq 0 ]; then
  echo 'SQL dump created' >> $logfile
else
  echo [error] mysqldump return non-zero code $? >> $logfile
  exit
fi

# Compress backup
zip -j $zipfile $sqlfile
if [ "$?" -eq 0 ]; then
  echo 'The backup was successfully compressed' >> $logfile
else
  echo '[error] Error compressing backup' >> $logfile
  exit
fi
rm $sqlfile
echo $zipfile >> $logfile
echo Backup complete [$(date +%Y-%m-%d_%H-%M-%S)] >> $logfile

# Delete old backups
find $backupfolder -mtime +$keep_day -delete
