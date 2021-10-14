#!/bin/bash
clear
# date 13-10-2021
# this script will make an unattended UNinstall of GLPI, MySql and PHP 
while true; do
    read -p "Do you want to UNinstall GLPI ? Enter y (yes) or n (no) and press Enter  => " yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
sudo apt remove -y mysql-server 
sudo apt remove -y apache2
sudo apt remove -y php
sudo apt remove -y php-mysql
sudo apt remove -y libapache2-mod-php
sudo apt remove -y php-json php-gd php-curl php-mbstring php-cas php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu
sudo apt-get remove -y php7.4-intl
sudo apt-get remove -y php7.4-bz2
sudo apt-get remove -y php7.4-zip

sudo rm -R /etc/apache2
sudo rm -R /tmp/*
sudo rm -R /var/www/html/glpi
sudo reboot

