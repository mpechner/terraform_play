#!/usr/bin/env bash
yum update -y
yum install -y httpd
cat '<html><body><h1>' >/var/www/html/index.html
curl curl http://169.254.169.254/latest/meta-data/hostname >> /var/www/html/index.html
cat '</h1></body></html>' >> /var/www/html/index.html

service httpd restart