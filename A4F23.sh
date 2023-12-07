#!/bin/bash

# Define the root directory and backup directory
root_dir="/home/iktider"
backup_dir="/home/iktider/backup"

# Define the log file
log_file="${backup_dir}/backup.log"

# Check if the script has read access to the root directory
if [ ! -r "${root_dir}" ]; then
  echo "Error: The script does not have read access to ${root_dir}. Please check the permissions."
  exit 1
fi

# Create the backup directories if they don't exist
mkdir -p "${backup_dir}/cb"
mkdir -p "${backup_dir}/ib"

# Initialize the backup count
backup_count=0
inc_backup_count=1

# Create a dummy file to compare with for the first incremental backup
touch "${backup_dir}/dummy"

while true; do
  # Increment the backup count
  ((backup_count++))

  # Define the tar file names
  cb_tar_file="${backup_dir}/cb/cb0000${backup_count}.tar"
  ib_tar_file="${backup_dir}/ib/ib1000${inc_backup_count}.tar"

  # Create a complete backup
  find "${root_dir}" -name "*.c" -o -name "*.txt" | tar -cf "${cb_tar_file}" -T -
  echo "$(date) ${cb_tar_file} was created" >> "${log_file}"

  # Update the dummy file's timestamp to the time of the last backup
  touch "${backup_dir}/dummy"

  # Wait for 2 minutes
  sleep 20

  # Create an incremental backup
  new_files=$(find "${root_dir}" \( -name "*.c" -o -name "*.txt" \) -newer "${backup_dir}/dummy")
  if [ -n "${new_files}" ]; then
    echo "${new_files}" | tar -cf "${ib_tar_file}" -T -
    echo "$(date) ${ib_tar_file} was created" >> "${log_file}"
    ((inc_backup_count++))

    # Update the dummy file's timestamp to the time of the last backup
    touch "${backup_dir}/dummy"
  else
    echo "$(date) No changes-Incremental backup was not created" >> "${log_file}"
  fi

  # Wait for 2 minutes
  sleep 20

  # Repeat the incremental backup steps 2 more times
  for i in {1..2}; do
    ib_tar_file="${backup_dir}/ib/ib1000${inc_backup_count}.tar"
    new_files=$(find "${root_dir}" \( -name "*.c" -o -name "*.txt" \) -newer "${backup_dir}/dummy")
    if [ -n "${new_files}" ]; then
      echo "${new_files}" | tar -cf "${ib_tar_file}" -T -
      echo "$(date) ${ib_tar_file} was created" >> "${log_file}"
      ((inc_backup_count++))

      # Update the dummy file's timestamp to the time of the last backup
      touch "${backup_dir}/dummy"
    else
      echo "$(date) No changes-Incremental backup was not created" >> "${log_file}"
    fi

    # Wait for 2 minutes
    sleep 20
  done
done
