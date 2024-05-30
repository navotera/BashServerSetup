#!/bin/bash

REPO_URL="--branch apache2-nginx2 https://github.com/navotera/BashServerSetup.git"

cd /tmp && rm -rf BashServerSetup && git clone $REPO_URL

RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`


#!/bin/bash

echo "Select an option:"
echo "1. Install Apache2 with Virtualmin (default)"
echo "2. Install Nginx with Virtualmin"
#!/bin/bash

echo "Select an option:"
echo "1. Install Apache2 with Virtualmin (default)"
echo "2. Install Nginx with Virtualmin"

# Use the timeout command to give the user 10 seconds to input their choice
choice=$(timeout 10 bash -c 'read -p "Enter your choice (1 or 2, or press Enter for default) within 10 seconds: " input; echo $input')

# Set the default choice if no input is provided within 10 seconds
if [ -z "$choice" ]; then
    echo "No choice made within 10 seconds. Proceeding with the default option (1)."
    choice=1
fi

echo "You selected option $choice."






#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

apt install git -y

# wget -O - https://github.com/navotera/BashServerSetup/raw/master/app/modsecurity/v2/init.sh  | bash

add-apt-repository ppa:ondrej/php
add-apt-repository --yes --update ppa:deadsnakes/ppa
apt update 2>/dev/null >/dev/null
apt install software-properties-common -y
#add-apt-repository --yes --update ppa:ansible/ansible

# Update the SSH configuration file with the new timeout settings
sudo sed -i "/^ClientAliveInterval/c\ClientAliveInterval 4460" /etc/ssh/sshd_config
sudo sed -i "/^ClientAliveCountMax/c\ClientAliveCountMax 6" /etc/ssh/sshd_config


# Restart the SSH service to apply the changes
sudo systemctl restart ssh

echo "${GREEN}installing python 3.9 and 3.12..${NC}"
apt install python3.9 -y && apt install python3.12 -y
apt install python3-pip -y

#cd /usr/bin && ls -lrth python* && unlink python && ln -s /usr/bin/python3.12 python
#cd /usr/bin && ls -lrth python* && unlink python3 && ln -s /usr/bin/python3.12 python3

#harus direstart klo kd error 
service apport restart
systemctl restart systemd-timedated

echo "${GREEN}installing ansible..${NC}"
#apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/init.yml


sh /tmp/BashServerSetup/playbook/sh/create_server_config.sh 


# Handle the user's choice
case $choice in
    1)
        echo "Installing Apache2 with Virtualmin..."
        sh /tmp/BashServerSetup/playbook/sh/install_virtualmin_apache2.sh
        ;;
    2)
        echo "Installing Nginx with Virtualmin..."
        sh /tmp/BashServerSetup/playbook/sh/install_virtualmin_nginx.sh
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

#setup the swap for 1G
sudo swapoff /swapfile
sudo fallocate -l 2G /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab



apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/core.yml
apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/optimization.yml
apt install ansible -y && ansible-playbook /tmp/BashServerSetup/playbook/finalize.yml
sh /tmp/BashServerSetup/playbook/sh/finishing_all.sh


