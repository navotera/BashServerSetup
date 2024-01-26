#!/bin/bash
new_password='111'

# Prompt user for new password
read -s -p "Enter the new password for MySQL root user: " new_password
echo

# Check if MySQL server is running
if sudo systemctl is-active --quiet mysql
then
  # Stop MySQL server
  sudo systemctl stop mysql

  # Start MySQL server with skip-grant-tables
  sudo mysqld_safe --skip-grant-tables &
  
  # Sleep to allow MySQL to start with skip-grant-tables
  sleep 3

  # Change the root password
  sudo mysql -e "UPDATE mysql.user SET authentication_string=PASSWORD('$new_password') WHERE User='root'; FLUSH PRIVILEGES;"

  # Stop MySQL server
  sudo pkill -f mysqld_safe

  # Start MySQL server normally
  sudo systemctl start mysql

  echo "MySQL root password has been changed."
else
  echo "MySQL server is not running."
fi