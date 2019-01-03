$pathAR = "D:\Deployment\PublicSite\Argentina\*"
Get-ChildItem -Path $pathAR -Recurse -filter *.pdf | out-file c:\sources\ARpdf.csv
Get-ChildItem -Path $pathAR -Recurse -filter *.jpg | out-file c:\sources\ARjpg.csv
Get-ChildItem -Path $pathAR -Recurse -filter *.png | out-file c:\sources\ARpng.csv
$pathCRB = "D:\Deployment\PublicSite\Caribbean\*"
Get-ChildItem -Path $pathCRB -Recurse -filter *.pdf | out-file c:\sources\CRBpdf.csv
Get-ChildItem -Path $pathCRB -Recurse -filter *.jpg | out-file c:\sources\CRBjpg.csv
Get-ChildItem -Path $pathCRB -Recurse -filter *.png | out-file c:\sources\CRBpng.csv
$pathCL = "D:\Deployment\PublicSite\Chile\*"
Get-ChildItem -Path $pathCL -Recurse -filter *.pdf | out-file c:\sources\CLpdf.csv
Get-ChildItem -Path $pathCL -Recurse -filter *.jpg | out-file c:\sources\CLjpg.csv
Get-ChildItem -Path $pathCL -Recurse -filter *.png | out-file c:\sources\CLpng.csv
$pathCO = "D:\Deployment\PublicSite\Colombia\*"
Get-ChildItem -Path $pathCO -Recurse -filter *.pdf | out-file c:\sources\COpdf.csv
Get-ChildItem -Path $pathCO -Recurse -filter *.jpg | out-file c:\sources\COjpg.csv
Get-ChildItem -Path $pathCO -Recurse -filter *.png | out-file c:\sources\COpng.csv
$pathEC = "D:\Deployment\PublicSite\Ecuador\*"
Get-ChildItem -Path $pathEC -Recurse -filter *.pdf | out-file c:\sources\ECpdf.csv
Get-ChildItem -Path $pathEC -Recurse -filter *.jpg | out-file c:\sources\ECjpg.csv
Get-ChildItem -Path $pathEC -Recurse -filter *.png | out-file c:\sources\ECpng.csv
$pathPE = "D:\Deployment\PublicSite\Peru\*"
Get-ChildItem -Path $pathPE -Recurse -filter *.pdf | out-file c:\sources\PEpdf.csv
Get-ChildItem -Path $pathPE -Recurse -filter *.jpg | out-file c:\sources\PEjpg.csv
Get-ChildItem -Path $pathPE -Recurse -filter *.png | out-file c:\sources\PEpng.csv
$pathPR = "D:\Deployment\PublicSite\PuertoRico\*"
Get-ChildItem -Path $pathPR -Recurse -filter *.pdf | out-file c:\sources\PRpdf.csv
Get-ChildItem -Path $pathPR -Recurse -filter *.jpg | out-file c:\sources\PRjpg.csv
Get-ChildItem -Path $pathPR -Recurse -filter *.png | out-file c:\sources\PRpng.csv
$pathUY = "D:\Deployment\PublicSite\Uruguay\*"
Get-ChildItem -Path $pathUY -Recurse -filter *.pdf | out-file c:\sources\UYpdf.csv
Get-ChildItem -Path $pathUY -Recurse -filter *.jpg | out-file c:\sources\UYjpg.csv
Get-ChildItem -Path $pathUY -Recurse -filter *.png | out-file c:\sources\UYpng.csv
$pathVE = "D:\Deployment\PublicSite\Venezuela\*"
Get-ChildItem -Path $pathVE -Recurse -filter *.pdf | out-file c:\sources\VEpdf.csv
Get-ChildItem -Path $pathVE -Recurse -filter *.jpg | out-file c:\sources\VEjpg.csv
Get-ChildItem -Path $pathVE -Recurse -filter *.png | out-file c:\sources\VEpng.csv