PASSWD='abc'
sudo echo "CREATE USER 'root_db'@'localhost' IDENTIFIED BY '$PASSWD'; ALTER USER 'root_db'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASSWD'; GRANT ALL PRIVILEGES ON * . * TO 'root_db'@'localhost'; FLUSH PRIVILEGES;" | mysql  