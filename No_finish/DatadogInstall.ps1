# Set the parameters
$FileName = "ddagent-cli-6.5.1.msi"
$DDFolder = 'C:\Source'
$MMAFile = $DDFolder + "\" + $FileName
$SMFile = $DDFolder + "\" + "ddagent-cli-6.5.1.msi"

Invoke-Command {

# Start logging the actions
Start-Transcript -Path C:\DDAgentInstallLog.txt -NoClobber

# Check if folder exists, if not, create it
 if (Test-Path $DDFolder){
 Write-Host "The folder $DDFolder already exists."
 } 
 else 
 {
 Write-Host "The folder $DDFolder does not exist, creating..." -NoNewline
 New-Item $DDFolder -type Directory | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }

# Change the location to the specified folder
Set-Location $DDFolder

# Downloading installer
 if (Test-Path $FileName){
 Write-Host "The file $FileName already exists."
 }
 else
 {
 Write-Host "The file $FileName does not exist, downloading..." -NoNewline
 $URL = "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli-6.5.1.msi"
 Invoke-WebRequest -Uri $URl -OutFile $MMAFile | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }

# Install the Datadog Agent
Write-Host "Installing Datadog Agent.." -nonewline
Start-Process msiexec.exe -Wait -ArgumentList '/I C:\source\ddagent-cli-6.5.1.msi /quiet'
#$ArgumentList = '/msiexec /qn /i "$DDfolder\ddagent-cli-6.5.1.msi"'
#$ArgumentList = -filepath 'c:\source\ddagent-cli-6.5.1.msi /S /AcceptEndUserLicenseAgreement:1'
#Start-Process $SMFileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
Write-Host "done!" -ForegroundColor Green

Stop-Transcript
}