# Mod Security Version 2.9.6

Install from source, why using version 2.9.6 ? 
Because in Modsecurity 3 there still an error when activated "Bridge error" 
Why compile from source ? 

Because when installing the modsecurity from Ubuntu it is outdate and have critical security issue


- unicode.mapping for modsec 2
  To disable add : `SecRuleEngine Off` to the virtualhost
- crs latest


Example to disable : 
    SecRuleEngine Off


## What this script does ?
- Installing Modsecurity version 2.9.6 using ansible 


## How to use ?
```unix
wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash
```

## After success installing 
- Folder /etc/apache2/modsecurity.d created!
- Add line in /etc/apache2/apache2.conf to load the module 
- Place new file to location: /usr/lib/apache2/modules/mod_security2.so


## TESTED ON
- Ubuntu 20.04 x64 ✔
- Ubuntu 18.04 LTS x64 ✔ (need to test)



### Notes : 
