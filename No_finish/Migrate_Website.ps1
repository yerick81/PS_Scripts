#Set variables
$Configfolder = 'C:\Windows\System32\inetsrv\backup'
$BackupFolder = 'C:\Sources'
$SiteFolder = 'C:\inetpub\wwwroot\Caribbean'
$NewSiteFolder = 'C:\Sources\Caribbean'
Start-Transcript -Path C:\Sources\MigrationLog.txt -NoClobber
Import-Module IISAdministration
#Stopping application pool
Stop-IISSite -Name "Carebbean" -Confirm
#Making backup
Backup-WebConfiguration -Name "Carebbean" 
Copy-Item -Path $ConfigFolder -Destination $BackupFolder -Recurse
Copy-item -Path $SiteFolder -Destination $BackupFolder -Recurse
Remove-Item -Path $SiteFolder* -Recurse -Force
Copy-item -Path $NewSiteFolder -Destination C:\inetpub\wwwroot -Recurse
Start-IISSite -Name "Carebbean"
Stop-Transcript