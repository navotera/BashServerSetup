#!/bin/bash

RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`

#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

apt install git -y

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash
cd /tmp && rm -rf BashServerSetup && git clone https://github.com/navotera/BashServerSetup.git
add-apt-repository ppa:ondrej/php
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
sh /tmp/BashServerSetup/playbook/sh/create_server_config.sh && sh /tmp/BashServerSetup/playbook/sh/install_virtualmin.sh
apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/core.yml
apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/optimization.yml
apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/finalize.yml
sh /tmp/BashServerSetup/playbook/sh/finishing_all.sh


