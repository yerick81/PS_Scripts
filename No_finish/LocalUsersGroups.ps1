<#
[ADSI]$S = "WinNT://$env:COMPUTERNAME"
$S.children.where({$_.class -eq 'group'}) |
Select @{Name="Computername";Expression={$_.Parent.split("/")[-1] }},
@{Name="Name";Expression={$_.name.value}},
@{Name="Members";Expression={
[ADSI]$group = "$($_.Parent)/$($_.Name),group"
$members = $Group.psbase.Invoke("Members")
($members | ForEach-Object {
$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
}) -join ";"
}}
#>


$ComputerName = $env:COMPUTERNAME
$Group = ‘Administrators’
#$UserScan = ‘Administrator’
$UserScan = ‘Globant Tech Group’

$UserExists = [bool](Get-WmiObject -Class Win32_GroupUser -ComputerName $ComputerName |
Where-Object {$_.GroupComponent -match $Group -and
$_.PartComponent.Contains($UserScan)})

$UserExists


#Test-UserCredential -username UserNameToTest -password (Read-Host)

<#
Function Test-UserCredential { 
    Param($username, $password) 
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement 
    $ct = [System.DirectoryServices.AccountManagement.ContextType]::Machine, $env:computername 
    $opt = [System.DirectoryServices.AccountManagement.ContextOptions]::SimpleBind 
    $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $ct 
    $Result = $pc.ValidateCredentials($username, $password).ToString() 
    $Result 
} 

Test-UserCredential -username mbhosting\juan.perez -password 'Pillin52**'
#>
<#
$username = 'mbhosting\juan.perez'

Start-Process -FilePath cmd.exe /c -Credential (Get-Credential -UserName $username -Message 'Test Credential')
#>