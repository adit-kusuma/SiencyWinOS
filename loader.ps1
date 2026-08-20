# SiencyWinOS Loader - Stable Branch
# Command: irm https://raw.githubusercontent.com/USERNAME/SiencyWinOS/main/loader.ps1 | iex

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/USERNAME/SiencyWinOS/main/loader.ps1 | iex`"" -Verb RunAs
    exit
}

$ErrorActionPreference = "SilentlyContinue"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

$base = "https://raw.githubusercontent.com/USERNAME/SiencyWinOS/main"
$tmp  = "$env:TEMP\SiencyWinOS"

Clear-Host
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Green
Write-Host "       SiencyWinOS Optimizer  v2.0" -ForegroundColor Green
Write-Host "       Stable Branch" -ForegroundColor DarkGreen
Write-Host "  ============================================" -ForegroundColor Green
Write-Host ""

if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path "$tmp\src\modules" -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\src\ui"      -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\src\utils"   -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\assets\themes" -Force | Out-Null
New-Item -ItemType Directory -Path "$tmp\config"      -Force | Out-Null

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
        Write-Host "  Check that your GitHub repo is public." -ForegroundColor Yellow
        pause
        exit
    }
}

Write-Host ""
Write-Host "  [OK] All modules loaded. Launching GUI..." -ForegroundColor Green
Write-Host ""
Start-Sleep -Milliseconds 500

. "$tmp\src\utils\Logger.ps1"
. "$tmp\src\utils\Helpers.ps1"
. "$tmp\src\modules\Optimization.ps1"
. "$tmp\src\modules\Gaming.ps1"
. "$tmp\src\modules\Privacy.ps1"
. "$tmp\src\modules\Network.ps1"
. "$tmp\src\modules\System.ps1"
. "$tmp\src\modules\Advanced.ps1"
. "$tmp\src\modules\ProcessManager.ps1"
. "$tmp\src\ui\Theme.ps1"
. "$tmp\src\ui\MainWindow.ps1"

Start-SiencyWinOS
