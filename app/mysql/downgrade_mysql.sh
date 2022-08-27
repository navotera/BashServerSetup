#!/usr/bin/env bash
# ini akan menghapus seluruh database, pastikan anda sudah melakukan backup 
# Select Ubuntu Bionic upon modal pop up
sudo service mysql stop || echo "mysql not stopped"

sudo apt-get remove --purge mysql* -y 
sudo apt-get purge mysql* -y
sudo apt-get install -f
dpkg --remove --force-all mysql-apt-config
sudo apt autoremove -y && sudo apt autoclean -y
sudo apt-get remove dbconfig-mysql
sudo rm -rf /var/lib/mysql 
sudo rm -rf /etc/mysql
sudo apt-get purge mysql-apt-config


cd /tmp/
echo mysql-apt-config mysql-apt-config/select-server select mysql-5.7 | sudo debconf-set-selections
wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
sudo dpkg --install /tmp/mysql-apt-config_0.8.13-1_all.deb


mv mysql_pref /etc/apt/preferences.d/mysql

#remove invalid mysql key
apt-key del  'A4A9 4068 76FC BD3C 4567 70C8 8C71 8D3B 5072 E1F5'
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29

sudo apt-get update -q
sudo apt-get install -q -y -o Dpkg::Options::=--force-confnew mysql-server
sudo apt-cache policy mysql-server
apt install -f mysql-client=5.7* -y
apt install -f mysql-community-server=5.7* -y
apt install -f mysql-server=5.7* -y
