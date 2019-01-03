#$cred = get-credential
$serverlist = Get-Content "c:\sources\List.txt"

start-transcript

foreach ($server in $serverlist)
{
Write-Host "logging on $server"
mstsc ybarreto.rdp /v:$Server /f
Wait-Event -Timeout 50
}

stop-transcript
