#!/bin/bash

# Update the package list
sudo dnf update -y

# Upgrade installed packages
sudo dnf upgrade -y

sudo aws s3 cp s3://ecpops-golden-ami-packages/falcon-sensor-7.18.17106.amzn2023.x86_64.rpm . --endpoint-url https://s3.us-west-2.amazonaws.com/
#sudo aws s3 cp s3://ec2inspackagebucket0/amazon/httpd-2.4.62-4.el10.aarch64.rpm . --endpoint-url https://s3.us-east-1.amazonaws.com/

sudo mv falcon-sensor-7.18.17106.amzn2023.x86_64.rpm falcon-sensor.rpm
sudo dnf install -y falcon-sensor.rpm
/opt/CrowdStrike/falconctl -s --cid=19FAA56E74E45168D31C1236336B32C-43 -f --provisioning-token=70E1E59B --tags="Axia"
systemctl start falcon-sensor
echo "$(systemctl status falcon-sensor)"
/opt/CrowdStrike/falconctl -g --version
sudo rm -rf falcon-sensor.rpm
sudo dnf -y install amazon-cloudwatch-agent
cd /opt/aws/amazon-cloudwatch-agent/bin/
mkdir -p /usr/share/collectd/
touch /usr/share/collectd/types.db
sudo amazon-linux-extras install collectd
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm: AmazonCloudWatch-linux
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo aws s3 cp s3://golden-ami-files/Downloads/Linux/agent_installer.sh . --endpoint-url https://s3.us-west-2.amazonaws.com/
chmod +x agent_installer.sh
sudo ./agent_installer.gh install_start --token us: f93dle2d-151c-499e-9809-384efb9abc91