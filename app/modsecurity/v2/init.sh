#!/bin/bash
#curl https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh | bash
cd /tmp && wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/install_modsecurity2.yml
apt install ansible && ansible-playbook /tmp/install_modsecurity2.yml