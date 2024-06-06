# Server Automation by Openjournalteam ⭐
To help you setup you're server 😊
Include : Webmin, Apache server and others. 

- Integrated with ModSecurity 2.9.6 from source (automatically enabled) 
  To disable add : `SecRuleEngine Off` to the virtualhost
- Fail2ban
- Server Optimization
- php installation from 7.3 to 8.1

Example to disable : 
`SecRuleEngine Off`

## What this script does ?
- Installing Virtualmin with port 9191
```unix
service webmin start
```
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

### Apache2 & Nginx Server

```unix
wget https://raw.githubusercontent.com/navotera/BashServerSetup/apache2-nginx2/init.sh && chmod +x init.sh && ./init.sh | tee /var/log/bashServerSetup_install.log

```

### NGINX Server
```unix
same, just use pick nginx as webserver option on installation process
```

## Run specific ansible playbook : 
```unix
ansible-playbook /var/BashServerSetup/playbook/init.yml
```

## After success installing 
1. Access password on **server.config** or Change passsword ```sudo -i passwd```  
2. Change the hostname by using command ```hostname YOUR_HOSTNAME``` [optional]
3. Start the webmin ```service webmin start``` and access to https://ip_address:9191


## ModSecurity installation [Optional]
if you want install Modsecurity you can run this : 
```ansible-playbook /tmp/BashServerSetup/app/modsecurity/apache2/install.yml``` --> for **Apache**
```ansible-playbook /tmp/BashServerSetup/app/modsecurity/nginx/install.yml``` --> for **Nginx**


## TODO
- [ ] Live Progress
- [ ] Select Feature
- [ ] Installing via screen


## TESTED ON (Compatible with Ubuntu only)
- Ubuntu 22.04 x64 ✔
- Ubuntu 20.04 x64 ✔
- Ubuntu 18.04 LTS x64 ✔
- Ubuntu 2X.10 x64 ❌ (virtualmin not compatible yet)

### Notes :

If you are using GCP server please follow this video to open port 9191 and 9292 : 
https://www.youtube.com/watch?v=XFxdECTpiEg
