﻿# Unnistall 24x7 Agent on Windows
$app = Get-WmiObject -Class Win32_Product | Where-Object { 
    $_.Name -match "Site24x7 Windows Agent" 
}

$app.Uninstall()


<#
Author:		Daniel Örneling
Date:		20/6/2017
Script:  	InstallOMSAgentwithServiceMap.ps1
Version: 	1.0
Twitter: 	@DanielOrneling
#>

# Set the Workspace ID and Primary Key for the Log Analytics workspace.
$WorkSpaceID = 'be0b55d2-84de-49f2-95ae-f4739a4465dd'
$WorkSpaceKey = 'qwlgA7IcEHjdemejAxZuqe2Y8/3nmO+kXxa4unT5RUluRG+wckAQY8X2sVrT0hhXeKnrsNyWkT+cnPsZLWPgLw=='


# Set the parameters
$FileName = "MMASetup-AMD64.exe"
$SMFileName = "InstallDependencyAgent-Windows.exe"
$OMSFolder = 'C:\Source'
$MMAFile = $OMSFolder + "\" + $FileName
$SMFile = $OMSFolder + "\" + $SMFileName

Invoke-Command

# Start logging the actions
Start-Transcript -Path C:\OMSAgentInstallLog.txt -NoClobber

# Check if folder exists, if not, create it
 if (Test-Path $OMSFolder){
 Write-Host "The folder $OMSFolder already exists."
 } 
 else 
 {
 Write-Host "The folder $OMSFolder does not exist, creating..." -NoNewline
 New-Item $OMSFolder -type Directory | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }

# Change the location to the specified folder
Set-Location $OMSFolder

# Check if Microsoft Monitoring Agent file exists, if not, download it
 if (Test-Path $FileName){
 Write-Host "The file $FileName already exists."
 }
 else
 {
 Write-Host "The file $FileName does not exist, downloading..." -NoNewline
 $URL = "http://download.microsoft.com/download/1/5/E/15E274B9-F9E2-42AE-86EC-AC988F7631A0/MMASetup-AMD64.exe"
 Invoke-WebRequest -Uri $URl -OutFile $MMAFile | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }

# Check if Service Map Agent exists, if not, download it
 if (Test-Path $SMFileName){
 Write-Host "The file $SMFileName already exists."
 }
 else
 {
 Write-Host "The file $SMFileName does not exist, downloading..." -NoNewline
 $URL = "https://aka.ms/dependencyagentwindows"
 Invoke-WebRequest -Uri $URl -OutFile $SMFile | Out-Null
 Write-Host "done!" -ForegroundColor Green
 } 
 
# Install the Microsoft Monitoring Agent
Write-Host "Installing Microsoft Monitoring Agent.." -nonewline
$ArgumentList = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+  "OPINSIGHTS_WORKSPACE_ID=$WorkspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$WorkSpaceKey " +'AcceptEndUserLicenseAgreement=1"'
Start-Process $FileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
Write-Host "done!" -ForegroundColor Green

# Install the Service Map Agent
Write-Host "Installing Service Map Agent.." -nonewline
$ArgumentList = '/C:"InstallDependencyAgent-Windows.exe /S /AcceptEndUserLicenseAgreement:1"'
Start-Process $SMFileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
Write-Host "done!" -ForegroundColor Green

# Change the location to C: to remove the created folder
Set-Location -Path "C:\"

<#
# Remove the folder with the agent files
 if (-not (Test-Path $OMSFolder)) {
 Write-Host "The folder $OMSFolder does not exist."
 } 
 else 
 {
 Write-Host "Removing the folder $OMSFolder ..." -NoNewline
 Remove-Item $OMSFolder -Force -Recurse | Out-Null
 Write-Host "done!" -ForegroundColor Green
 }
#>

Stop-Transcript
}