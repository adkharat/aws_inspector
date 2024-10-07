#!/bin/bash

sudo su
cd /tmp
apt-get update && apt-get upgrade -y
# rm /var/lib/dpkg/lock-frontend
# rm /var/lib/dpkg/lock
# dpkg --configure -a
apt install curl unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
./aws/install --update
aws s3 cp s3://golden-ami-files/ECP-Falcon-Sensor-Packages/falcon-sensor_7.18.0-17106_amd64.deb . --endpoint-url https://s3.us-west-2.amazonaws.com/
#aws s3 cp s3://imagebuilderec2infralog0/percona-xtrabackup-80_8.0.26-18-1.focal_amd64.deb . --endpoint-url https://s3.us-east-1.amazonaws.com/
mv falcon-* falcon-sensor.deb
chmod +x falcon-sensor.deb
dpkg -i falcon-sensor.deb
/opt/CrowdStrike/falconctl -s --cid=2E90DC4F9AF2406CA2363D68D4FB8F83-81 -f --provisioning-token=B26B63CF
sudo systemcti start falcon-sensor 
sudo systemctl status falcon-sensor
sudo aws s3 cp s3://golden-ami-files/Downloads/Linux/agent_installer.sh . --endpoint-url https://s3.us-west-2.amazonaws.com/
chmod +x agent_installer.sh
sudo ./agent_installer.gh install_start --token us: f93dle2d-151c-499e-9809-384efb9abc91
sudo wget https://33.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
apt-get update