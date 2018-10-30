$sourcefile = "\\i10prdjump.mbhosting.com\dd\ddagent-cli-6.5.1.msi"
Write-Host "Installing on $server"
Write-Host "Installing Datadog Agent.." -nonewline
 $destinationFolder = "C:\Temp"
    It will copy $sourcefile to the $destinationfolder. If the Folder does not exist it will create it.

    if ((Test-Path -path $destinationFolder))
    {
        New-Item $destinationFolder -Type Directory
    }
    Copy-Item -Path $sourcefile -Destination $destinationFolder
    Invoke-Command -ComputerName $server -ScriptBlock {Start-Process msiexec.exe -Wait -ArgumentList '/I c:\temp\ddagent-cli-6.5.1.msi /quiet'}
Write-Host "done!" -ForegroundColor Green