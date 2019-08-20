#!/bin/bash
aws configure set region us-east-1
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
sudo systemctl status apache2.service | grep running >> /dev/null
if [ $? -eq 0 ]
then
aws cloudwatch put-metric-data --metric-name 'apache2-status' --unit Count --value 1 --dimensions InstanceId=$INSTANCE_ID --namespace EC2:Apache2 \
else
aws cloudwatch put-metric-data --metric-name 'apache2-status' --unit Count --value 0 --dimensions InstanceId=$INSTANCE_ID --namespace EC2:Apache2 \
fi