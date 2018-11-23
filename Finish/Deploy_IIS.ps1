# Set the variables
$WPIFileName = "WebPlatformInstaller_amd64_en-US.msi"
$Folder = 'C:\Sources'
$WPIFile = $Folder + "\" + $WPIFileName

Start-Transcript -Path C:\Sources\InstallingLog.txt -NoClobber
#To install IIS from zero
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
#To install IIS from a config file (The configuration file is created by clicking Export configuration settings on the Confirm installation selections page of the arfw in Server Manager.)
#Install-WindowsFeature -ConfigurationFilePath d:\ConfigurationFiles\ADCSConfigFile.xml
Get-WindowsFeature -Name Web* | Where-Object Installed
Get-Module -Name WebAdministration -ListAvailable
      Get-Command -Module webadministration |      Measure-Object |      Select-Object count
Update-Help
Update-Module

# Check if folder exists, if not, create it
 if (Test-Path $Folder){
 Write-Host "The folder $Folder already exists."
 } 
 else 
 {
 Write-Host "The folder $Folder does not exist, creating..." -NoNewline
 New-Item $Folder -type Directory | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }

# Change the location to the specified folder
Set-Location $Folder

# Check if Web Platform Installer file exists, if not, download it
 if (Test-Path $WPIFileName){
 Write-Host "The file $WPIFileName already exists."
 }
 else
 {
 Write-Host "The file $WPIFileName does not exist, downloading..." -NoNewline
 $URL = "https://go.microsoft.com/fwlink/?LinkId=287166"
 Invoke-WebRequest -Uri $URl -OutFile $WPIFile | Out-Null
 Write-Host "done!" -ForegroundColor Green
 } 
 
# Install Web Platform
Write-Host "Installing Web Plantform.." -nonewline
Invoke-Command -ScriptBlock { & cmd /c "msiexec.exe /i $WPIFile" /qn ADVANCED_OPTIONS=1 CHANNEL=100}
Write-Host "done!" -ForegroundColor Green

# Enabling URLRewrite
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
choco.exe feature enable --name=allowGlobalConfirmation --yes
choco.exe install urlrewrite

Stop-Transcript