$cred = get-credential
#$serverlist = Get-Content "c:\source\list.txt"
$serverlist = 'I10UATDB01.mbhosting.com', 'i10uatftp01.mbhosting.com', 'I10UATWEB01.mbhosting.com', 'I10UATWEB02.mbhosting.com', 'I10UATWEB03.mbhosting.com', 'I10UATWEB05.mbhosting.com'
#$sourcefile = "\\i10prdjump.mbhosting.com\dd\ddagent-cli-6.5.1.msi"
$sourcefile = "\\i10prdjump.mbhosting.com\dd"

foreach ($server in $serverlist)
{
Write-Host "Installing on $server"
Write-Host "Installing Datadog Agent.." -nonewline
# $destinationFolder = "\\$server\C$\Temp"
    #It will copy $sourcefile to the $destinationfolder. If the Folder does not exist it will create it.

#    if (!(Test-Path -path $destinationFolder))
 #   {
  #      New-Item $destinationFolder -Type Directory
  #  }
   # Copy-Item -Path $sourcefile -Destination $destinationFolder
    #Invoke-Command -ComputerName $server -ScriptBlock {Start-Process msiexec.exe -Wait -ArgumentList '/I c:\temp\ddagent-cli-6.5.1.msi /quiet'}
#invoke-command -computername $server -credential $cred -scriptblock {msiexec /qr /i "$sourcefile"}
#Invoke-Command -ComputerName $server -ScriptBlock {Start-Process msiexec.exe -Wait -ArgumentList '/I $sourcefile /quiet'}
#Start-Process msiexec.exe -Wait -ArgumentList '/I \\i10prdjump.mbhosting.com\dd\ddagent-cli-6.5.1.msi /quiet'
#$ArgumentList = '/msiexec /qn /i "$sourcefile"'
#Invoke-Command -FilePath .\DatadogInstallv2.ps1 -ComputerName $server -Credential $cred
PSExec \\RPC001 -u $cred -p myPWD PowerShell C:\script\StartPS.ps1 par1 par2
Write-Host "done!" -ForegroundColor Green
}