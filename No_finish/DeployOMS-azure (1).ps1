Login-AzureRmAccount
Select-AzureRmSubscription -Subscription 'Parishsoft Production'

$vms=Get-AzureRmVM -ResourceGroupName 'rg_mb-prsh_web_prod'
$vms

foreach($vm in $vms)
{
    Invoke-Command -FilePath .\InstallOMSAgentwithServiceMap.ps1 -ComputerName $vms
}