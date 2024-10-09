# PowerShell script to bootstrap a Windows EC2 instance

cd C:\Users\Administrator\Desktop\
mkdir GoldenAmiFiles
DIR .\GoldenAmiFiles\
cd GoldenAmiFiles

$command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
Invoke-Expression $command

Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile C:\AWSCLIV2.msi
DIR C:\

$arguments = "\i `"C:\AWSCLIV2.msi`" /quiet"
Start-Process msiexec.exe -ArgumentList $arguments -Wait
Start-Process msiexec.exe -ArgumentList "/i C:\AWSCLIV2.msi /quiet" -Wait
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# aws s3 cp s3://ec2inspackagebucket0/window/sample-1.zip . --endpoint-url https://s3.us-east-1.amazonaws.com/
# Expand-Archive -Path sample-1.zip -Force

aws s3 cp s3://golden-ami-files/ECP-Falcon-Sensor-Packages/WindowsSensor.MaverickGyr.zip . --endpoint-url https://s3.us-west-2.amazonaws.com/
DIR . 
Expand-Archive -Path Falcon-7.18.0-WindowsSensor.MaverickGyr.zip -Force
Invoke-Expression C:\Users\Administrator\Desktop\GoldenAmiFiles\Falcon-7.18.0-WindowsSensor.MaverickGyr.exe
New-Item -Path C:\Users\Administrator\Desktop\GoldenAmiFiles\Falcon-7.18.0-WindowsSensor.MaverickGyr.exe -Force

Invoke-WebRequest -Uri "https://amazoncloudwatch-agent.s3.amazonaws.com/windows/amd64/latest/amazon-cloudwatch-agent.msi" -OutFile C:\Users\Administrator\Desktop\GoldenAmiFiles\amazon-cloudwatch-agent.msi
Dir .
Start-Process msiexec.exe -ArgumentList "/i C:\Users\Administrator\Desktop\GoldenAmiFiles\amazon-cloudwatch-agent.msi" -Wait

aws s3 cp s3://golden-ami-files/Downloads/Windows/agentInstaller-x86_64.msi --endpoint-url https://s3.us-west-2.amazonaws.com/
Dir .
msiexec /i agentInstaller-x86_64.msi /l*v insight_agent_install_log.log /quiet