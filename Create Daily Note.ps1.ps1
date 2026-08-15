$archivePath = Split-Path -Parent $PSCommandPath
$fileName = (Get-Date -Format 'MM.dd.yyyy') + '.txt'
New-Item -ItemType File -Path (Join-Path $archivePath $fileName) -Force | Out-Null
