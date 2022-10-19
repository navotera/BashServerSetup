# Mod Security Version 2.9.6

Install from source, why using version 2.9.6 ? 
Because in Modsecurity 3 there still an error when activated "Bridge error" 


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


## TESTED ON
- Ubuntu 20.04 x64 ✔
- Ubuntu 18.04 LTS x64 ✔
- Ubuntu 20.10 x64 ❌ (virtualmin not compatible yet)


### Notes : 
