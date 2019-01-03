#*****THIS SCRIPT MUST BE RUN AS ADMINISTRATOR ON POWERSHELL AND THE USER MUST HAVE ADMINISTRATIVE RIGHTS OVER THE DB IN CASE THE SERVER WOULD BE A DB SERVER
# Set the parameters
$APPVersion = "6.7.0.1"
$APP = Get-WmiObject -class win32_product | where-object name -like "Datadog Agent"
$IIS = Get-WmiObject -List -Namespace root\cimv2 | Select-Object -Property name | Where-Object name -like "*Win32_PerfFormattedData_W3SVC*"
$SQL = Get-WmiObject -list -namespace root\cimv2 | Select-Object -property name | Where-Object name -like "*SQLServerDatabase*"
#$SQL = Get-WmiObject -list -namespace root\cimv2 | select -property name | where name -like "*SQLServer*"
$FileName = "datadog-agent-6-latest.amd64.msi"
$DDFolder = 'C:\Sources'

Invoke-Command {

# Start logging the actions
Start-Transcript -Path $DDFolder\DDAgentInstallLog.txt -NoClobber

# Checking if Datadog agent is installed and it is in the last version, just to retag the agent
if ($APP.Name -eq "Datadog Agent" -and $APP.Version -eq "$APPVersion"){
  Write-host "Datadog Agent is installed in this device" -ForegroundColor Green
  # Checking if the server is a IIS Server
  If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebServiceCache" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVCW3WPCounterProvider_W3SVCW3WP"){
    Write-host "This is an IIS Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL1 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/IIS/datadog.yaml?sp=rl&st=2018-12-04T12:44:42Z&se=2019-12-05T12:44:00Z&sv=2017-11-09&sig=tqnELAbunXPErAGg%2FzZGF5KtLreFCFSlipt0lygOwYo%3D&sr=b"
    Invoke-WebRequest -URI $URL1 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
  # Checking if the server is a SQL Server
  If ($SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabaseMirroring" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
  #If ($SQL.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
    Write-host "This is a SQL Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL3 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/SQLSERVER/datadog.yaml?sp=rl&st=2018-12-04T12:45:49Z&se=2019-12-05T12:45:00Z&sv=2017-11-09&sig=D08DJBQLYSOpM7mpU%2FJUclz%2B0W2QRJwIyiLTSSOCsVY%3D&sr=b"
    Invoke-WebRequest -URI $URL3 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
  # Checking if the server is a IIS and SQL Server
  if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases") {
  #If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer") {
    Write-Host "This is an IIS AND SQL Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL6 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/IIS&SQL/datadog.yaml?sp=rl&st=2018-12-04T12:47:40Z&se=2019-12-05T12:47:00Z&sv=2017-11-09&sig=UR4wfVrVqJVM52LSI%2FFW7ACtKtb8CXDpU9tDSX%2F8QN8%3D&sr=b"
    Invoke-WebRequest -URI $URL6 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
  else {
    Write-host "This is a Standard Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL7 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/Standard/datadog.yaml?sp=rl&st=2018-12-04T12:48:11Z&se=2019-12-05T12:48:00Z&sv=2017-11-09&sig=KQ2GJ6GyXMpx3jPxBGiTfjDdKHJ%2B81PrrEm%2BZ8yRii0%3D&sr=b"
    Invoke-WebRequest -URI $URL7 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
}


#Checking is Datadog agent is installed and the version is Different to the last to Update it
Elseif ($app.name -eq "Datadog Agent" -and $app.Version -ne "$appversion") {
  
  # Change the location to the specified folder
  Set-Location $DDFolder

  # Downloading installer
  if (Test-Path $FileName){
    Write-Host "The file $FileName already exists."
  }
  else  {
    Write-Host "The file $FileName does not exist, downloading..." -ForegroundColor Red
    $URL = "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-6-latest.amd64.msi"
    Invoke-WebRequest -Uri $URL -OutFile "$DDFolder\datadog-agent-6-latest.amd64.msi" | Out-Null
    Write-Host "done!" -ForegroundColor Green
  }

  # Install the Datadog Agent
  Write-Host "Installing Datadog Agent.." -ForegroundColor Green
  Invoke-Command -ScriptBlock { & cmd /c "msiexec.exe /i $FileName" /qn ADVANCED_OPTIONS=1 CHANNEL=100}
}

#Checking if Datadog agent is not to install it
Elseif ($app.name -ne "Datadog Agent") {
  
  # Change the location to the specified folder
  Set-Location $DDFolder

  # Downloading installer
  if (Test-Path $FileName){
    Write-Host "The file $FileName already exists."
  }
  else  {
    Write-Host "The file $FileName does not exist, downloading..." -ForegroundColor Red
    $URL = "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-6-latest.amd64.msi"
    Invoke-WebRequest -Uri $URL -OutFile "$DDFolder\datadog-agent-6-latest.amd64.msi" | Out-Null
    Write-Host "done!" -ForegroundColor Green
  }

  # Install the Datadog Agent
  Write-Host "Installing Datadog Agent.." -ForegroundColor Green
  Invoke-Command -ScriptBlock { & cmd /c "msiexec.exe /i $FileName" /qn ADVANCED_OPTIONS=1 CHANNEL=100}

  # Checking if the server is a IIS Server
  If ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebServiceCache" -or $IIS.name -eq "Win32_PerfFormattedData_W3SVCW3WPCounterProvider_W3SVCW3WP"){
    Write-host "This is an IIS Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL1 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/IIS/datadog.yaml?sp=rl&st=2018-12-04T12:44:42Z&se=2019-12-05T12:44:00Z&sv=2017-11-09&sig=tqnELAbunXPErAGg%2FzZGF5KtLreFCFSlipt0lygOwYo%3D&sr=b"
    Invoke-WebRequest -URI $URL1 -outfile "$DDFolder\datadog.yaml"
    $URL2 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/IIS/conf.yaml?sp=rl&st=2018-12-04T12:45:21Z&se=2019-12-05T12:45:00Z&sv=2017-11-09&sig=1e7pR8%2FlnjeaLt%2BUIffLXNTI%2BLcQsJv3QRor7oCt%2Bdw%3D&sr=b"
    Invoke-WebRequest -URI $URL2 -outfile "$DDFolder\conf.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\iis.d -Force
  }

  # Checking if the server is a SQL Server
  If ($SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabaseMirroring" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
  #If ($SQL.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabaseReplica" -or $SQL.name -eq "Win32_PerfFormattedData_MSSQLSERVER_SQLServerDatabases" -or $SQL.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases"){
    Write-host "This is a SQL Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL3 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/SQLSERVER/datadog.yaml?sp=rl&st=2018-12-04T12:45:49Z&se=2019-12-05T12:45:00Z&sv=2017-11-09&sig=D08DJBQLYSOpM7mpU%2FJUclz%2B0W2QRJwIyiLTSSOCsVY%3D&sr=b"
    Invoke-WebRequest -URI $URL3 -outfile "$DDFolder\datadog.yaml"
    $URL4 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/SQLSERVER/conf.yaml?sp=rl&st=2018-12-04T12:46:29Z&se=2019-12-05T12:46:00Z&sv=2017-11-09&sig=TQaV3mPn4LGo1fHrRMM9avYWePJ4SOl83jTW1RLV7wk%3D&sr=b"
    Invoke-WebRequest -URI $URL4 -outfile "$DDFolder\conf.yaml"
    $URL5 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/SQLSERVER/CreateDatadogUser.sql?sp=rl&st=2018-12-04T12:46:54Z&se=2019-12-05T12:46:00Z&sv=2017-11-09&sig=CnZBF7jsGj5AqJhzWHnPXMB1FrdqIfj8uOjtLjiiqZQ%3D&sr=b"
    Invoke-WebRequest -URI $URL5 -outfile "$DDFolder\CreateDatadogUser.sql"
    sqlcmd -S WIN-PS1MV05NK18\SQLEXPRESS -i C:\Sources\CreateDatadogUser.sql
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    Copy-Item -Path $DDFolder\Conf.yaml -Destination C:\ProgramData\Datadog\conf.d\sqlserver.d -Force
  }
  
  # Checking if the server is a IIS and SQL Server
  if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases") {
  #if ($IIS.name -eq "Win32_PerfFormattedData_W3SVC_WebService" -and $Sql.name -eq "Win32_PerfRawData_NETDataProviderforSqlServer_NETDataProviderforSqlServer") {
    Write-Host "This is an IIS AND SQL Server. Updating files and activating Datadog check for IIS" -ForegroundColor Green
    $URL6 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/IIS&SQL/datadog.yaml?sp=rl&st=2018-12-04T12:47:40Z&se=2019-12-05T12:47:00Z&sv=2017-11-09&sig=UR4wfVrVqJVM52LSI%2FFW7ACtKtb8CXDpU9tDSX%2F8QN8%3D&sr=b"
    Invoke-WebRequest -URI $URL6 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
    }
  else {
    Write-host "This is a Standard Server. Updating files and activating Datadog check for SQL Server" -ForegroundColor Green
    $URL7 = "https://ssprditopsa01.blob.core.windows.net/datadog-files/SimpleChurch/Standard/datadog.yaml?sp=rl&st=2018-12-04T12:48:11Z&se=2019-12-05T12:48:00Z&sv=2017-11-09&sig=KQ2GJ6GyXMpx3jPxBGiTfjDdKHJ%2B81PrrEm%2BZ8yRii0%3D&sr=b"
    Invoke-WebRequest -URI $URL7 -outfile "$DDFolder\datadog.yaml"
    Copy-Item -Path $DDFolder\datadog.yaml -Destination C:\ProgramData\Datadog -Force
  }
}

Write-host "We are ready, it is time to rest for a while :)" -foregroundColor Green
Restart-service 'Datadog Trace Agent'
Restart-Service 'Datadog Agent' -Force
Stop-Transcript
}
