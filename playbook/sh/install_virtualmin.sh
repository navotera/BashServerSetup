#!/bin/bash
HostName=grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2
sudo wget -O /tmp/install_virtualmin.sh http://software.virtualmin.com/gpl/scripts/install.sh


# install virtualmin, it can be failed for GPG, so it should try again. 
command_to_execute="sudo VIRTUALMIN_NONINTERACTIVE=1 /bin/sh /tmp/install_virtualmin.sh --minimal --force --hostname "$HostName""

# Set the maximum number of retries
max_retries=3
retries=0

# Execute the command with retry
while [ $retries -lt $max_retries ]
do
  # Execute the command
  $command_to_execute

  # Check the exit status of the command
  if [ $? -eq 0 ]; then
    # If the command was successful, break out of the loop
    echo "Command executed successfully"
    break
  else
    # If the command failed, increment the retry count
    retries=$((retries+1))
    echo "Command failed. Retrying... (Attempt $retries of $max_retries)"
  fi
done