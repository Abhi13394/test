#param([string]$inputfile = "$PSScriptRoot\ChangeSets.csv", [int]$timeout = 15)
param([string]$inputfile = "C:\Storagefop\changesets.csv", [int]$timeout = 15)
Clear-Host
$ErrorActionPreference = 'Stop'

$baseDir = "C:\Storagefop"
$dateDir = "$baseDir\Export\$([datetime]::Now.ToString('yyyyMMdd'))"
$csv = Get-Content -Path $inputfile
$baseUrl = "http://localhost:30600/rest/api/submit-job/csexport?changeset=%changeset%&destination=%destination%"

if (-not (Test-Path -Path $dateDir)) {
    New-Item -ItemType Directory -Path $dateDir | Out-Null
}

Write-Host "Exporting $($csv.Length) changesets to $dateDir"

$i = 0
foreach($line in $csv) {
    $i++
    $changeset = $line.Split(',')[1]
    $filename = $line.Split(',')[0]
    if ([string]::IsNullOrWhiteSpace($filename)) {
        $filename = "$changeset.chs"
    }
    $filepath = "$baseDir\$filename.chs"
    $movepath = "$dateDir\$changeset.chs"
    
    if ([System.IO.File]::Exists($filepath)) { Remove-Item -Path $filepath }
    if ([System.IO.File]::Exists($movepath)) { Remove-Item -Path $movepath }

    try {
        Write-Host "  [$($i.ToString().PadLeft(3, '0'))] Exporting changeset $changeset"
        $url = $baseUrl.Replace("%changeset%", $changeset).Replace("%destination%", $baseDir)
        $resp = Invoke-WebRequest -Uri $url

        Start-Sleep -Seconds $timeout
		Write-host "from $filepath to $movepath"
        Move-Item -Path $filepath -Destination $movepath -Force
        #Write-Host " * Exported changeset $changeset to $movepath"
    }
    catch {
        Write-Warning $_
        try {
            Write-Warning "Error exporting $changeset to $filepath, message: $([System.Text.Encoding]::UTF8.GetString($resp.Content))"
            Read-Host "Pausing, press any key..."
        }
        catch {
            # meh
        }
    }
}

Read-Host "Finished, press any key..."
