function Get-PerformanceReport {
    Write-SLog ">> Generating Performance Report..."
    $os  = Get-WmiObject Win32_OperatingSystem
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
    # CPU
    $cpuLoad = ($cpu | Measure-Object -Property LoadPercentage -Average).Average
    Write-SLog "   CPU: $($cpu.Name)"
    Write-SLog "   CPU Load: $cpuLoad%  |  Cores: $($cpu.NumberOfCores)  |  Threads: $($cpu.NumberOfLogicalProcessors)"
    Write-SLog "   CPU Speed: $([math]::Round($cpu.MaxClockSpeed/1000,2)) GHz"
    # RAM
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB,1)
    $freeRAM  = [math]::Round($os.FreePhysicalMemory/1MB,1)
    $usedRAM  = [math]::Round($totalRAM - $freeRAM,1)
    $ramPct   = [math]::Round(($usedRAM/$totalRAM)*100,1)
    Write-SLog "   RAM: $usedRAM GB / $totalRAM GB used ($ramPct%)"
    # GPU
    Write-SLog "   GPU: $($gpu.Name)"
    Write-SLog "   VRAM: $([math]::Round($gpu.AdapterRAM/1GB,1)) GB"
    Write-SLog "   Resolution: $($gpu.CurrentHorizontalResolution)x$($gpu.CurrentVerticalResolution) @ $($gpu.CurrentRefreshRate)Hz"
    # Disk
    Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
        $used = [math]::Round($_.Used/1GB,1)
        $free = [math]::Round($_.Free/1GB,1)
        $total = $used + $free
        if ($total -gt 0) { Write-SLog "   Drive $($_.Name): $used GB used / $total GB ($free GB free)" }
    }
    # Top processes
    Write-SLog "   --- Top 5 CPU Processes ---"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | ForEach-Object {
        Write-SLog "   $($_.Name.PadRight(20)) CPU: $([math]::Round($_.CPU,1))s  RAM: $([math]::Round($_.WorkingSet64/1MB,1)) MB"
    }
    Write-SLog "   --- Top 5 RAM Processes ---"
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 | ForEach-Object {
        Write-SLog "   $($_.Name.PadRight(20)) RAM: $([math]::Round($_.WorkingSet64/1MB,1)) MB"
    }
    # Uptime
    $uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
    Write-SLog "   Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
    Write-SLog ">> Performance Report Complete"
}

function Get-BatteryStatus {
    Write-SLog ">> Battery Status..."
    try {
        $bat = Get-WmiObject Win32_Battery -ErrorAction Stop
        if ($bat) {
            Write-SLog "   Status: $($bat.BatteryStatus)"
            Write-SLog "   Charge: $($bat.EstimatedChargeRemaining)%"
            Write-SLog "   Time Remaining: $([math]::Round($bat.EstimatedRunTime/60,1)) hours"
        } else {
            Write-SLog "   No battery detected (desktop PC)"
        }
    } catch { Write-SLog "   Could not read battery info" }
}
