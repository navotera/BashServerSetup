#!/bin/bash

# collor config
# ref : https://stackoverflow.com/a/20983251
RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`

PMA_LATEST_VERSION_INFO_URL="https://www.phpmyadmin.net/home_page/version.php"
PMA_VERSION=$(wget -q -O /tmp/pma_lastest.html $PMA_LATEST_VERSION_INFO_URL && sed -ne '1p' /tmp/pma_lastest.html);
PAMIN_URL="https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz"
SETUP_PATH="/tmp/BashServerSetup/"

# random password
PASSWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1)
# check IP addres
IP_ADDRESS=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')


# Get the current IPv4 address
IP_ADDRESS=$(hostname -I | awk '{print $1}')
LAST_THREE_DIGITS=$(echo "$IP_ADDRESS" | awk -F. '{print $NF}')
# Combine with "abc.com"
hostname="${LAST_THREE_DIGITS}opensynergic.com"
hostname $hostname

# get pamin folder's name
splitUrl=$(echo $PAMIN_URL | tr "/" "\n")                                             
PAMIN=${PAMIN_URL##*/}


wget "$PAMIN_URL"
wget "$PAMIN_SERVICE_URL" -P serverInit/

#unzip "$PAMIN", unzip not work
tar -xvzf "$PAMIN"

# rename to pamin
PAMIN_FOLDER=$(basename $PAMIN .tar.gz)

mv $PAMIN_FOLDER pamin
# download and copy pamin.service to system path
cp "$SETUP_PATH"/serverInit/pamin.service /etc/systemd/system
# # move pamin to etc
mv pamin /etc

systemctl daemon-reload
service pamin start


echo "HOSTNAME=$hostname" > ~/server.config
echo "WEBMIN_URL=https://${IP_ADDRESS}:9191" >> ~/server.config
echo "PAMIN_URL=${IP_ADDRESS}:9292" >> ~/server.config
echo "PASSWORD=$PASSWD" >> ~/server.config 
echo "Log can be found on ${GREEN}installServer.log${NC}"
echo 
echo "Created By navotera : https://share-system.com"
echo "No Warranty is provided"
echo 
echo "${GREEN}Please enjoy and wait for about 15 to 25 minutes to finish all the process then rebooting...${NC}"

sleep 5

