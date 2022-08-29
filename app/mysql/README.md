## Downgrade the Mysql 8 to 5.7.39 (latest) 

Mysql 8 is slow even on after 2 years community report the bug. 
It is 4 to 5 times slower compare to 5.7 version. 

https://bugs.mysql.com/bug.php?id=97709 


### How to use 

Run with caution because this will **remove all your database** on the server.

![#f03c15](https://via.placeholder.com/15/f03c15/f03c15.png) Backup your data first before run this bash command!

```unix
wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/mysql/init_downgrade.sh | bash
``` 

Wait for the interactive modal along the process of this command. 

[ ] Select Ubuntu bionic 
[ ] Select Mysql 8 -> Select Mysql 5.7 -> Ok

The installation may take 5 to 10 minutes



