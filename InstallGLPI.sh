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
