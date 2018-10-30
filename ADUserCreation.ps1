#***OPEN THIS SCRIPT IN ADMINISTRATIVE PS WINDOWS***
Import-Module ActiveDirectory
$users=Import-Csv c:\sources\ADusers.csv

foreach ($id in $users)
{
#I am checking if the user exists
$move=$id.user
$searchU=Get-ADUser -Filter {Name -like $move}
if (-not $searchU) {
#If the users does not exist we will create it
$path="OU=" + $id.ou + ",OU=Flexential,DC=pb,DC=mbhosting,DC=com"
New-ADUser $id.user -DisplayName ($id.first +" " + $id.Last) `
-SamAccountName ($id.First+"."+$id.Last) -UserPrincipalName ($id.First+"."+$id.Last+"@pb.mbhosting.com") `
-GivenName $id.First -Surname $id.Last -Description $id.Description `
-AccountPassword (ConvertTo-SecureString $id.Password -AsPlainText -force) -ChangePasswordAtLogon $false `
-Path $path -Enabled $true
Add-ADGroupMember -Identity "Domain Admins" -Members ($id.First+"."+$id.last)
Add-ADGroupMember -Identity "Globant Team" -Members ($id.First+"."+$id.last)
Add-ADGroupMember -Identity "MB_SYSADM_TEAM" -Members ($id.First+"."+$id.last)
} else {

$file="c:\Sources\LogCreateUser.txt"
"Warning: This user exist in your domain - " + $id.user | out-file $file -Append
}
}