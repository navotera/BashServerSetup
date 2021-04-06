#! /usr/bin/sh
apt install zip -y

wget https://raw.githubusercontent.com/navotera/serverAutomation/master/UbuntuserverInitiateSetup.sh
chmod +x UbuntuserverInitiateSetup.sh
bash UbuntuserverInitiateSetup.sh
