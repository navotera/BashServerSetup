# Server Automation by Openjournalteam ⭐
To help you setup your server 😊
Include : Webmin, Apache/Nginx server and others. 

- Integrated with ModSecurity 3 from source, choose upon installation prompt
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
- Registering Phpmyadmin as service so you can running it by executing this command and access it with port 9292 
```unix
service pamin start
```
- Fail2ban integrated with mod_security
- Setup cron to automatically turn off webmin and pamin service
- Change timezone to Makassar
- Optimalization
- Disabled ssh login by password, only allow private key

## How to use ?

It is recommended to use [screen](https://www.howtogeek.com/662422/how-to-use-linuxs-screen-command/) to inititate the installation process due to the installation may take more than 30 minutes (depend on computing power of server)

### Apache2/Nginx setup

1. Add your public ssh key first : 
```
mkdir ~/.ssh/ && touch ~/.ssh/authorized_keys 
```
```
vi ~/.ssh/authorized_keys
```

2. Download the script 

```unix
wget https://raw.githubusercontent.com/navotera/BashServerSetup/master/init.sh && chmod +x init.sh
```

3. Run the script in screen (it takes quite long to install all the things)
```unix 
apt install screen && screen
```

```unix
./init.sh | tee /var/log/bashServerSetup_install
```

4. Exit screen and you can leave the PC : 

CTRL+A+D 


5. Later if you want to enter the screen 
```
screen -r 
```

## Run specific ansible playbook : 
```unix
ansible-playbook /var/BashServerSetup/playbook/init.yml
```

## After success installing 
1. Access password on **server.config** or Change passsword ```sudo -i passwd```  
2. Change the hostname by using command ```hostname YOUR_HOSTNAME``` [optional]
3. Start the webmin ```service webmin start``` and access to **https://ip_address:9191**
4. PHPMyadmin Start by ```service pamin start``` access to **https://ip_address:9292**


## ModSecurity installation (if failed)
if you want install Modsecurity you can run this : 

```ansible-playbook /var/BashServerSetup/app/modsecurity/apache2/install.yml``` --> for **Apache**

```ansible-playbook /var/BashServerSetup/app/modsecurity/nginx/install.yml``` --> for **Nginx**


## TODO
- [ ] Live Progress
- [ ] Select Feature
- [ ] Installing via screen


## TESTED ON (Compatible with Ubuntu only)
- Ubuntu 24.04 x64 ✔
- Ubuntu 22.04 x64 ✔
- Ubuntu 20.04 x64 ✔
- Ubuntu 18.04 LTS x64 ✔
- Ubuntu 2X.10 x64 ❌ (virtualmin not compatible yet)


## Known issue : 
- On some case, installation of virtualmin may failed, you need to rerun the script from initiation. 


### Notes :

If you are using GCP server please follow this video to open port 9191 and 9292 : 
https://www.youtube.com/watch?v=XFxdECTpiEg
