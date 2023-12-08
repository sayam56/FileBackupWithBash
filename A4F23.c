#!/bin/bash

# declaring the base and backup directories
base_dir_path="/home/iktider"
back_up_dir_path="/home/iktider/backup"

#location of the log file
log_file="${back_up_dir_path}/backup.log"

# checking if we have read permission for the base directory path
if [ ! -r "${base_dir_path}" ]; then
  echo "Cannot read files from ${base_dir_path}."
  exit 1
fi

# creating the neccessary folders if they're not there
mkdir -p "${back_up_dir_path}/cb"
mkdir -p "${back_up_dir_path}/ib"

#flag counters to keep track of how many backups have been created
com_backup_cnt=0
inc_backup_cnt=1

#creating a dummy to keep track of time stamps
touch "${back_up_dir_path}/dummytimestmp"

# main loop
while true; do
  ((com_backup_cnt++))

  #creating the tar files
  cb_tar_name="${back_up_dir_path}/cb/cb0000${com_backup_cnt}.tar"

  #now at thee first step we create a complete backup of the entire directory
  find "${base_dir_path}" -name "*.c" -o -name "*.txt" | tar -cf "${cb_tar_name}" -T -
  echo "$(date) ${cb_tar_name} was created" >> "${log_file}"

  #now updating the timestampt
  touch "${back_up_dir_path}/dummytimestmp"

  #first interval
  sleep 120 #tested with 20

  # now creatging the incremental backups 3 times

  for i in {1..3}; do
    ib_tar_name="${back_up_dir_path}/ib/ib1000${inc_backup_cnt}.tar"
    #checking for any new files that have been created of modified with .c or .txt extensions after last backup
    newly_cr_md_files=$(find "${base_dir_path}" \( -name "*.c" -o -name "*.txt" \) -newer "${back_up_dir_path}/dummytimestmp")
    if [ -n "${newly_cr_md_files}" ]; then
      echo "${newly_cr_md_files}" | tar -cf "${ib_tar_name}" -T -
      echo "$(date) ${ib_tar_name} was created" >> "${log_file}"
      #updating the incremental counter
      ((inc_backup_cnt++))

      # updating the dummy time stamp
      touch "${back_up_dir_path}/dummytimestmp"
    else
      echo "$(date) No changes-Incremental backup was not created" >> "${log_file}"
    fi

    # rest of the 3 intervals
    sleep 120 #tested with 20.
  done

done
