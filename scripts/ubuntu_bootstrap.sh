#!/bin/bash

# Update the package manager
sudo apt update -y

# Install Apache2 (httpd)
sudo apt install -y apache2

# Start the Apache2 service
sudo systemctl start apache2

# Enable the Apache2 service to start on boot
sudo systemctl enable apache2

# Check the status of the Apache2 service
sudo systemctl status apache2