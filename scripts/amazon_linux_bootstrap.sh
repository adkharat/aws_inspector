#!/bin/bash

# Update the package list
sudo dnf update -y

# Upgrade installed packages
sudo dnf upgrade -y

aws s3 cp s3://ecpops-golden-ami-packages/falcon-sensor-7.18.17106.amzn2023.x86_64.rpm . --endpoint-url https://s3.us-west-2.amazonaws.com/

rm falcon-sensor-7.18.17106.amzn2023.x86_64.rpm

cd /tmp