Login-AzureRmAccount
Select-AzureRmSubscription -Subscription 'Shelby Production'

$vms=Get-AzureRmVM -ResourceGroupName 'RG_SS_PRD_SFO_DATA1'
#$vms="vm1","vm2"...

foreach($vm in $vms)
{
Invoke-Command -FilePath .\Site24x7unistall.ps1 -ComputerName $vms
}
