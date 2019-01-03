#Set variables
$Site = 'directv.com.co' 
$Configfolder = 'C:\Windows\System32\inetsrv\backup'
$BackupFolder = 'D:\SecureSite\Backup_BeforeSecure\Colombia'
$SiteFolder = 'D:\Deployment\PublicSite\Colombia'
$NewSiteFolder = 'D:\SecureSite\Secure_Sources\Colombia\*'
Start-Transcript -Path D:\SecureSite\Backup_BeforeSecure\Colombia\MigrationLog.txt -NoClobber
#Stopping and disabling applications
Write-host "Disabling the tasks and processes..." -Foregroundcolor Red
Stop-ScheduledTask -taskname "SyncDirectvlaFromMasterDrive"
Stop-ScheduledTask -taskname "SyncOnDirectvFromMasterDrive"
Stop-ScheduledTask -taskname "SyncPublicSiteFromMasterDrive"
Disable-ScheduledTask -TaskName "AppPoolStart"
Disable-ScheduledTask -TaskName "SyncDirectvlaFromMasterDrive"
Disable-ScheduledTask -TaskName "SyncOnDirectvFromMasterDrive"
Disable-ScheduledTask -TaskName "SyncPublicSiteFromMasterDrive"
Stop-Process -name "Robocopy"
Import-Module IISAdministration
#Stopping application pool
Stop-IISSite -Name "$Site" -Confirm
Write-Host "The Application pool $Site is DOWN" -ForegroundColor Red
#Making backup
Write-Host "Making backup of the site $Site..." -ForegroundColor Green
Backup-WebConfiguration -Name "$Site" 
Copy-Item -Path $ConfigFolder -Destination $BackupFolder -Recurse
Copy-item -Path $SiteFolder -Destination $BackupFolder -Recurse
Write-Host "The backup has finished successfully" -ForegroundColor Green
Write-Host "Wait I am migrating the site..." -ForegroundColor Green
Remove-Item -Path $SiteFolder\* -Recurse -Force
Copy-item "$NewSiteFolder" -Destination "$SiteFolder" -Recurse
Start-IISSite -Name "$Site"
Write-Host "The Application pool $Site is UP" -ForegroundColor Green
Write-Host "The Site $Site has been migrated successfully" -ForegroundColor Green
Stop-Transcript