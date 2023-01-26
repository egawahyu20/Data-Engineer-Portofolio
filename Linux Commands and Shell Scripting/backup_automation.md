# Scenario
You are a lead linux developer at the top-tech company “ABC International INC.” ABC currently suffers from a huge bottleneck - each day, interns must painstakingly access encrypted password files on core servers, and backup those that were updated within the last 24-hours. This introduces human error, lowers security, and takes an unreasonable amount of work.

As ABC INC’s most trusted linux developer, you have been tasked with creating a script backup.sh which automatically backs up any of these files that have been updated within the past 24 hours.

## Task 1

Set two variables equal to the values of the first and second command line arguments
```
targetDirectory=$1
destinationDirectory=$2
```

## Task 2
Display the values of the two command line arguments in the terminal.
```
echo "Target directory: $targetDirectory"
echo "Destination $destinationDirectory"
```

## Task 3
Define a variable called currentTS as the current timestamp, expressed in seconds.
```
currentTS=$(date +%s)
```

## Task 4
Define a variable called backupFileName to store the name of the archived and compressed backup file that the script will create.
```
backupFileName="backup-$currentTS.tar.gz"
```

## Task 5
Define a variable called origAbsPath with the absolute path of the current directory as the variable’s value.
```
origAbsPath=`pwd`
```

## Task 6
Define a variable called destAbsPath with value equal to the absolute path of the destination directory.
```
cd $destinationDirectory
destAbsPath=`pwd`
```

## Task 7
Change directories from the current working directory to the target directory targetDirectory.
```
cd $origAbsPath
cd $targetDirectory
```

## Task 8
You need to find files that have been updated within the past 24 hours.
This means you need to find all files who’s last modified date was 24 hours ago or less.
```
yesterdayTS=$(($currentTS - 24*60*60))
```

## Task 9
Within the $() expression inside the for loop, write a command that will return all files and directories in the current folder.
```
for file in $(ls -a)
```

## Task 10
Inside the for loop, you want to check whether the $file was modified within the last 24 hours.
```
if ((`date -r $file +%s` > $yesterdayTS))
```

## Task 11
In the if-then statement, add the $file that was updated in the past 24-hours to the toBackup array.
```
toBackup+=($file)
```

## Task 12
After the for loop, compress and archive the files, using the $toBackup array of filenames, to a file with the name backupFileName.
```
tar -czvf $backupFileName ${toBackup[@]}
```

## Task 13
Now the file $backupFileName is created in the current working directory.

Move the file backupFileName to the destination directory located at destAbsPath.
```
mv $backupFileName $destAbsPath
```

## Task 14
1. Save the file you’re working on (backup.sh) and make it executable.
    ```
    chmod u+x backup.sh
    ```

2. Verify the file is executable using the ls command with the -l option
    ```
    ls -l backup.sh
    ```

## Task 15
1. Download the following zip file with the wget command:
    ```
    wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-LX0117EN-SkillsNetwork/labs/Final%20Project/important-documents.zip
    ```
2. Unzip the archive file:
    ```
    unzip -DDo important-documents.zip
    ```
    (-DDo to overwrite and not restore original modified date)

3. Update the file’s last modified date to now:
    ```
    touch important-documents/*
    ```
4. Test your script using the following command:
    ```
    ./backup.sh important-documents .
    ```
## Task 16

1. Copy (don’t mv) the backup.sh script into the /usr/local/bin/ directory.

2. Test the cronjob to see if the backup script is getting triggered by scheduling it for every 1 minute.
    ```
    */1 * * * * /usr/local/bin/backup.sh /home/project/important-documents /home/project
    ```
3. Please note that since the Theia Lab is a virtual environment, we need to explicitly start the cron service using the below command.
    ```
    sudo service cron start
    ```
4. Once the cron service is started, please check in the directory (/home/project) if the tar files are getting created.

5. If yes, then please stop the cron service using the below command, else it will continue to create tar files every minute.
    ```
    sudo service cron stop
    ```
6. Using crontab, schedule your /usr/local/bin/backup.sh script to backup the important-documents folder every 24 hours to the directory (/home/project).
    ```
    */24 * * * * /usr/local/bin/backup.sh /home/project/important-documents /home/project
    ```