#!/bin/bash
clear
# date 12-10-2021
echo "L'installation de GLPI va commencer"
# Mise à jour des sources
# sudo apt update && sudo apt upgrade
# Installation de mysql server et client
sudo apt install -y mysql-server mysql-client
# mysql-creation table, user et droits
mysql -u root -p <<SQL
CREATE DATABASE glpi CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
SQL
# installer Apache
sudo apt install -y apache2 php php-mysql libapache2-mod-php
# intallation de modules PHP
sudo apt install -y php-json php-gd php-curl php-mbstring php-cas php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu
sudo apt-get install -y php7.4-intl
sudo apt-get install -y php7.4-bz2
sudo apt-get install -y php7.4-zip


# activation du module a2enmod
sudo a2enmod rewrite
# redémarage d'Apache
sudo systemctl reload apache2
# modification du fichier apache2.conf 
sudo cp -v /etc/apache2/apache2.conf /etc/apache2/apache2.conf.default
sudo cp -v apache2.conf /etc/apache2/apache2.conf
sudo cp -v glpi.conf /etc/apache2/conf-available/
# DEBUT conf PHP
# D ici à l etiquette  FIN CONF PHP, à trouver
# Recherchez l’emplacement du fichier de configuration PHP (installez au préalable mlocate et locate) :
# sudo updatedb
# locate php.ini
# Editez le fichier de configuration php.ini :
# sudo nano /etc/php/7.4/apache2/php.ini
# Quelques recommandations :
# file_uploads = On
# max_execution_time = 300
# memory_limit = 256M
# post_max_size = 32M
# max_input_time = 60
# max_input_vars = 4440
# FIN conf PHP
sudo service apache2 restart
# téléchargement de la dernière version de GLPI dans /tmp 
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/9.5.6/glpi-9.5.6.tgz
# extraction dans /tmp
tar -zxvf glpi-9.5.6.tgz 
# Déplacement de GLPI dans vers dossier racine de Apache 
sudo mv glpi /var/www/html/
# Atribuer à www-data le contrôle total sur le répertoire GLPI 
sudo chown -R www-data /var/www/html/glpi
# activation de la conf
sudo a2enconf glpi
# sudo systemctl reload apache2
# redémarrage du serveur apache
sudo service apache2 restart 
