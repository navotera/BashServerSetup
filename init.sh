#! /usr/bin/sh
#apt update && apt upgrade -y && apt install zip -y

#wget https://raw.githubusercontent.com/navotera/serverAutomation/master/UbuntuserverInitiateSetup.sh
#chmod +x UbuntuserverInitiateSetup.sh
#bash UbuntuserverInitiateSetup.sh


#! /usr/bin/sh
apt update && apt install zip -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

#clone first 
cd /tmp && git clone -b optimization https://github.com/navotera/BashServerSetup.git
chmod +x /tmp/BashServerSetup/core.sh
chmod +x /tmp/BashServerSetup/preparing.sh && bash /tmp/BashServerSetup/preparing.sh


