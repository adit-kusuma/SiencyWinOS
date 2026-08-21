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
    "src/modules/Security.ps1",
    "src/modules/Repair.ps1",
    "src/modules/Monitor.ps1",
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
        pause; exit
    }
}

$launch = @"
`$ErrorActionPreference = 'Continue'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
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
. "`$tmp\src\modules\Security.ps1"
. "`$tmp\src\modules\Repair.ps1"
. "`$tmp\src\modules\Monitor.ps1"
. "`$tmp\src\ui\Theme.ps1"
. "`$tmp\src\ui\MainWindow.ps1"
Start-SiencyWinOS
"@

$launchPath = "$tmp\launch.ps1"
$launch | Out-File -FilePath $launchPath -Encoding UTF8 -Force

# Desktop shortcut
$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut("$env:USERPROFILE\Desktop\SiencyWinOS.lnk")
$sc.TargetPath = "powershell.exe"
$sc.Arguments  = "-NoProfile -ExecutionPolicy Bypass -STA -File `"$launchPath`""
$sc.Description = "SiencyWinOS Optimizer"
$sc.Save()

Write-Host ""
Write-Host "  [OK] All $total modules downloaded!" -ForegroundColor Green
Write-Host "  Launching GUI..." -ForegroundColor Green
Write-Host ""

Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -STA -File `"$launchPath`"" -Verb RunAs
