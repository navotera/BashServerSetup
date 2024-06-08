#!/bin/bash

REPO_URL="https://github.com/navotera/BashServerSetup.git"
BASE_FOLDER="/var/BashServerSetup/"
INSTALL_MODSECURITY="n"

rm -rf $BASE_FOLDER && mkdir -p $BASE_FOLDER && cd /var && git clone $REPO_URL


RED=`tput setaf 1`
NC=`tput sgr0` # No Color
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
MAGENTA=$(tput setaf 5)
GREY=$(tput setaf 7)  #

echo "Select an option:"
echo "1. Install ${YELLOW}Apache2${NC} with Virtualmin (default)"
echo "2. Install ${GREEN}Nginx${NC} with Virtualmin"

# Give the user 3 seconds to input their choice
echo -n "Enter your choice (1 or 2, or press Enter for default) within 10 seconds: "
read -r -t 10 choice

# Set the default choice if no input is provided within 3 seconds
if [ -z "$choice" ]; then
    echo "No choice made within 3 seconds. Proceeding with the default option (1)."
    choice=1
else
    echo "" # Add a newline after the countdown
fi


prompt_install_modsecurity() {
    while true; do
        read -t 10 -p "${YELLOW}Do you want to install ModSecurity also?${NC} (${GREEN}y${NC}/${RED}n${NC} select in 10 seconds default n): " yn
        yn=${yn:-n}  # Default to "n" if no input is provided within 20 seconds
        yn=$(echo "$yn" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase

        if [[ "$yn" == "y" || "$yn" == "n" ]]; then
            INSTALL_MODSECURITY=$yn
            break
        else
            echo "Invalid input. Please answer 'y' or 'n'."
        fi
    done
}



prompt_install_modsecurity



#in ubuntu 22.04 should change this to disable interactive mode that stop automatic process in this script
sed -i 's/#$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

apt install git -y

add-apt-repository --yes ppa:ondrej/php 
add-apt-repository --yes ppa:deadsnakes/ppa


case $choice in   
    2)
        sudo add-apt-repository -y ppa:ondrej/nginx    
esac

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

sudo apt update

echo "${GREEN}setup server config file${NC}"
sh ${BASE_FOLDER}playbook/sh/create_server_config.sh 


#preparing install the virtualmin 
#hostname started with number is invalid, so add "a"
HostName=$(grep '^HOSTNAME=' ~/server.config | cut -d'=' -f2)
sudo wget -O ${BASE_FOLDER}install_virtualmin.sh http://software.virtualmin.com/gpl/scripts/install.sh
hostName=${HostName}


apt install ansible -y

# Handle the user's choice
case $choice in
    1)
        echo "${YELLOW}Installing Apache2 with Virtualmin...${hostName}${NC}"        
        VIRTUALMIN_NONINTERACTIVE=1 /bin/sh ${BASE_FOLDER}install_virtualmin.sh --minimal --force --hostname "$hostName"        
        ansible-playbook ${BASE_FOLDER}playbook/apache2_optimization.yml
        ;;
    2)
        echo "${GREEN}Installing Nginx with Virtualmin...with ${hostName} ${NC}"        
        apt-get install -y nginx
        VIRTUALMIN_NONINTERACTIVE=1 /bin/sh ${BASE_FOLDER}install_virtualmin.sh --minimal --force --hostname "$hostName" -b LEMP
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac




echo "${GREEN}Core Setup${NC}"
ansible-playbook ${BASE_FOLDER}playbook/core.yml

echo "${GREEN}Optimizing.${NC}"
ansible-playbook ${BASE_FOLDER}playbook/optimization.yml


echo "${GREEN}Setup Pamin.${NC}"
ansible-playbook ${BASE_FOLDER}playbook/pamin.yml


echo "${GREEN}Finalizing.${NC}"
ansible-playbook ${BASE_FOLDER}playbook/finalize.yml

# Function to install ModSecurity
echo "${GREEN} Installing modsecurity ${NC}"

install_modsecurity() {
    if [[ $INSTALL_MODSECURITY == "y" ]]; then
        if systemctl status apache2 >/dev/null 2>&1; then          
            ansible-playbook ${BASE_FOLDER}app/modsecurity/apache2/install.yml
        elif systemctl status nginx >/dev/null 2>&1; then            
            ansible-playbook ${BASE_FOLDER}app/modsecurity/nginx/install.yml
        else
            echo "${RED}No supported web server detected (Apache2 or Nginx).${NC}"
            echo "${YELLOW} Try to run this script again ${NC}"
        fi
    else
        echo "Skipping ModSecurity installation."
    fi
}

install_modsecurity


sh ${BASE_FOLDER}playbook/sh/finishing_all.sh





