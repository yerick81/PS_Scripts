 # Unnistall 24x7 Agent on Windows
$app = Get-WmiObject -Class Win32_Product | Where-Object { 
$_.Name -match "Site24x7 Windows Agent" 
}
$ComputerName=$env:COMPUTERNAME
if ($app)
    {Write-Host "24x7 Agent Present on" $ComputerName}
else {Write-Host "24x7 not Installed on" $ComputerName}

try
{
    $app.Uninstall()
}
Catch
{
    Write-Host $ComputerName "Agent was not installed"
    Break
}

if ($app)
{
    Write-Host "24x7 Agent uninstalled successful on " $ComputerName -ForegroundColor Green
}
 
 