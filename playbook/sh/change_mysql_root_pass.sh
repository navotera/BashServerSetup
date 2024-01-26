#!/bin/bash

# Set new root password
NEW_PASSWORD=grep '^PASSWORD=' ~/server.config | cut -d'=' -f2

# Connect to MariaDB without a password 
mysql -u root <<EOF
USE mysql;
UPDATE user SET authentication_string=PASSWORD("$NEW_PASSWORD") WHERE User='root';
FLUSH PRIVILEGES;
EOF

echo "MariaDB root password changed to $NEW_PASSWORD"
