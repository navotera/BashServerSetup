#!/bin/bash

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash
wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/install_modsecurity2.yml -P /tmp
apt update
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
add-apt-repository --yes --update ppa:deadsnakes/ppa
apt-get update
apt-get install python3.6 && apt-get install python3.7 && apt-get install python3.8
apt install python3-pip

cd /usr/bin && ls -lrth python* && unlink python && ln -s /usr/bin/python3.8 python
cd /usr/bin && ls -lrth python* && unlink python3 && ln -s /usr/bin/python3.8 python3


apt install ansible -y && ansible-playbook /tmp/install_modsecurity2.yml