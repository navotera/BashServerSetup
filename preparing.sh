#!/bin/bash
# System requirement 
# Ubuntu 18.X, 20.X Memory Min 1GB
# pada beberapa vps instalasi bisa gagal misalnya ada pesan DPKG is being used by another process, hal ini disebabkan oleh vps yang tidak terkonfigurasi
# bisa dikarenakan source yang gagal atau hal lainnya, bisa juga error saat mengganti mysql authentication. Solusinya ganti / rebulild ulang VPS sebelum digunakan lagi.
#log disimpan di serverInstal.log
# Features : 
    # Webmin port 9191, securing ssh,  fail2ban auto config, http2, php installed from 7.3 to 7.4 including package
    # Htop, imagick, cron to disable webmin on each 4 hours, ubuntu optimization
    # Apache2 http/2 - event mode, ModSecurity, Mod_GeoIP2

#phpmyadmin user : root_db password can be found on server.config file
#webmin pass : can be found on server.config file
#created by navotera : share-system.com

#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

JAIL_CONFIG_URL="/tmp/BashServerSetup/serverInit/jail.local"
CORE_FILE_URL="/tmp/BashServerSetup/core.sh"
SETUP_PATH="/tmp/BashServerSetup/"

# shoud call it dynamically
# fix this later


# collor config
# ref : https://stackoverflow.com/a/20983251
RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`

# random password
PASSWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1)
# check IP addres
IP_ADDRESS=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')

#create file and variable 

# custom hostname
# add validation hostname next
ip_address=$(ip addr show eth0 | awk '/inet / {split($2, a, "."); print a[3];}')
combined_string="${ip_address}.opensynergic.com"
hostname $combined_string
#hostname="opensynergic.com"
#hostnamectl set-hostname abc


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

#creating log file : install.log
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3
#exec 1>installServer.log 2>&1

# check if its exsist
#mkdir serverInit
#cd serverInit
#wget "$JAIL_CONFIG_URL" -P serverInit/

chmod 755 "$SETUP_PATH"serverInit/jail.local



#get and initiate the core installation file
chmod +x "$CORE_FILE_URL" && sh -x "$CORE_FILE_URL"

#create user root_db with credential provided
service mysql start && sudo echo "CREATE USER 'root_db'@'localhost' IDENTIFIED BY '$PASSWD'; ALTER USER 'root_db'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASSWD'; GRANT ALL PRIVILEGES ON * . * TO 'root_db'@'localhost'; FLUSH PRIVILEGES;" | mysql  



#cannot change password for webmin on bash
#sudo sh -c 'echo root:$ROOT_PASSWORD | chpasswd'
echo 
echo "${GREEN}rebooting..${NC}"
echo 

# Doesn't work
/usr/share/webmin/changepass.pl /etc/webmin root $PASSWD

sudo rm -rf "$SETUP_PATH"

#disable other user read this file
chmod 640 server.config 

#restore the setting : 
sed -i 's/#$nrconf{restart} = '\''a'\'';/\$nrconf{restart} = '\''i'\'';/' /etc/needrestart/needrestart.conf

sudo reboot
# reboot here  
