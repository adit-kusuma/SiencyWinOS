# SiencyWinOS Loader - Stable Branch
# Command: irm https://raw.githubusercontent.com/adit-kusuma/SiencyWinOS/main/loader.ps1 | iex

$ErrorActionPreference = "SilentlyContinue"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

$base = "https://raw.githubusercontent.com/adit-kusuma/SiencyWinOS/main"
$tmp  = "$env:TEMP\SiencyWinOS"

Clear-Host
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Green
Write-Host "       SiencyWinOS Optimizer  v2.0"           -ForegroundColor Green
Write-Host "       Stable Branch"                          -ForegroundColor DarkGreen
Write-Host "  ============================================" -ForegroundColor Green
Write-Host ""

if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path "$tmp\src\modules"   -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\src\ui"        -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\src\utils"     -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\assets\themes" -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\config"        -Force | Out-Null

$files = @(
    "src/utils/Logger.ps1",
    "src/utils/Helpers.ps1",
    "src/modules/Optimization.ps1",
    "src/modules/Gaming.ps1",
    "src/modules/Privacy.ps1",
    "src/modules/Network.ps1",
    "src/modules/System.ps1",
    "src/modules/Advanced.ps1",
    "src/modules/ProcessManager.ps1",
    "src/ui/Theme.ps1",
    "src/ui/MainWindow.ps1",
    "config/settings.json",
    "assets/themes/dark.json",
    "assets/themes/light.json"
)

$total = $files.Count
$i = 0
foreach ($file in $files) {
    $i++
    $name = Split-Path $file -Leaf
    Write-Host "  [$i/$total] Downloading $name..." -ForegroundColor DarkGreen
    $url  = "$base/$($file)"
    $dest = "$tmp\$($file.Replace('/', '\'))"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  [ERR] Failed: $name" -ForegroundColor Red
        pause
        exit
    }
}

# Build the launch script
$launch = @"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

`$tmp = '$tmp'
. "`$tmp\src\utils\Logger.ps1"
. "`$tmp\src\utils\Helpers.ps1"
. "`$tmp\src\modules\Optimization.ps1"
. "`$tmp\src\modules\Gaming.ps1"
. "`$tmp\src\modules\Privacy.ps1"
. "`$tmp\src\modules\Network.ps1"
. "`$tmp\src\modules\System.ps1"
. "`$tmp\src\modules\Advanced.ps1"
. "`$tmp\src\modules\ProcessManager.ps1"
. "`$tmp\src\ui\Theme.ps1"
. "`$tmp\src\ui\MainWindow.ps1"
Start-SiencyWinOS
"@

$launchPath = "$tmp\launch.ps1"
$launch | Out-File -FilePath $launchPath -Encoding UTF8 -Force

Write-Host ""
Write-Host "  [OK] All modules downloaded successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "  Launching SiencyWinOS GUI..." -ForegroundColor Green
Write-Host ""

# Key fix: use powershell.exe with -STA flag as a new process with -File
# This is the ONLY way WPF works - must be file-based, STA, separate process
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "powershell.exe"
$psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -STA -NonInteractive -File `"$launchPath`""
$psi.UseShellExecute = $true
$psi.Verb = "runas"
[System.Diagnostics.Process]::Start($psi) | Out-Null
