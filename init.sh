#! /usr/bin/sh
#apt update && apt upgrade -y && apt install zip -y

#wget https://raw.githubusercontent.com/navotera/serverAutomation/master/UbuntuserverInitiateSetup.sh
#chmod +x UbuntuserverInitiateSetup.sh
#bash UbuntuserverInitiateSetup.sh


#! /usr/bin/sh
apt update && apt upgrade -y && apt install zip -y

#clone first 
cd /tmp && git clone -b optimization https://github.com/navotera/BashServerSetup.git
chmod +x /tmp/BashServerSetup/preparing.sh && bash /tmp/BashServerSetup/preparing.sh


