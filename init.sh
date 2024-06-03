#!/bin/bash

REPO_URL="--branch apache2-nginx2 https://github.com/navotera/BashServerSetup.git"
BASE_FOLDER="/var/BashServerSetup/"

rm -rf $BASE_FOLDER && mkdir -p $BASE_FOLDER && cd $BASE_FOLDER && git clone $REPO_URL
mv $BASE_FOLDER/BashServerSetup/* $BASE_FOLDER

RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`

echo "Select an option:"
echo "1. Install ${YELLOW}Apache2${NC} with Virtualmin (default)"
echo "2. Install ${GREEN}Nginx${NC} with Virtualmin"

# Give the user 3 seconds to input their choice
echo -n "Enter your choice (1 or 2, or press Enter for default) within 10 seconds: "
read -r -t 10 choice

# Set the default choice if no input is provided within 3 seconds
if [ -z "$choice" ]; then
    echo "No choice made within 3 seconds. Proceeding with the default option (1)."
    choice=1
else
    echo "" # Add a newline after the countdown
fi

#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

apt install git -y

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash

add-apt-repository --yes --update ppa:ondrej/php 
add-apt-repository --yes --update ppa:deadsnakes/ppa
apt update 2>/dev/null >/dev/null
apt install software-properties-common -y
#add-apt-repository --yes --update ppa:ansible/ansible

# Update the SSH configuration file with the new timeout settings
sudo sed -i "/^ClientAliveInterval/c\ClientAliveInterval 4460" /etc/ssh/sshd_config
sudo sed -i "/^ClientAliveCountMax/c\ClientAliveCountMax 6" /etc/ssh/sshd_config


# Restart the SSH service to apply the changes
sudo systemctl restart ssh

echo "${GREEN}installing python 3.9 and 3.12..${NC}"
apt install python3.9 -y && apt install python3.12 -y
apt install python3-pip -y

#cd /usr/bin && ls -lrth python* && unlink python && ln -s /usr/bin/python3.12 python
#cd /usr/bin && ls -lrth python* && unlink python3 && ln -s /usr/bin/python3.12 python3

#harus direstart klo kd error 
service apport restart
systemctl restart systemd-timedated

echo "${GREEN}installing ansible..${NC}"
#apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/init.yml


sh ${BASE_FOLDER}playbook/sh/create_server_config.sh 


#preparing install the virtualmin 
#hostname started with number is invalid, so add "a"
HostName=$(grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2)
sudo wget -O /tmp/install_virtualmin.sh http://software.virtualmin.com/gpl/scripts/install.sh
hostName=${HostName}



# Handle the user's choice
case $choice in
    1)
        echo "${YELLOW}Installing Apache2 with Virtualmin...${hostName}${NC}"        
        VIRTUALMIN_NONINTERACTIVE=1 /bin/sh /tmp/install_virtualmin.sh --minimal --force --hostname "$hostName"        
        ;;
    2)
        echo "${GREEN}Installing Nginx with Virtualmin...with ${hostName} ${NC}"
        sudo add-apt-repository -y ppa:ondrej/nginx
        sudo apt update
        apt-get install -y nginx
        VIRTUALMIN_NONINTERACTIVE=1 /bin/sh /tmp/install_virtualmin.sh --minimal --force --hostname "$hostName" -b LEMP
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

apt install ansible -y && ansible-playbook ${BASE_FOLDER}playbook/core.yml
apt install ansible -y && ansible-playbook ${BASE_FOLDER}playbook/optimization.yml
apt install ansible -y && ansible-playbook ${BASE_FOLDER}playbook/finalize.yml
sh ${BASE_FOLDER}playbook/sh/finishing_all.sh


