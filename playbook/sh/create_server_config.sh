#!/bin/bash

PMA_LATEST_VERSION_INFO_URL="https://www.phpmyadmin.net/home_page/version.php"
PMA_VERSION=$(wget -q -O /tmp/pma_lastest.html $PMA_LATEST_VERSION_INFO_URL && sed -ne '1p' /tmp/pma_lastest.html);
PAMIN_URL="https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz"

echo "HOSTNAME=$hostname" > ~/server.config
echo "PAMIN_URL=$PAMIN_URL" >> ~/server.config
echo "PASSWORD=$PASSWD" >> ~/server.config 
echo 
echo "${GREEN}Starting the installation process \n (php package 7.3-7.4, Webmin, ModGeoIP2, Fail2ban, timezone to Asia/Makassar,mysql root admin, webmin root authentication, mod security, ssh private keys and other optimization..${NC}"
echo 
echo "root & root_db password : ${YELLOW}${PASSWD}${NC}"
echo "Password can only be used for webmin & phpmyadmin access, ssh access should use id_rsa authentication"
echo 
echo "Webmin url : ${YELLOW}https://${IP_ADDRESS}:9191${NC}"
echo "Pamin url : ${YELLOW}http://${IP_ADDRESS}:9292${NC}"
echo 
echo "Log can be found on ${GREEN}installServer.log${NC}"
echo 
echo "Created By navotera : https://share-system.com"
echo "No Warranty is provided"
echo 
echo "${GREEN}Please enjoy and wait for about 15 to 25 minutes to finish all the process then rebooting...${NC}"

sleep 5