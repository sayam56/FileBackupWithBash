# FileBackupWithBash
A bash script that runs continuously in the background and performs the following
operations:

#STEP 1:
Creates a complete backup of all the .C and .txt files (only) found in the entire directory tree rooted
at /home/username by tarring all the .C files into cb0****.tar stored at ~/home/backup/cb
 Update backup.log with the timestamp and the name of the tar file

(2 minutes interval)

#STEP 2:
Creates an incremental backup of only those .C and .txt files in the entire directory tree rooted at
/home/username that were newly created or modified (only) since the previous complete backup.
 If there are any newly created/modified .C and .txt files since the previous complete backup,
create a tar file of those files (only): ib1****.tar at ~/home/backup/ib and update backup.log
with the timestamp and the name of the tar file
 Else update backup.log with the timestamp and a message

(2 minutes interval)

#STEP 3:
Creates an incremental backup of only those .C and .txt files in the entire directory tree rooted at
/home/username that were newly created or modified (only) since the previous incremental backup.
 If there are any newly created/modified .C and .txt files since the previous incremental backup,
create a tar file of those text files (only): ib1****.tar at ~/home/backup/ib and update
backup.log with the timestamp and the name of the tar file
 Else update backup.log with the timestamp and a message

(2 minutes interval)

#STEP 4:
Creates an incremental backup of only those .C and .txt files in the entire directory tree rooted at
/home/username that were newly created or modified (only) since the previous incremental backup.
 If there are any newly created/modified .C and .txt files since the previous incremental backup,
create a tar file of those text files (only): ib1****.tar at ~/home/backup/ib and update
backup.log with the timestamp and the name of the tar file.
 Else update backup.log with the timestamp and a message.

(2 minutes Interval)

(REPEAT FROM STEP 1 ) //Continuous loop
