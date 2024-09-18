#!/bin/bash

# Update the package manager
sudo yum update -y

# Install httpd (Apache)
sudo yum install -y httpd

# Start the httpd service
sudo systemctl start httpd

# Enable the httpd service to start on boot
sudo systemctl enable httpd