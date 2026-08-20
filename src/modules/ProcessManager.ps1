$global:ProcessBlacklist = @(
    # Telemetry & tracking
    "CompatTelRunner", "WerFault", "WerMgr", "WerSvc",
    "wsqmcons", "DiagTrack", "dmwappushservice",
    # Xbox & gaming overlay
    "GameBarPresenceWriter", "XboxPcAppFT", "XboxGamingOverlay",
    # Cortana & search
    "Cortana", "SearchApp", "SearchIndexer", "SearchProtocolHost", "SearchFilterHost",
    # OneDrive
    "OneDrive", "OneDriveSetup",
    # Microsoft Office background
    "OfficeClickToRun", "AppVShNotify",
    # Sync & cloud
    "GoogleDriveFS", "Dropbox", "DropboxUpdate",
    # Updaters
    "GoogleUpdate", "SkypeUpdate", "SteamService",
    "EpicWebHelper", "EpicGamesLauncher",
    # Communication apps background
    "Teams", "Skype", "slack", "zoom",
    # Misc background
    "SpeechRuntime", "RuntimeBroker", "backgroundTaskHost",
    "MicrosoftEdgeUpdate", "EdgeUpdate",
    "NahimicService", "NahimicSvc",
    "AdobeUpdateService", "AdobeARMservice",
    "CCleaner", "CCleanerUpdate",
    "Discord", "DiscordUpdate"
)

$global:SystemProtectedProcesses = @(
    "System", "svchost", "lsass", "csrss", "smss", "wininit",
    "winlogon", "services", "explorer", "dwm", "taskhostw",
    "sihost", "ctfmon", "fontdrvhost", "spoolsv", "audiodg",
    "powershell", "pwsh", "cmd", "conhost", "taskmgr",
    "regedit", "mmc", "wuauclt", "MsMpEng", "NisSrv",
    "SecurityHealthService", "SecurityHealthSystray"
)

function Get-RunningProcessList {
    Write-SLog ">> Scanning running processes..."
    $procs = Get-Process | Where-Object {
        $_.Name -notin $global:SystemProtectedProcesses -and
        $_.MainWindowTitle -ne "" -or $_.Name -in $global:ProcessBlacklist
    } | Sort-Object CPU -Descending | Select-Object -First 40
    return $procs
}

function Stop-UnnecessaryProcesses {
    Write-SLog ">> Killing unnecessary background processes..."
    $killed = 0
    foreach ($name in $global:ProcessBlacklist) {
        $proc = Get-Process -Name $name -ErrorAction SilentlyContinue
        if ($proc) {
            Stop-Process -Name $name -Force -ErrorAction SilentlyContinue
            Write-SLog "   [KILLED] $name ($($proc.Count) instance)"
            $killed++
        }
    }
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()
    Write-SLog "   [OK] $killed process types terminated, RAM freed"
    Write-SLog ">> Process Cleanup Complete"
}

function Stop-HighCPUProcesses {
    Write-SLog ">> Scanning for high CPU processes..."
    $highCPU = Get-Process | Where-Object {
        $_.CPU -gt 10 -and
        $_.Name -notin $global:SystemProtectedProcesses
    } | Sort-Object CPU -Descending | Select-Object -First 10
    if ($highCPU.Count -eq 0) {
        Write-SLog "   [OK] No high CPU processes detected"
        return
    }
    foreach ($p in $highCPU) {
        Write-SLog "   [HIGH CPU] $($p.Name) - CPU: $([math]::Round($p.CPU,1))s - PID: $($p.Id)"
    }
    Write-SLog ">> High CPU scan complete - review log above"
}

function Stop-HighRAMProcesses {
    Write-SLog ">> Scanning for high RAM processes..."
    $highRAM = Get-Process | Where-Object {
        $_.WorkingSet64 -gt 200MB -and
        $_.Name -notin $global:SystemProtectedProcesses
    } | Sort-Object WorkingSet64 -Descending | Select-Object -First 10
    if ($highRAM.Count -eq 0) {
        Write-SLog "   [OK] No unusually high RAM processes"
        return
    }
    foreach ($p in $highRAM) {
        $mb = [math]::Round($p.WorkingSet64 / 1MB, 1)
        Write-SLog "   [HIGH RAM] $($p.Name) - RAM: $mb MB - PID: $($p.Id)"
    }
    Write-SLog ">> High RAM scan complete"
}

function Invoke-ProcessOptimization {
    Write-SLog ">> Full Process Optimization..."
    Stop-UnnecessaryProcesses
    Stop-HighCPUProcesses
    Stop-HighRAMProcesses
    Write-SLog ">> Process Optimization Complete"
}
