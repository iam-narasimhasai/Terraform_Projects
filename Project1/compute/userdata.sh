#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<center><h1>This message from webserver : $(hostname -i)</h1></center>" > /var/www/html/index.html