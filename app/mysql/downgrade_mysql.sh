#!/usr/bin/env bash
# ini akan menghapus seluruh database, pastikan anda sudah melakukan backup 
# Select Ubuntu Bionic upon modal pop up
# run by => bash downgrade_mysql.sh
export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select bionic'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '
debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'


sudo service mysql stop 
sudo apt-get remove mysql* -y 
sudo apt-get purge mysql* -y 
sudo apt remove --purge mysql-community-server -y
sudo apt-get purge mysql* -y
sudo apt-get install -f
dpkg --remove --force-all mysql-apt-config
sudo apt autoremove -y && sudo apt autoclean -y
sudo apt-get remove dbconfig-mysql
sudo rm -rf /var/lib/mysql 
sudo rm -rf /etc/mysql
sudo apt-get purge mysql-apt-config


cd /tmp/
wget https://raw.githubusercontent.com/navotera/BashServerSetup/master/app/mysql/mysql_pref
echo mysql-apt-config mysql-apt-config/select-server select mysql-5.7 | sudo debconf-set-selections
wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
sudo dpkg -i /tmp/mysql-apt-config_0.8.13-1_all.deb
mv /tmp/mysql_pref /etc/apt/preferences.d/mysql




#remove invalid mysql key
apt-key del  'A4A9 4068 76FC BD3C 4567 70C8 8C71 8D3B 5072 E1F5'
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29

sudo apt-get update -q
sudo apt-cache policy mysql-server
mkdir -p /etc/mysql/conf.d/
apt install -f --allow-downgrades mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*



