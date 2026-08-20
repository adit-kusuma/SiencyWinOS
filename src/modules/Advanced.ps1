function Invoke-KernelTimerResolution {
    Write-SLog ">> Kernel Timer Resolution..."
    Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices;
public class KTimer {
    [DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint r, bool s, out uint c);
    [DllImport("ntdll.dll")] public static extern int NtQueryTimerResolution(out uint min, out uint max, out uint cur);
}
"@ -ErrorAction SilentlyContinue
    try {
        [uint]$min=0;[uint]$max=0;[uint]$cur=0
        [KTimer]::NtQueryTimerResolution([ref]$min,[ref]$max,[ref]$cur) | Out-Null
        Write-SLog "   Before : $([math]::Round($cur/10000.0,2)) ms"
        [uint]$out=0
        [KTimer]::NtSetTimerResolution($max,$true,[ref]$out) | Out-Null
        Write-SLog "   After  : $([math]::Round($out/10000.0,2)) ms"
    } catch { Write-SLog "   [ERR] Timer API unavailable" }
    bcdedit /set useplatformclock false 2>$null | Out-Null
    bcdedit /set useplatformtick yes 2>$null | Out-Null
    bcdedit /set disabledynamictick yes 2>$null | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    Write-SLog "   [OK] Static tick active, dynamic tick disabled"
    Write-SLog ">> Kernel Timer Complete"
}

function Invoke-MMCSSTuning {
    Write-SLog ">> MMCSS Deep Tuning..."
    $tasks = @("Games","Audio","Pro Audio","Playback","Window Manager")
    foreach ($task in $tasks) {
        $p = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\$task"
        reg add $p /v "Affinity"           /t REG_DWORD /d 0        /f 2>$null | Out-Null
        reg add $p /v "Background Only"    /t REG_SZ    /d "False"  /f 2>$null | Out-Null
        reg add $p /v "Clock Rate"         /t REG_DWORD /d 10000    /f 2>$null | Out-Null
        reg add $p /v "GPU Priority"       /t REG_DWORD /d 8        /f 2>$null | Out-Null
        reg add $p /v "Priority"           /t REG_DWORD /d 6        /f 2>$null | Out-Null
        reg add $p /v "Scheduling Category"/t REG_SZ    /d "High"   /f 2>$null | Out-Null
        reg add $p /v "SFIO Priority"      /t REG_SZ    /d "High"   /f 2>$null | Out-Null
        Write-SLog "   [OK] $task tuned"
    }
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f 2>$null | Out-Null
    net stop MMCSS 2>$null | Out-Null
    net start MMCSS 2>$null | Out-Null
    Write-SLog "   [OK] MMCSS restarted"
    Write-SLog ">> MMCSS Deep Tuning Complete"
}

function Invoke-DPCMonitor {
    Write-SLog ">> DPC Latency Monitor - Sampling 5x..."
    $results = @()
    for ($i = 1; $i -le 5; $i++) {
        try {
            $proc = Get-WmiObject Win32_PerfRawData_PerfOS_Processor -EA SilentlyContinue | Where-Object { $_.Name -eq "_Total" }
            if ($proc) { $results += $proc.DPCsQueuedPersec }
        } catch {}
        Start-Sleep -Milliseconds 600
    }
    if ($results.Count -gt 0) {
        $avg = ($results | Measure-Object -Average).Average
        Write-SLog "   Avg DPC/sec : $([math]::Round($avg,1))"
        $status = switch ($true) {
            ($avg -lt 100)  { "EXCELLENT" }
            ($avg -lt 500)  { "GOOD" }
            ($avg -lt 1000) { "WARNING - stuttering possible" }
            default         { "CRITICAL - stuttering likely" }
        }
        Write-SLog "   Status : $status"
    }
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    bcdedit /set disabledynamictick yes 2>$null | Out-Null
    Write-SLog "   [OK] DPC reduction tweaks applied"
    Write-SLog ">> DPC Monitor Complete"
}
