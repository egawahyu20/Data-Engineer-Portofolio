#!/bin/sh
DATABASE_NAME=--all-databases
USER=root
PASSWORD=MjY3MzMtZWdhd2Fo

current_date=$(date +%Y%m%d)
base_backup_dir=/tmp/mysqldumps
backup_folder=$base_backup_dir/$current_date
sql_file=all-database-backup.sql

# Perform the backup of all databases using the mysqldump
# Store the output in the file all-databases-backup.sql
if mysqldump $DATABASE_NAME --user=$USER --password=$PASSWORD > $sql_file ; then
   echo "$sql_file created"
    #In the /tmp directory, create a directory named after current date like YYYYMMDD. For example, 20210830
    if [ -d $base_backup_dir ]; then
        mkdir $backup_folder
        echo "folder $backup_folder created"
    else
        mkdir $base_backup_dir
        echo "folder $base_backup_dir created"
        mkdir $backup_folder
        echo "folder $backup_folder created"
    fi
    # Move the file all-databases-backup.sql to /tmp/mysqldumps/<current date>/ directory
    mv $sql_file $backup_folder
    echo "file $sql_file move to $backup_folder"
else
   echo 'No backup was created!' 
   exit
fi