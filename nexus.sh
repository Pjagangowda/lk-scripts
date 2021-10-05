#!/bin/bash
cd /opt
#install java 
sudo yum install java-1.8.0-openjdk.x86_64 -y
#nexus setup
wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.0.2-02-unix.tar.gz
#untar
tar -zxvf nexus-3.0.2-02-unix.tar.gz
#rename
mv /opt/nexus-3.0.2-02 /opt/nexus
#create the user
sudo adduser nexus
# visudo \\ nexus ALL=(ALL) NOPASSWD: ALL
sudo chown -R nexus:nexus /opt/nexus
#run as a parameter
cat <<EOT> /opt/nexus/bin/nexus.rc
run_as_user="nexus"
EOT
#nexus as a service at boot time
cd /opt
#sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
#login to nexus user
su - nexus 
service nexus start
service nexus enable