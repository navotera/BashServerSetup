## Downgrade the Mysql 8 to 5.7.39 (latest) 

Mysql 8 is slow even on after 2 years community report the bug. 
It is 4 to 5 times slower compare to 5.7 version. 

https://bugs.mysql.com/bug.php?id=97709 


### How to use 

**Run with caution because this will <span style="color: red"> remove all your database </span> on the server.** 

<span style="color: red"> Backup your data first before run this bash command!</span>


`wget https://github.com/navotera/BashServerSetup/raw/master/app/mysql/downgrade_mysql.sh | bash` 

Wait for the interactive modal along the process of this command. 

The installation may take 5 to 10 minutes



