#$cred = get-credential
$serverlist = Get-Content "c:\source\List.txt"

start-transcript

foreach ($server in $serverlist)
{
Write-Host "logging on $server"
mstsc ybarreto.rdp /v:$Server /f
Wait-Event -Timeout 45
}

stop-transcript
