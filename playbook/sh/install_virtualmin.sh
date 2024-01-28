#!/bin/bash
HostName=$(grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2)
sudo wget -O /tmp/install_virtualmin.sh http://software.virtualmin.com/gpl/scripts/install.sh

install_virtualmin() {
    VIRTUALMIN_NONINTERACTIVE=1 /bin/sh /tmp/install_virtualmin.sh --minimal --force --hostname "$HostName"
}

install_virtualmin

