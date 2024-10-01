# PowerShell script to bootstrap a Windows EC2 instance

# Log the script execution to a file
$LogFile = "C:\EC2BootstrapLog.txt"
Start-Transcript -Path $LogFile

# Update the system
Write-Output "Starting Windows Update..." | Tee-Object -FilePath $LogFile
Install-WindowsUpdate -AcceptAll -AutoReboot

# Install Chocolatey (Windows package manager)
Write-Output "Installing Chocolatey..." | Tee-Object -FilePath $LogFile
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install required packages (for example, Git and 7-Zip)
Write-Output "Installing Git and 7-Zip..." | Tee-Object -FilePath $LogFile
choco install git -y
choco install 7zip -y

# Install IIS (Internet Information Services)
Write-Output "Installing IIS..." | Tee-Object -FilePath $LogFile
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Optional: Configure IIS (create a default webpage)
Write-Output "Creating a default webpage..." | Tee-Object -FilePath $LogFile
$DefaultPageContent = @"
<html>
<head>
<title>Welcome to Your EC2 Windows Instance</title>
</head>
<body>
<h1>Hello from EC2!</h1>
<p>This is a default page served by IIS on your Windows EC2 instance.</p>
</body>
</html>
"@
$DefaultPagePath = "C:\inetpub\wwwroot\index.html"
$DefaultPageContent | Out-File -FilePath $DefaultPagePath

# Set TimeZone (optional, change as needed)
Write-Output "Setting time zone to UTC..." | Tee-Object -FilePath $LogFile
Set-TimeZone -Id "UTC"

# Download and install EC2Launch or EC2Launch v2 (for managing Windows instances)
Write-Output "Installing EC2Launch for Windows EC2 instances..." | Tee-Object -FilePath $LogFile
Invoke-WebRequest -Uri "https://s3.amazonaws.com/ec2-downloads-windows/EC2Launch/latest/EC2Launch.msi" -OutFile "C:\EC2Launch.msi"
Start-Process "msiexec.exe" -ArgumentList "/i C:\EC2Launch.msi /quiet /norestart" -Wait

# Reboot to apply updates and configurations (optional)
Write-Output "Rebooting instance to apply changes..." | Tee-Object -FilePath $LogFile
Restart-Computer -Force

# End logging
Stop-Transcript
