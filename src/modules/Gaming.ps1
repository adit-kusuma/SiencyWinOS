$global:GamingActive = $false
$global:GamingCycle  = 0

function Start-GamingMode {
    $global:GamingActive = $true
    $global:GamingCycle  = 0
    Invoke-GameDVRDisable
    Invoke-ProcessorOptimization
    Stop-UnnecessaryProcesses
    powercfg /s e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null
    Write-SLog "Gaming Mode STARTED - optimizing every 10 seconds"
}

function Stop-GamingMode {
    $global:GamingActive = $false
    Write-SLog "Gaming Mode STOPPED"
}

function Invoke-GamingCycle {
    if (-not $global:GamingActive) { return }
    $global:GamingCycle++
    ipconfig /flushdns | Out-Null
    powercfg /s e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null
    $bgKill = @(
        "SearchIndexer","OneDrive","Cortana","CompatTelRunner","WerFault",
        "SpeechRuntime","GameBarPresenceWriter","XboxGamingOverlay",
        "wsqmcons","DiagTrack","backgroundTaskHost","MicrosoftEdgeUpdate"
    )
    foreach ($p in $bgKill) { Stop-Process -Name $p -Force -ErrorAction SilentlyContinue }
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f 2>$null | Out-Null
    Write-SLog "Gaming cycle $($global:GamingCycle) - processes killed, RAM flushed, DNS flushed, priority enforced"
}

function Invoke-RobloxBoost {
    Write-SLog ">> Roblox Booster..."
    Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices;
public class NtTimer {
    [DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint r, bool s, out uint c);
    [DllImport("ntdll.dll")] public static extern int NtQueryTimerResolution(out uint min, out uint max, out uint cur);
}
"@ -ErrorAction SilentlyContinue
    try {
        [uint]$min=0;[uint]$max=0;[uint]$cur=0
        [NtTimer]::NtQueryTimerResolution([ref]$min,[ref]$max,[ref]$cur) | Out-Null
        [uint]$out=0
        [NtTimer]::NtSetTimerResolution($max,$true,[ref]$out) | Out-Null
        Write-SLog "   [OK] Timer -> $([math]::Round($out/10000.0,2)) ms"
    } catch {}
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f 2>$null | Out-Null
    Stop-UnnecessaryProcesses
    [System.GC]::Collect()
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    ipconfig /flushdns | Out-Null
    reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    powercfg /s e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null
    $roblox = Get-Process -Name "RobloxPlayerBeta" -ErrorAction SilentlyContinue
    if ($roblox) { $roblox.PriorityClass = "High"; Write-SLog "   [OK] Roblox priority -> High" }
    else { Write-SLog "   [INFO] Roblox not running - tweaks staged for launch" }
    Write-SLog ">> Roblox Booster Complete"
}

function Invoke-MinecraftBoost {
    Write-SLog ">> Minecraft JVM Optimizer..."
    $jvmArgs = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
    $out = "$env:USERPROFILE\Desktop\SiencyWinOS-MC-JVM-Args.txt"
    $jvmArgs | Out-File -FilePath $out -Encoding UTF8
    Write-SLog "   [OK] JVM args saved -> Desktop\SiencyWinOS-MC-JVM-Args.txt"
    $mc = Get-Process -Name "javaw" -ErrorAction SilentlyContinue
    if ($mc) { foreach ($p in $mc) { $p.PriorityClass = "High" }; Write-SLog "   [OK] Java priority -> High ($($mc.Count) instance)" }
    else { Write-SLog "   [INFO] Minecraft not running - JVM file ready" }
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f 2>$null | Out-Null
    [System.GC]::Collect()
    Write-SLog ">> Minecraft Boost Complete"
}

function Invoke-ValBoost {
    Write-SLog ">> Valorant Boost..."
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f 2>$null | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    ipconfig /flushdns | Out-Null
    Stop-UnnecessaryProcesses
    [System.GC]::Collect()
    $val = Get-Process -Name "VALORANT-Win64-Shipping" -ErrorAction SilentlyContinue
    if ($val) { $val.PriorityClass = "High"; Write-SLog "   [OK] Valorant priority -> High" }
    else { Write-SLog "   [INFO] Valorant not running - tweaks staged" }
    Write-SLog ">> Valorant Boost Complete"
}

function Invoke-KillBackground {
    Invoke-Task "Kill Background Processes" {
        Stop-UnnecessaryProcesses
    }
}

function Invoke-FlushRAM {
    Invoke-Task "RAM Flush" {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    }
}
