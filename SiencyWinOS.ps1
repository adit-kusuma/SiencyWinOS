if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptRoot\src\utils\Logger.ps1"
. "$ScriptRoot\src\utils\Helpers.ps1"
. "$ScriptRoot\src\modules\Optimization.ps1"
. "$ScriptRoot\src\modules\Gaming.ps1"
. "$ScriptRoot\src\modules\Privacy.ps1"
. "$ScriptRoot\src\modules\Network.ps1"
. "$ScriptRoot\src\modules\System.ps1"
. "$ScriptRoot\src\modules\Advanced.ps1"
. "$ScriptRoot\src\modules\ProcessManager.ps1"
. "$ScriptRoot\src\modules\Security.ps1"
. "$ScriptRoot\src\modules\Repair.ps1"
. "$ScriptRoot\src\modules\Monitor.ps1"
. "$ScriptRoot\src\ui\Theme.ps1"
. "$ScriptRoot\src\ui\MainWindow.ps1"
Start-SiencyWinOS
