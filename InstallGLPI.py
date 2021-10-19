#!/usr/bin/python3
"""
    Script pour Installer GLPI
"""
# importations libraries
import os
os.system("apt update ; apt upgrade")
# Install mysql server
"""
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password P@ssw0rd'
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password P@ssw0rd'
"""
os.system("apt install -y mysql-server")
"""
    # mysql-creation table, user et droits
    mysql -uroot -pP@ssw0rd <<SQL
    CREATE DATABASE glpi CHARACTER SET UTF8 COLLATE UTF8_BIN;
    CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
    GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
    FLUSH PRIVILEGES;
    SQL
"""
# install Apache server
os.system("apt install -y apache2 php php-mysql libapache2-mod-php")
# intall of PHP  modules 
os.system("apt install -y php-json php-gd php-curl php-mbstring php-cas php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu")
os.system("apt-get install -y php7.4-intl")
os.system("apt-get install -y php7.4-bz2")
os.system("apt-get install -y php7.4-zip")
# activation of the  a2enmod module
os.system("a2enmod rewrite")
# modification of the default apache2.conf file
"""
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
"""