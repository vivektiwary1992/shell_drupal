#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install tasksel -y
sudo tasksel install lamp-server

sudo mysql -u root -padmin -e "CREATE DATABASE drupal CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
sudo mysql -u root -padmin -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON drupal.* TO ‘drupaluser’@’localhost’ IDENTIFIED BY 'root';"

wget https://ftp.drupal.org/files/projects/$1.tar.gz
tar -zxf $1.tar.gz
sudo mkdir /var/www/html/drupal

sudo cp -R $1/* $1/.htaccess /var/www/html/drupal
sudo mkdir /var/www/html/drupal/sites/default/files
sudo chown www-data:www-data /var/www/html/drupal/sites/default/files
sudo cp /var/www/html/drupal/sites/default/default.settings.php /var/www/html/drupal/sites/default/settings.php
sudo chown www-data:www-data /var/www/html/drupal/sites/default/settings.php
sudo systemctl restart apache2
sudo sed -i '172s/.*/        AllowOverride All/' /etc/apache2/apache2.conf
sudo systemctl restart apache2
