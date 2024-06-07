#!/bin/bash

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

# Get the current IPv4 address
IP_ADDRESS=$(hostname -I | awk '{print $1}')
LAST_THREE_DIGITS=$(echo "$IP_ADDRESS" | awk -F. '{print $NF}')
# Combine with "abc.com"
hostname="opensynergic${LAST_THREE_DIGITS}.com"
echo $hostname
hostname $hostname

rm ~/server.config
touch ~/server.config

echo "${GREEN}Creating server.config${NC}"
echo "HOSTNAME=$hostname" >> ~/server.config 2>/dev/null
echo "WEBMIN_URL=https://${IP_ADDRESS}:9191" >> ~/server.config 2>/dev/null  
echo "PAMIN_URL=http://${IP_ADDRESS}:9292" >> ~/server.config 2>/dev/null
echo "PASSWORD=$PASSWD" >> ~/server.config 2>/dev/null

sleep 5

