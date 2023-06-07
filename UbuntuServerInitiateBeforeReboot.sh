#!/bin/bash
. ./server.config 
#PASSWD='< /dev/urandom tr -dc A-Za-z0-9 | head -c16'
PATH_SSHD_CONFIG="/etc/ssh/sshd_config"
PAMIN_SERVICE_URL="https://raw.githubusercontent.com/navotera/serverAutomation/master/serverInit/pamin.service"

#setup Cron 
crontab -l > cron
sudo echo "*/5 * * * * /etc/webmin/status/monitor.pl" >> cron  
sudo echo "0 */4 * * * sudo service pamin stop" >> cron  
sudo echo "0 */4 * * * sudo service webmin stop" >> cron  
sudo echo "0 */4 * * * sudo service usermin stop" >> cron  
crontab cron
service cron reload 

#upgrade the package
#if you find the error A new version (/tmp/ABC) of configuration file /etc/ssh/sshd_config is available, you should run below command manually
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt-get -qy update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
sudo -E apt-get -qy autoclean

apt-get install imagemagick -y ; apt install libmagickwand-dev imagemagick php-dev -y ; printf "\n" | pecl install imagemagick
apt install libdigest-perl-md5-perl
#others utilites
apt install htop -y ; apt install ncdu -y ; apt install zip -y ; apt install screen -y ; apt install nfs-common -y ; apt install nethogs -y
sudo add-apt-repository ppa:bashtop-monitor/bashtop
sudo apt update
sudo apt install bashtop -y

#mod_geoip2 to allow disable access from another country
#https://dev.maxmind.com/geoip/legacy/mod_geoip2/
apt install libapache2-mod-geoip -y


#change timezone
sudo timedatectl set-timezone Asia/Makassar

#bermasalah pada saat upgrade karena grub tiba2 muncul modal dan error unknown
sudo wget http://software.virtualmin.com/gpl/scripts/install.sh && sudo VIRTUALMIN_NONINTERACTIVE=1 /bin/sh install.sh --minimal --force --hostname "$HOSTNAME"

virtualmin disable-feature --dns --all-domains
virtualmin disable-feature --mail --all-domains
virtualmin disable-feature --virtualmin-dav --all-domains

sudo service mysql stop 
sudo service fail2ban stop
sudo service sshd stop

virtualmin modify-php-ini --all-domains --ini-name memory_limit --ini-value 128M
virtualmin modify-php-ini --all-domains --ini-name upload_max_filesize --ini-value 500M
virtualmin modify-php-ini --all-domains --ini-name post_max_size --ini-value 500M
virtualmin disable-feature --all-domains --dns --mail --logrotate --virtualmin-dav

#version fail2ban 0.11.2
sudo wget https://github.com/fail2ban/fail2ban/releases/download/0.11.2/fail2ban_0.11.2-1.upstream1_all.deb
sudo dpkg -i fail2ban_0.11.2-1.upstream1_all.deb
cp serverInit/jail.local /etc/fail2ban/jail.local


#php 
sudo apt install software-properties-common -y ; sudo add-apt-repository ppa:ondrej/php -y && sudo apt update ;
#sudo apt install -y php5.6 php5.6-fpm php5.6-imagick php5.6-common php5.6-mysql php5.6-xml php5.6-curl php5.6-mbstring php5.6-mcrypt php5.6-gmp -y 
sudo apt install -y php7.3 php7.3-fpm php7.3-imagick php7.3-common php7.3-mysql php7.3-xml php7.3-curl php7.3-mbstring php7.3-mcrypt php7.3-gmp -y 
sudo apt install -y php7.4 php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-mbstring php7.4-imagick php7.4-curl php7.4-mcrypt php7.4-gmp -y
sudo apt install -y php8.1 php8.1-fpm php8.1-common php8.1-mysql php8.1-xml php8.1-mbstring php8.1-imagick php8.1-curl php8.1-mcrypt php8.1-gmp -y

#change webmin port
sed -i 's/port=10000/port=9191/' /etc/webmin/miniserv.conf 
#change password of mysql
#virtualmin set-mysql-pass --user root --pass '$MYSQL_PASS' 

sudo a2enmod expires
sudo a2enmod headers

#change the sshd variable 
# understand this !
#sudo sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' $PATH_SSHD_CONFIG 
#sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' $PATH_SSHD_CONFIG 
#sudo sed -i 's/UsePAM yes/UsePAM no/' $PATH_SSHD_CONFIG 
#sudo sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/' $PATH_SSHD_CONFIG 
#sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' $PATH_SSHD_CONFIG 
echo "#edited by serverAutomation by navotera :: share-system.com"  >> $PATH_SSHD_CONFIG
echo "ClientAliveInterval 1200" >> $PATH_SSHD_CONFIG 
echo "ClientAliveCountMax 3" >> $PATH_SSHD_CONFIG 
#echo "IgnoreRhosts yes" >> $PATH_SSHD_CONFIG 
#echo "IgnoreUserKnownHosts no" >> $PATH_SSHD_CONFIG 
#echo "StrictModes yes" >> $PATH_SSHD_CONFIG 
#echo "RSAAuthentication yes" >> $PATH_SSHD_CONFIG 
#echo "AllowUsers root" >> $PATH_SSHD_CONFIG 

# Disable root SSH login with password
#sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
if sshd -t -q; then
    systemctl restart sshd
fi

#sudo echo "$ROOT_PASSWORD" | passwd --stdin root
#change virtualmin config
if grep -R "home_format=" /etc/webmin/virtual-server/config
then  
    #allow new domain creation folder follow the domain name such as up.openjournaltheme.com instead of up as folder name
    sudo sed -i 's/home_format=/home_format=$DOM/' /etc/webmin/virtual-server/config
