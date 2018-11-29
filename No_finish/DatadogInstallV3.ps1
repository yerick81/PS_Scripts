#*****THIS SCRIPT MUST BE RUN AS ADMINISTRATOR ON POWERSHELL AND THE USER MUST HAVE ADMINISTRATIVE RIGHTS OVER THE DB IN CASE THE SERVER WOULD BE A DB SERVER
# Set the parameters
$APP = Get-WmiObject -class win32_product | where name -like "Datadog Agent"
$IIS = Get-WmiObject -List -Namespace root\cimv2 | select -Property name | where name -like "*Win32_PerfFormattedData_W3SVC*"
$SQL = Get-WmiObject -list -namespace root\cimv2 | select -property name | where name -like "*SQLServerDatabase*"
#$SQL = Get-WmiObject -list -namespace root\cimv2 | select -property name | where name -like "*SQLServer*"
$FileName = "datadog-agent-6-6.0.0.amd64.msi"
$DDFolder = 'C:\Sources'

Invoke-Command {

# Start logging the actions
Start-Transcript -Path $DDFolder\DDAgentInstallLog.txt -NoClobber
# Checking if Datadog agent is installed
if ($APP.Name -eq "Datadog Agent") {
  Write-host "Datadog Agent is installed in this device" -ForegroundColor Green
  # Checking if the server is a IIS Server
  If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebServiceCache" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVCW3WPCounterProvider_W3SVCW3WP"){
    Write-host "This is an IIS Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL1 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS/datadog.yaml?sp=rl&st=2018-11-29T11:55:40Z&se=2018-11-30T11:55:40Z&sv=2017-11-09&sig=dCm%2FLK07kMkHXvOehcxoPe0OC7pPlzA6moCM0agk6zA%3D&sr=b"
    Invoke-WebRequest -URI $URL1 -outfile "$DDFolder\datadog.yaml"
    $URL2 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS/conf.yaml?sp=rl&st=2018-11-28T19:47:59Z&se=2018-11-29T19:47:59Z&sv=2017-11-09&sig=57pOUsLqeBxXgUoWNv4etBYH9DbkdnLk9i2IRtLnce0%3D&sr=b"
    Invoke-WebRequest -URI $URL2 -outfile "$DDFolder\conf.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\iis.d -Force
  }
  # Checking if the server is a SQL Server
  If ($SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabaseMirroring" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
  #If ($SQL.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
    Write-host "This is a SQL Server. Updating files and activating Datadog check for SQL Server" -NoNewline -ForegroundColor Green
    $URL3 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/datadog.yaml?sp=rl&st=2018-11-29T11:58:41Z&se=2019-11-30T11:58:00Z&sv=2017-11-09&sig=F5hXskepswsfB3wZV9iKYriQzOlsM1yKpi5D4rvT9hQ%3D&sr=b"
    Invoke-WebRequest -URI $URL3 -outfile "$DDFolder\datadog.yaml"
    $URL4 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/conf.yaml?sp=rl&st=2018-11-29T12:05:47Z&se=2019-11-30T12:05:00Z&sv=2017-11-09&sig=wRRSg%2BnwPYGW2shahLf%2BAi1mZLf6BlsvwFsAHg9R60g%3D&sr=b"
    Invoke-WebRequest -URI $URL4 -outfile "$DDFolder\conf.yaml"
    $URL5 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/CreateDatadogUser.sql?sp=rl&st=2018-11-28T15:06:48Z&se=2018-11-29T15:06:48Z&sv=2017-11-09&sig=TwznUldwaPDnLXOPFRTFZc8JribAQaItWJuS7skl2hs%3D&sr=b"
    Invoke-WebRequest -URI $URL5 -outfile "$DDFolder\CreateDatadogUser.sql"
    sqlcmd -S WIN-PS1MV05NK18\SQLEXPRESS -i C:\Sources\CreateDatadogUser.sql
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\sqlserver.d -Force
  }
  # Checking if the server is a IIS and SQL Server
  if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases") {
  #If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer") {
    Write-Host "This is an IIS AND SQL Server. Updating files and activating Datadog check for IIS" -NoNewline -ForegroundColor Green
    $URL6 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS&SQL/datadog.yaml?sp=rl&st=2018-11-29T12:00:53Z&se=2019-11-30T12:00:00Z&sv=2017-11-09&sig=5V5suBtBJUBcsfbGlMQBwqpSSkYnwcfJrvTNTd1iPtg%3D&sr=b"
    Invoke-WebRequest -URI $URL6 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
  else {
    Write-host "This is a Standard Server. Updating files and activating Datadog check for SQL Server" -NoNewline -ForegroundColor Green
    $URL7 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/Standard/datadog.yaml?sp=rl&st=2018-11-29T13:01:25Z&se=2019-11-30T13:01:00Z&sv=2017-11-09&sig=3ux5cKT3j93o6pb4mPXIwIClYJapaAdfRShv8aaoC9U%3D&sr=b"
    Invoke-WebRequest -URI $URL7 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
}

if ($app.name -ne "Datadog Agent") {
  
  # Change the location to the specified folder
  Set-Location $DDFolder

  # Downloading installer
  if (Test-Path $FileName){
    Write-Host "The file $FileName already exists."
  }
  else  {
    Write-Host "The file $FileName does not exist, downloading..." -NoNewline -ForegroundColor Red
    $URL = "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-6-6.0.0.amd64.msi"
    Invoke-WebRequest -Uri $URL -OutFile "$DDFolder\datadog-agent-6-6.0.0.amd64.msi" | Out-Null
    Write-Host "done!" -ForegroundColor Green
  }

  # Install the Datadog Agent
  Write-Host "Installing Datadog Agent.." -nonewline -ForegroundColor Green
  Invoke-Command -ScriptBlock { & cmd /c "msiexec.exe /i $FileName" /qn ADVANCED_OPTIONS=1 CHANNEL=100}

  # Checking if the server is a IIS Server
  If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebServiceCache" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVCW3WPCounterProvider_W3SVCW3WP"){
    Write-host "This is an IIS Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL1 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS/datadog.yaml?sp=rl&st=2018-11-29T11:55:40Z&se=2018-11-30T11:55:40Z&sv=2017-11-09&sig=dCm%2FLK07kMkHXvOehcxoPe0OC7pPlzA6moCM0agk6zA%3D&sr=b"
    Invoke-WebRequest -URI $URL1 -outfile "$DDFolder\datadog.yaml"
    $URL2 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS/conf.yaml?sp=rl&st=2018-11-28T19:47:59Z&se=2018-11-29T19:47:59Z&sv=2017-11-09&sig=57pOUsLqeBxXgUoWNv4etBYH9DbkdnLk9i2IRtLnce0%3D&sr=b"
    Invoke-WebRequest -URI $URL2 -outfile "$DDFolder\conf.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\iis.d -Force
  }

  # Checking if the server is a SQL Server
  If ($SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabaseMirroring" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
  #If ($SQL.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
    Write-host "This is a SQL Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL3 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/datadog.yaml?sp=rl&st=2018-11-29T11:58:41Z&se=2019-11-30T11:58:00Z&sv=2017-11-09&sig=F5hXskepswsfB3wZV9iKYriQzOlsM1yKpi5D4rvT9hQ%3D&sr=b"
    Invoke-WebRequest -URI $URL3 -outfile "$DDFolder\datadog.yaml"
    $URL4 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/conf.yaml?sp=rl&st=2018-11-29T12:05:47Z&se=2019-11-30T12:05:00Z&sv=2017-11-09&sig=wRRSg%2BnwPYGW2shahLf%2BAi1mZLf6BlsvwFsAHg9R60g%3D&sr=b"
    Invoke-WebRequest -URI $URL4 -outfile "$DDFolder\conf.yaml"
    $URL5 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/SQLServer/CreateDatadogUser.sql?sp=rl&st=2018-11-28T15:06:48Z&se=2018-11-29T15:06:48Z&sv=2017-11-09&sig=TwznUldwaPDnLXOPFRTFZc8JribAQaItWJuS7skl2hs%3D&sr=b"
    Invoke-WebRequest -URI $URL5 -outfile "$DDFolder\CreateDatadogUser.sql"
    sqlcmd -S WIN-PS1MV05NK18\SQLEXPRESS -i C:\Sources\CreateDatadogUser.sql
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\sqlserver.d -Force
  }
  
  # Checking if the server is a IIS and SQL Server
  if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases") {
  #if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer") {
    Write-Host "This is an IIS AND SQL Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL6 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/IIS&SQL/datadog.yaml?sp=rl&st=2018-11-29T12:00:53Z&se=2019-11-30T12:00:00Z&sv=2017-11-09&sig=5V5suBtBJUBcsfbGlMQBwqpSSkYnwcfJrvTNTd1iPtg%3D&sr=b"
    Invoke-WebRequest -URI $URL6 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    }
  else {
    Write-host "This is a Standard Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL7 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/In10sity/Standard/datadog.yaml?sp=rl&st=2018-11-29T13:01:25Z&se=2019-11-30T13:01:00Z&sv=2017-11-09&sig=3ux5cKT3j93o6pb4mPXIwIClYJapaAdfRShv8aaoC9U%3D&sr=b"
    Invoke-WebRequest -URI $URL7 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
}
 
Restart-service 'Datadog Trace Agent'
Restart-Service 'Datadog Agent' -Force
Stop-Transcript
}
