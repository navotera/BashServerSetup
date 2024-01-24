#!/bin/bash

#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash
cd /tmp && git clone -b optimization https://github.com/navotera/BashServerSetup.git
apt update
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible
add-apt-repository --yes --update ppa:deadsnakes/ppa
apt-get update
apt-get apt-get install python3.8 -y && apt-get install python3.12 -y
apt install python3-pip -y

cd /usr/bin && ls -lrth python* && unlink python && ln -s /usr/bin/python3.8 python
cd /usr/bin && ls -lrth python* && unlink python3 && ln -s /usr/bin/python3.8 python3


apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/init.yml


