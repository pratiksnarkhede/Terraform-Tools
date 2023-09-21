#!/bin/bash
sudo apt update
sudo apt-get install apache2 -y
sudo /etc/init.d/apache2 start
sudo systemctl enable apache2
cd /home/ubuntu
sudo git clone https://github.com/pratiksnarkhede/frontendcode.git
sudo rm -r /var/www/html/index.html 
sudo cp /home/ubuntu/frontendcode/* /var/www/html





