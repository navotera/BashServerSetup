#!/bin/bash

# Set new root password
NEW_PASSWORD=$(grep '^PASSWORD=' /root/server.config | cut -d'=' -f2)
echo $NEW_PASSWORD

# Connect to MariaDB without a password 
mysql -u root <<EOF
CREATE USER 'root_db'@'localhost' IDENTIFIED BY '$NEW_PASSWORD';
ALTER USER 'root_db'@'localhost' IDENTIFIED BY '$NEW_PASSWORD'; 
GRANT ALL PRIVILEGES ON *.* TO 'root_db'@'localhost'; 
FLUSH PRIVILEGES;
EOF

echo "MariaDB root_db password changed to $NEW_PASSWORD"
echo "root_db user is created!"

