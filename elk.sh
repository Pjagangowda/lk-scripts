#!/bin/bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install elasticsearch
systemctl start elasticsearch
ps -ef  | grep elasticsearch
netstat -anlp | grep ":9300"

cat <<EOT> nano /etc/elasticsearch/elasticsearch.yml
network.host : 0.0.0.0
discovery.type: single-node
EOT

systemctl restart elasticsearch
curl -X GET http://localhost:9200

apt-get update && apt-get install kibana
cat <<EOT> nano /etc/kibana/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
EOT

systemctl start kibana
ps -ef | grep kibana