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
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")