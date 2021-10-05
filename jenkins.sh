#!/bin/bash
cd /opt
apt update -y
#java installation
apt install openjdk-11-jre-headless -y
#start the java
#rpm -ivh jdk-8u131-linux-x64.rpm
#install jenkins in ubuntu
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt upgrade -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl status jenkins
systemctl enable jenkins