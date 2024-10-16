#!/bin/bash
apt update
apt install -y apache2
curl http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
