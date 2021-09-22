#!/bin/bash
clear
echo "L'installation de GLPI va commencer"
# Mise à jour des sources
sudo apt update && sudo apt upgrade
# Installation de mysql server et client
sudo apt install mysql-server mysql-client
# mysql-creation table, user et droits
mysql -u root -p <<SQL
CREATE DATABASE glpi CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
SQL
# installer Apache
sudo apt install apache2 php php-mysql libapache2-mod-php
# intallation de modules PHP
sudo apt install php-json php-gd php-curl php-mbstring php-cas php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu
# activation du module a2enmod
sudo a2enmod rewrite
# redémarage d'Apache
sudo systemctl restart apache2
# modification du fichier apache2.conf 
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.default
sudo cp /home/didier/Documents/InstallGLPI/apache2.conf /etc/apache2/apache2.conf

