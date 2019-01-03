$pais = "VE"
Get-Content -Path "C:\Users\yerickson.arias\Desktop\Sources\Url$pais.csv" | Select-String -Pattern ".jpg" | out-file -FilePath C:\Sources\$pais"jpg.csv"
Get-Content -Path "C:\Users\yerickson.arias\Desktop\Sources\Url$pais.csv" | Select-String -Pattern ".png" | out-file -FilePath C:\Sources\$pais"png.csv"