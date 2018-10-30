#############################
## Usar este bloque, solo si se van obtener las maquinas por medio de Get-AzureRmVM, comentariar la Linea 18
#if (!$loginAz)
#{
# $loginAz = Login-AzureRmAccount
#}
#Select-AzureRmSubscription -Subscription 'FellowshipOne dev'
#$serverlist=Get-AzureRmVM
#######################

if (!$cred)
{
    $cred = get-credential
}
## Usar este bloque, solo si se van obtener las maquinas por medio de archivo o listado. Comentariar las lineas 7 y 8
$serverlist = Get-Content "c:\sources\I10_PRO.txt"
#$serverlist = 'I10UATDB01.mbhosting.com', 'i10uatftp01.mbhosting.com', 'I10UATWEB01.mbhosting.com', 'I10UATWEB02.mbhosting.com', 'I10UATWEB03.mbhosting.com', 'I10UATWEB05.mbhosting.com'
#$serverlist = 'wsf1devweb01.mbhosting.com', 'wsf1devapp02.mbhosting.com'

$LogFile = "results.txt"
$error.Clear()trap {$error | out-file $LogFile -append -noClobber; continue}

#output = "results.txt"
#output = "Server;Result"
$output = "Server;Result"$output | out-file -filePath $LogFile -append -noClobber
foreach ($server in $serverlist)
{
    if ($server.name)
    { $realserver = $server.name }
    else { $realserver = $server }
    $resultado="error"
    Write-Host "- Working on " -NoNewline
    Write-Host $realserver -ForegroundColor Yellow
    $resultado = Invoke-Command -FilePath .\LocalUsersGroups.ps1 -ComputerName $realserver -Credential $cred
    Write-Host "done!" -ForegroundColor Green
    $output = $realserver + ";" + $resultado
    $output | out-file -filePath $LogFile -append -noClobber
    #output | write-output $realserver + ";" + $resultado
}