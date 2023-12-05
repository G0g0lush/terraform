#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable --now httpd
echo 'Greetings!' > /var/www/html/index.html
sudo systemctl restart httpd