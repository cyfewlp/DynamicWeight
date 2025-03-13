# 保存为 compress.ps1
param(
    [string]$versionString,
    [Boolean]$debug = $True
)
$ModName = "DynamicWeight"
$PapyrusScriptSourceDir = "src"
$PapyrusScriptDir
$fileName

if ($debug) {
    $PapyrusScriptDir = "contrib\Distribution\PapyrusDebug"
    $fileName = "$ModName-$versionString-Debug.7z"
    Write-Host "Build with debug"
}
else {
    $PapyrusScriptDir = "contrib\Distribution\PapyrusRelease"
    $fileName = "$ModName-$versionString-Release.7z"
    Write-Host "Build with release"
}
$buildDir = "temp"
$destinationConfigDir = "temp\SKSE\Plugins\$ModName"
$destinationScriptDir = "temp\Scripts"
$destinationSourceScriptDir = "temp\Source\Scripts"
New-Item -ItemType Directory -Path $destinationConfigDir -Force | Out-Null
New-Item -ItemType Directory -Path $destinationScriptDir -Force | Out-Null
New-Item -ItemType Directory -Path $destinationSourceScriptDir -Force | Out-Null
Copy-Item -Path "contrib\Distribution\config\$ModName.json" -Destination "$destinationConfigDir\$ModName.json" -Force -Recurse
Copy-Item -Path "$PapyrusScriptDir\*.pex" -Destination "$destinationScriptDir\" -Force -Recurse
Copy-Item -Path "$PapyrusScriptSourceDir\*.psc" -Destination "$destinationSourceScriptDir\" -Force -Recurse
Copy-Item -Path ".\*.esp" -Destination "$buildDir\" -Force -Recurse
Push-Location temp
& "7z" a -t7z -aoa -mx=9 "$fileName" -r "*" -xr!"*.7z"
Pop-Location