else 
    echo 'home_format=$DOM' >>  /etc/webmin/virtual-server/config 
fi                       
#disable installation wizard
if grep -R "wizard_run=" /etc/webmin/virtual-server/config
then  
    #allow new domain creation folder follow the domain name such as up.openjournaltheme.com instead of up as folder name
    sudo sed -i 's/wizard_run=/wizard_run=1/' /etc/webmin/virtual-server/config
else 
    echo 'wizard_run=1' >>  /etc/webmin/virtual-server/config 
fi     

#install rclone 
curl https://rclone.org/install.sh | sudo bash

#https://serverfault.com/a/608619
source /etc/apache2/envvars

#enable http/2 globally
echo 'Protocols h2 http/1.1' >>  /etc/apache2/apache2.conf                                                                                                                                                                           fi   

#install modsecurity and configure
# sudo apt-get install libapache2-mod-security2 -y
# sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
# sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine on/'  /etc/modsecurity/modsecurity.conf
# sudo mv /usr/share/modsecurity-crs /usr/share/modsecurity-crs.bk
# sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
# if [ ! -n "$(grep "^github.org " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.org >> ~/.ssh/known_hosts 2>/dev/null; fi 
# sudo git clone https://github.com/coreruleset/coreruleset.git /usr/share/modsecurity-crs 
# sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
# sudo sed -i 's#</IfModule>#\tIncludeOptional /usr/share/modsecurity-crs/crs-setup.conf\n</IfModule>#'  /etc/apache2/mods-enabled/security2.conf
# sudo sed -i 's#</IfModule>#\tIncludeOptional /usr/share/modsecurity-crs/rules/*.conf\n</IfModule>#'  /etc/apache2/mods-enabled/security2.conf

#modsecurity latest security2_module
#wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/install_latest.sh -P /tmp/ && sh /tmp/install_latest.sh


wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  -P /tmp/ && sh /tmp/init.sh


#setup the swap for 1G
sudo swapoff /swapfile
sudo fallocate -l 1G /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#optimization * for www-data and mysql
echo "#optimized by navotera - share-system.com" >> /etc/security/limits.conf
echo "www-data   soft  nofile   1048576" >> /etc/security/limits.conf
echo "www-data   soft  nproc   1048576" >> /etc/security/limits.conf
echo "nginx      soft  nofile   1048576" >> /etc/security/limits.conf
echo "nginx      soft  nproc   1048576" >> /etc/security/limits.conf
echo "mysql      soft  memlock   unlimited" >> /etc/security/limits.conf
echo "mysql      hard  memlock   unlimited" >> /etc/security/limits.conf
echo "mysql      hard  nofile   30720" >> /etc/security/limits.conf
echo "mysql      soft  nofile   20480" >> /etc/security/limits.conf
echo "mysql      soft  nproc    16384" >> /etc/security/limits.conf
echo "mysql      soft  fsize    unlimited" >> /etc/security/limits.conf

# php-cli yang dijalankan oleh root
# Ref : https://raazkumar.com/tutorials/linux/linux-security-limits-conf/
# echo "root     soft  nproc    1000000 >> /etc/security/limits.conf"
# echo "root     soft  nofile   100000 >> /etc/security/limits.conf"

echo "session required pam_limits.so"  >> /etc/pam.d/common-session
echo "fs.file-max = 2097152"  >> /etc/sysctl.conf
echo "fs.nr_open = 1048576"  >> /etc/sysctl.conf
echo 4096 > /proc/sys/net/ipv4/tcp_max_syn_backlog


#initiate apache mpm_event and TODO http/2
sudo a2enmod proxy_fcgi setenvif && sudo a2enconf php7.0-fpm ; sudo a2enconf php7.1-fpm ; sudo a2enconf php7.2-fpm ; sudo a2enconf php7.3-fpm ; sudo a2enconf php7.4-fpm  
sudo a2dismod php7.0  ; sudo a2dismod php7.1 ; sudo a2dismod php7.2 ; sudo a2dismod php7.3 ; sudo a2dismod php7.4
sudo kill -9 `sudo ps -ef | grep php-fpm | grep -v grep | awk '{print $2}'`
sudo a2enmod http2
sudo service apache2 restart
sudo a2dismod mpm_prefork && sudo a2enmod mpm_event 
sudo service apache2 restart 
sudo service php7.2-fpm restart ; sudo service php7.3-fpm restart ; sudo service php7.4-fpm restart
apt remove php5.4-fpm
sudo service sshd restart
sudo service webmin start

#enable start on boot
sudo service fail2ban start
update-rc.d fail2ban enable

# phpmyadmin as service
# get pamin service first (do it later)
wget "$PAMIN_URL"
wget "$PAMIN_SERVICE_URL" -P serverInit/

# get pamin folder's name
splitUrl=$(echo $PAMIN_URL | tr "/" "\n")                                             
PAMIN=${PAMIN_URL##*/}

#unzip "$PAMIN", unzip not work
tar -xvzf "$PAMIN"

# rename to pamin
PAMIN_FOLDER=$(basename $PAMIN .tar.gz)

mv $PAMIN_FOLDER pamin
# download and copy pamin.service to system path
 wget "$PAMIN_SERVICE_URL" -P serverInit/ && cp serverInit/pamin.service /etc/systemd/system
# # move pamin to etc
 mv pamin /etc

systemctl daemon-reload
service pamin start

#remove server banner 
sed -i '/^[^#]*\<pam_motd.so\>/s/^/#/' /etc/pam.d/sshd

firewall-cmd --zone=public --permanent --add-port=9191/tcp
firewall-cmd --zone=public --permanent --add-port=9292/tcp
firewall-cmd --zone=public --permanent --add-port=9393/tcp
firewall-cmd --reload



