# Server Automation by Openjournalteam ⭐
To help you setup you're server 😊
Include : Webmin, Apache server and others

## What this script does ?
- Installing Virtualmin with port 9191
- Registering Phpmyadmin as service so you can running it by executing this command and access it with port 9292 🆕
```unix
service pamin start
```
- Fail2ban integrated with mod_security
- Setup cron to automatically turn off webmin and pamin service
- Change timezone to Makassar
- Optimalization
- Disabled ssh login by password, only allow private key

## How to use ?
```unix
curl https://raw.githubusercontent.com/navotera/serverAutomation/master/init.sh | bash
```

## After success installing 
Access password on **server.config** or Change passsword 
```sudo -i passwd```  
Access the webmin to initiate the configuration 
https://ip_address:9191

## TODO
- [ ] Live Progress
- [ ] Select Feature
- [ ] Installing via screen


## TESTED ON
- Ubuntu 20.04 x64 ✔
- Ubuntu 20.10 x64 ❌ (virtualmin not compatible yet)
