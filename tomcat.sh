#!bin/bash
apt update -y
cd /opt
#download  the java 
apt install openjdk-8-jre-headless -y
# istall the java with 
#rpm -ivh jdk-8u131-linux-x64.rpm
# install tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.11/bin/apache-tomcat-10.0.11-windows-x64.zip
#unzip the tomcat
apt install unzip -y
unzip apache-tomcat-10.0.11-windows-x64.zip
#rename tomcat
mv apache-tomcat-10.0.11 tomcat10
# change the permissions
chmod -R 700 tomcat10
# remove the zip file
rm -rf apache-tomcat-10.0.11-windows-x64.zip
#change the path
cd /opt/tomcat10/bin/
# start the apache  pre req is the java for the tomacat
./startup.sh