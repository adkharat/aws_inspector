#!/bin/bash

# Update the package manager
sudo apt update -y

#SSM Agent is installed, by default, on Ubuntu Server 22.04 LTS(reinstall the agent)
#sudo snap install amazon-ssm-agent --classic

#determine if SSM Agent is running.
#sudo snap list amazon-ssm-agent

#start ssm-agent
#sudo snap start amazon-ssm-agent

#Check the status of the agent.
sudo snap services amazon-ssm-agent