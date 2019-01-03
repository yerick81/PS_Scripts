$regex = '(?:http|s?ftp)s?://[^\s,<>"]+'
$pathAR = "D:\Deployment\PublicSite\Argentina\*"
$pathCRB = "D:\Deployment\PublicSite\Caribbean\*"
$pathCL = "D:\Deployment\PublicSite\Chile\*"
$pathCO = "D:\Deployment\PublicSite\Colombia\*"
$pathEC = "D:\Deployment\PublicSite\Ecuador\*"
$pathPE = "D:\Deployment\PublicSite\Peru\*"
$pathPR = "D:\Deployment\PublicSite\PuertoRico\*"
$pathUY = "D:\Deployment\PublicSite\Uruguay\*"
$pathVE = "D:\Deployment\PublicSite\Venezuela\*"
get-content -path "$pathAR"
select-string -Path $pathAR -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlAR.csv
get-content -path "$pathCRB"
select-string -Path $pathCRB -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlCRB.csv
get-content -path "$pathCL"
select-string -Path $pathCL -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlCL.csv
get-content -path "$pathCO"
select-string -Path $pathCO -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlCO.csv
get-content -path "$pathEC"
select-string -Path $pathEC -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlEC.csv
get-content -path "$pathPE"
select-string -Path $pathPE -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlPE.csv
get-content -path "$pathPR"
select-string -Path $pathPR -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlPR.csv
get-content -path "$pathUY"
select-string -Path $pathUY -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlUY.csv
get-content -path "$pathVE"
select-string -Path $pathVE -Pattern $regex -AllMatches | ForEach-Object { $_.Matches } | % { $_.Value } | Out-File C:\Sources\UrlVE.csv