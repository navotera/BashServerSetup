HostName=grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2
sudo wget http://software.virtualmin.com/gpl/scripts/install.sh && sudo VIRTUALMIN_NONINTERACTIVE=1 /bin/sh install.sh --minimal --force --hostname "$HostName"
