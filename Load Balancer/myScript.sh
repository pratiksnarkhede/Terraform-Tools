#!/bin/bash
sudo yum update -y
sudo yum install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
echo “welcome to the webserver $(hostname -f)” > /var/www/html/index.html