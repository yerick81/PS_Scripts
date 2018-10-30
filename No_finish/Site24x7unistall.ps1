# Unnistall 24x7 Agent on Windows
$app = Get-WmiObject -Class Win32_Product | Where-Object { 
$_.Name -match "Site24x7 Windows Agent" 
}

$app.Uninstall()
Write-Host "24x7 Agent unnistalled successful"
trap
{
Write-Host "No tenia instalado el agente!! chowderhead"
Write-Host $_.errorID
}