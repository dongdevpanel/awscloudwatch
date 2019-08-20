#!/bin/bash
sudo apt-get update -y
sudo apt-get install awscli -y
sudo apt-get install ruby -y
sudo apt-get install wget -y
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb
aws configure set region ap-northeast-1
cd ~
#git clone https://github.com/dongdevpanel/awscloudwatch.git
echo {"agent":{"metrics_collection_interval": 60,"run_as_user": "root"},"logs":{"logs_collected":{"files":{"collect_list":[{"file_path": "/var/log/syslog","log_group_name": "web","log_stream_name": "{hostname}/syslog","timestamp_format" :"%b %d %H:%M:%S"}]}}}}>/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
#cp ~/awscloudwatch/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/
systemctl enable amazon-cloudwatch-agent.service
service amazon-cloudwatch-agent start

sudo apt-get install unzip libwww-perl libdatetime-perl -y
cd /opt
sudo wget  http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip
sudo unzip CloudWatchMonitoringScripts-1.2.1.zip
cd /opt/aws-scripts-mon
sudo cp awscreds.template awscreds.conf
sudo ./mon-put-instance-data.pl --mem-util --verify --verbose
sudo echo "*/5 * * * * root /opt/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/ --from-cron" >> /etc/crontab           
git clone https://github.com/dongdevpanel/awscloudwatch.git
chmod +x /home/ubuntu/awscloudwatch/cloudwatch-custom-metric-apache.sh
echo "*/1 * * * * root /home/ubuntu/awscloudwatch/cloudwatch-custom-metric-apache.sh">>/etc/crontab
sudo /etc/init.d/cron restart