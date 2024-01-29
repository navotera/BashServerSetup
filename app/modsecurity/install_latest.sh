##run command : 
##apt install apache2 -y && cd /tmp && wget https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/install_latest.sh && sh install_latest.sh

RED="\e[31m"
ENDCOLOR="\e[0m"
GREEN="\e[32m"

apt update
sudo apt install g++ flex bison curl apache2-dev doxygen libyajl-dev ssdeep liblua5.2-dev libgeoip-dev libtool dh-autoreconf libcurl4-gnutls-dev libxml2 libpcre++-dev libxml2-dev git -y
cd ..
rm -rf modsecurity
mkdir -p modsecurity
mkdir -p /var/cache/modsecurity
cd modsecurity
wget -q $(curl -s https://api.github.com/repos/SpiderLabs/ModSecurity/releases/latest | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4)
rm *asc
rm *sha256

ModSecurityFile=`ls`

tar -xvf "$ModSecurityFile"
rm "$ModSecurityFile"

ModSecurityFolder=`ls`
cd "$ModSecurityFolder"
##this will take some 20 minutes, be patient
./build.sh && ./configure && make && make install
mkdir -p /etc/apache2/modsecurity.d
mv -- "/modsecurity/$ModSecurityFolder/modsecurity.conf-recommended"  /etc/apache2/modsecurity.d/modsecurity.conf

cd /modsecurity && git clone https://github.com/SpiderLabs/ModSecurity-apache mod-connector &&  cd /modsecurity/mod-connector
## make sure apache is available before running this command 
./autogen.sh && ./configure --with-libmodsecurity=/usr/local/modsecurity/ && make && make install
echo "LoadModule security3_module /usr/lib/apache2/modules/mod_security3.so" | sudo tee -a /etc/apache2/apache2.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/apache2/modsecurity.d/modsecurity.conf

##coreruleset
if [ ! -n "$(grep "^github.org " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.org >> ~/.ssh/known_hosts 2>/dev/null; fi 
git clone https://github.com/coreruleset/coreruleset.git /etc/apache2/modsecurity.d/owasp-crs
cp /etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf.example  /etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf

##coreruleset for plugins 
git clone https://github.com/coreruleset/wordpress-rule-exclusions-plugin.git /etc/apache2/modsecurity.d/owasp-crs/plugins/wordpress-rule-exclusions-plugin

cd /etc/apache2/modsecurity.d
wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/unicode.mapping

echo ' # Default Debian dir for modsecurity persistent data
        SecDataDir /var/cache/modsecurity  

        # Include OWASP ModSecurity CRS rules if installed        
        Include "/etc/apache2/modsecurity.d/modsecurity.conf"
        Include "/etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf"
        Include "/etc/apache2/modsecurity.d/owasp-crs/rules/*.conf"
' > init.conf

mv init.conf /etc/apache2/modsecurity.d/init.conf

echo '#!/bin/bash
source /etc/apache2/envvars
' > /tmp/source_apache

bash /tmp/source_apache

cd ..
rm -rf modsecurity && echo "${GREEN}Finished, folder removed${ENDCOLOR}"

#https://kifarunix.com/install-libmodsecurity-with-apache-on-ubuntu-18-04/


## add this in apache2 virtual host configuration: 
#modsecurity on 
#modsecurity_rules_file /etc/apache2/modsecurity.d/init.conf

# <IfModule security3_module>
#    modsecurity off
# </IfModule>



#copy all the modsecurity to exception folder 
mkdir /etc/apache2/modsecurity.d/exception
cp /tmp/BashServerSetup/app/modsecurity/exception/* /etc/apache2/modsecurity.d/exception/