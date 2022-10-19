 #location : /etc/apache2/modsecurity.d/init.sh
 #put in /etc/apache2/apache2.conf 
 #after load the security2.so
 #
 #LoadModule security2_module /usr/lib/apache2/modules/mod_security2.so
 #Include /etc/apache2/modsecurity.d/init.conf
 

 
 <IfModule security2_module>
        	SecDataDir /var/cache/modsecurity
            
            SecPcreMatchLimit 150000
			SecPcreMatchLimitRecursion 150000
            
        	Include "/etc/apache2/modsecurity.d/modsecurity2.conf"
        	Include "/etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf"
        	Include "/etc/apache2/modsecurity.d/owasp-crs/rules/*.conf"
 </IfModule>