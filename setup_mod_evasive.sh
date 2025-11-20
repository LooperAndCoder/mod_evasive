#!/bin/bash

# Script to install mod_evasive on Amazon Linux 2023

# Install required packages
sudo dnf groupinstall "Development Tools" -y
sudo dnf install httpd-devel git -y

# Clone mod_evasive repository
cd /usr/local/src
sudo git clone https://github.com/LooperAndCoder/mod_evasive.git
cd mod_evasive

# Generate configuration and copy it
bash mod_evasive_conf_generator.sh
sudo cp mod_evasive.conf /etc/httpd/conf.d/

# Create log directory and set permissions
sudo mkdir -p /var/log/mod_evasive
sudo chown apache:apache /var/log/mod_evasive

# Build and install mod_evasive
sudo apxs -i -a -c mod_evasive20.c

# 403 page setup and configuration
bash setup_global_403.sh

# Restart Apache HTTP server
sudo systemctl restart httpd

# Verify mod_evasive is loaded
httpd -M | grep evasive
#mod_evasive installation on amazon 2023

# sudo dnf groupinstall "Development Tools" -y
# sudo dnf install httpd-devel git -y
# sudo dnf install httpd-devel -y

# cd /usr/local/src
# sudo git clone https://github.com/LooperAndCoder/mod_evasive.git
# cd mod_evasive
# bash mod_evasive_conf_generator.sh 
# cp mod_evasive.conf /etc/httpd/conf.d/
# sudo mkdir -p /var/log/mod_evasive
# sudo chown apache:apache /var/log/mod_evasive

# sudo apxs -i -a -c mod_evasive20.c
# bash setup_global_403.sh 
# sudo systemctl restart httpd

# httpd -M | grep evasive
