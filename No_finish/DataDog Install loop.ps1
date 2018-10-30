Login-AzureRmAccount
Select-AzureRmSubscription -Subscription 'In10sity Production'

$vms=Get-AzureRmVM -ResourceGroupName 'I10UAT_E2_RG'
#$vms="vm1","vm2"...

foreach($vm in $vms)
{
Write-Host "Installing on $vm.name"
Invoke-Command -ComputerName $vm.name -ScriptBlock {.\DatadogInstall.ps1 }
}
