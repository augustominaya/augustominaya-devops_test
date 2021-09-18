#!/bin/bash
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done
sudo apt list --upgradable
sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 -y
sudo apt install php libapache2-mod-php php7.4-cli -y
sudo rm -rf /var/www/html
sudo git clone https://github.com/augustominaya/augustominaya_page.git /var/www/html
sudo chown -R ubuntu:www-data /var/www/html