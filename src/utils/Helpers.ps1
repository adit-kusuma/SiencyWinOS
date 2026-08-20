function Invoke-Task {
    param([string]$Label, [scriptblock]$Task)
    Write-SLog ">> $Label"
    try {
        & $Task
        Write-SLog "   [OK] $Label" "OK"
    } catch {
        Write-SLog "   [ERR] $Label : $_" "ERR"
    }
}

function Get-SystemSnapshot {
    $os  = Get-WmiObject Win32_OperatingSystem
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
    $freeRAM  = [math]::Round($os.FreePhysicalMemory / 1024)
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1024)
    $usedRAM  = $totalRAM - $freeRAM
    $cpuLoad  = ($cpu | Measure-Object -Property LoadPercentage -Average).Average
    $refresh  = $gpu.CurrentRefreshRate
    $cpuTemp  = "N/A"
    try {
        $t = (Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" -EA Stop).CurrentTemperature
        $cpuTemp = "$([math]::Round(($t[0]-2732)/10,1)) C"
    } catch {}
    $gpuTemp = "N/A"
    try {
        $g = Get-WmiObject -Namespace "root\OpenHardwareMonitor" -Class Sensor -EA Stop |
             Where-Object { $_.SensorType -eq "Temperature" -and $_.Name -like "*GPU*" } |
             Select-Object -First 1
        if ($g) { $gpuTemp = "$([math]::Round($g.Value,1)) C" }
    } catch {}
    return @{
        UsedRAM  = $usedRAM
        TotalRAM = $totalRAM
        FreeRAM  = $freeRAM
        CPULoad  = $cpuLoad
        CPUTemp  = $cpuTemp
        GPUTemp  = $gpuTemp
        Refresh  = $refresh
    }
}

function Get-FullSystemInfo {
    $os  = Get-WmiObject Win32_OperatingSystem
    $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
    $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
    $ram = [math]::Round($os.TotalVisibleMemorySize/1MB,1)
    $freeRam = [math]::Round($os.FreePhysicalMemory/1MB,1)
    $disk = Get-PSDrive C
    $uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
    return @"
OS           : $($os.Caption) $($os.OSArchitecture)
Build        : $($os.BuildNumber)
CPU          : $($cpu.Name)
CPU Cores    : $($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads
CPU Speed    : $([math]::Round($cpu.MaxClockSpeed/1000,2)) GHz
GPU          : $($gpu.Name)
VRAM         : $([math]::Round($gpu.AdapterRAM/1GB,1)) GB
RAM Total    : $ram GB
RAM Free     : $freeRam GB
RAM Used     : $([math]::Round($ram-$freeRam,1)) GB
Disk C Used  : $([math]::Round($disk.Used/1GB,1)) GB
Disk C Free  : $([math]::Round($disk.Free/1GB,1)) GB
Resolution   : $($gpu.CurrentHorizontalResolution) x $($gpu.CurrentVerticalResolution)
Refresh Rate : $($gpu.CurrentRefreshRate) Hz
Uptime       : $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m
"@
}
