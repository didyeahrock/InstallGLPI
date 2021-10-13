#!/bin/bash
clear
# date 13-10-2021
# this script will make an unattended install of GLPI, MySql and PHP 
echo "L'installation de GLPI va commencer"
# update and upgrade the packets
sudo apt update && sudo apt upgrade
# Install of  mysql server and client
echo "mysql-server mysql-server/root_password password P@ssw0rd" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password P@ssw0rd" | debconf-set-selections
sudo apt install -y mysql-server mysql-client
# mysql-creation table, user et droits
mysql -u root -p <<SQL
CREATE DATABASE glpi CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
SQL
# install of Apache server
sudo apt install -y apache2 php php-mysql libapache2-mod-php
# intall of PHP  modules 
sudo apt install -y php-json php-gd php-curl php-mbstring php-cas php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu
sudo apt-get install -y php7.4-intl
sudo apt-get install -y php7.4-bz2
sudo apt-get install -y php7.4-zip


# activation of the  a2enmod module
sudo a2enmod rewrite
# modification of the default apache2.conf file
sudo cp -v /etc/apache2/apache2.conf /etc/apache2/apache2.conf.default
sudo cp -v apache2.conf /etc/apache2/apache2.conf
sudo cp -v glpi.conf /etc/apache2/conf-available/
# Apache reload
sudo systemctl reload apache2
# download and extract of the last GLPI package to /tmp 
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/9.5.6/glpi-9.5.6.tgz
tar -zxvf glpi-9.5.6.tgz 
# Moving /tmp/glpi to the root folder of apache2 
sudo mv glpi /var/www/html/
# make www-data owner of GLPI folder
sudo chown -R www-data /var/www/html/glpi
# activation of the GLPI configuration
sudo a2enconf glpi
# reload apache
sudo service apache2 reload
# populating the GLPI/mySQL database
mysql -uglpi -pglpi glpi < /var/www/html/glpi/install/mysql/glpi-empty.sql
sudo chown -R www-data:www-data /var/www/html/glpi/
sudo php /var/www/html/glpi/bin/console db:install --db-host=127.0.0.1 --db-name=glpi --db-user=glpi --db-password=glpi --force --no-interaction
sudo chown -R www-data:www-data /var/www/html/glpi/
# launch Firefox with GLPI home page
firefox "http://localhost/glpi"


