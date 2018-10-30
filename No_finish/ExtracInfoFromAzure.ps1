Login-AzureRmAccount
$Subscrip = Get-Content "c:\source\Subscriptions.txt"
foreach ($app in $Subscrip)
{
Select-AzureRmSubscription -Subscription "$App"
Get-AzureRmVM | Export-CSV -path "$app.csv"
Write-Host "$app done!" -ForegroundColor Green
}
