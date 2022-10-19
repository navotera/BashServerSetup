#!/bin/bash

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash
wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/install_modsecurity2.yml -P /tmp
apt install ansible -y && ansible-playbook /tmp/install_modsecurity2.yml