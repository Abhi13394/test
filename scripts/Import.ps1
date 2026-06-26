#param([string]$inputfile = "$PSScriptRoot\changeset\ChangeSets.csv", [int]$timeout = 5)
param([string]$inputfile = "C:\AutoDeploy\changesets.csv", [int]$timeout = 5)

#Clear-Host
#$ErrorActionPreference = 'Stop'

#$baseDir = $PSScriptRoot
$baseDir = "\\18.144.54.120\Storagefop"
$dateDir = "$baseDir\Export\$([datetime]::Now.ToString('yyyyMMdd'))"
#$dateDir = "$baseDir\Export\"
$csv = Get-Content -Path $inputfile

$i = 0
foreach($line in $csv) {
    $i++
    $changeset = $line.Split(',')[0]
    $filename = $line.Split(',')[1]

    $exportpath = "$dateDir\$filename.chs"
    $importpath = "C:\AutoDeploy\Import\Staging\$filename.chs"
    
   try {
        Copy-Item -Path $exportpath -Destination $importpath -Force
        Write-Host " * Imported changeset $filename to $importpath"
    }
    catch {
        Write-Warning $_
        try {
            Write-Warning "Error copying $filename.chs to $importpath, message: $([System.Text.Encoding]::UTF8.GetString($resp.Content))"
            Read-Host "Pausing, press any key..."
        }
        catch {
			# meh
        }
    }
	Start-Sleep -Seconds 5
}

Read-Host "Finished, press any key..."
