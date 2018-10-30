Import-Module ActiveDirectory
#dsac.exe

$users = import-csv "C:\ADusers.csv"

ForEach ($item in $users)

{
    
    #$fullName = $item.Name
    #$firstName = $item.GivenName
    #$lastName = $item.Surname
    #$accountName = $item.SamAccountName
    #$city = $item.City
    #$country = $item.Country

    New-ADUser $item.name -DisplayName ($item.GivenName +" " + $item.Surname) `
    -SamAccountName $item.Account -UserPrincipalName ($item.GivenName+"."+$i.Surname+"@academy.local") `
    -GivenName $item.GivenName -Surname $item.Surname `
    -AccountPassword (ConvertTo-SecureString $item.Pass -AsPlainText -force) -ChangePasswordAtLogon $true    Write-Host "El usuario $item fue creado con exito" -ForegroundColor Green        #-samaccountname $item.SamAccountName    #-city $item.City    #-country $item.Country    Enable-ADAccount -Identity $item.Account


}
