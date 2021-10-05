#!/bin/bash
#update
yum update -y
#install apache
yum install httpd -y
#start apache
systemctl start httpd
#enable os level server
systemctl enable httpd