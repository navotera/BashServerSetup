#! /usr/bin/sh
wget https://github.com/navotera/BashServerSetup/raw/master/app/mysql/downgrade_mysql.sh 
chmod +x downgrade_mysql.sh
bash downgrade_mysql.sh
rm downgrade_mysql.sh