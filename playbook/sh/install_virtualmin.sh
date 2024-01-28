#!/bin/bash
HostName=$(grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2)
sudo wget -O /tmp/install_virtualmin.sh http://software.virtualmin.com/gpl/scripts/install.sh
RETRY_COUNT=3

install_virtualmin() {
    VIRTUALMIN_NONINTERACTIVE=1 /bin/sh /tmp/install_virtualmin.sh --minimal --force --hostname "$HostName"
}

# Retry loop
for i in $(seq 1 $RETRY_COUNT); do
    echo "Attempt $i to install Virtualmin"
    install_virtualmin

    # Check the exit status
    if [ $? -eq 0 ]; then
        echo "Installation successful."
        break  # Exit the loop if successful
    else
        echo "Installation failed. Retrying..."
    fi

    # Sleep for a while before the next attempt (adjust as needed)
    sleep 5
done