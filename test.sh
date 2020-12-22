sudo apt-get install libapache2-mod-security2 -y
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo  sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine on/'  /etc/modsecurity/modsecurity.conf
sudo mv /usr/share/modsecurity-crs /usr/share/modsecurity-crs.bk
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
if [ ! -n "$(grep "^github.org " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.org >> ~/.ssh/known_hosts 2>/dev/null; fi 
sudo git clone https://github.com/coreruleset/coreruleset.git /usr/share/modsecurity-crs 
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
sudo sed -i 's#</IfModule>#\tIncludeOptional /usr/share/modsecurity-crs/crs-setup.conf\n</IfModule>#'  /etc/apache2/mods-enabled/security2.conf
sudo sed -i 's#</IfModule>#\tIncludeOptional /usr/share/modsecurity-crs/rules/*.conf\n</IfModule>#'  /etc/apache2/mods-enabled/security2.conf

 rm install* ; rm Ubuntu* ; rm server.config  ; rm fail* ; rm cron  