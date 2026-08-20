function Get-DiskHealth {
    Write-SLog ">> Disk Health Check..."
    try {
        $disks = Get-PhysicalDisk -ErrorAction SilentlyContinue
        foreach ($d in $disks) {
            Write-SLog "   Disk   : $($d.FriendlyName)"
            Write-SLog "   Size   : $([math]::Round($d.Size/1GB,1)) GB | Media: $($d.MediaType)"
            Write-SLog "   Health : $($d.HealthStatus) | Status: $($d.OperationalStatus)"
        }
        Get-Volume -ErrorAction SilentlyContinue | Where-Object { $_.DriveLetter } | ForEach-Object {
            Write-SLog "   Drive $($_.DriveLetter): Free $([math]::Round($_.SizeRemaining/1GB,1)) GB / $([math]::Round($_.Size/1GB,1)) GB - $($_.HealthStatus)"
        }
    } catch { Write-SLog "   [ERR] Could not read disk info" }
    fsutil behavior set DisableDeleteNotify 0 | Out-Null
    Write-SLog "   [OK] TRIM enabled"
}

function Invoke-SFCScan {
    Invoke-Task "SFC System Scan" {
        Start-Process "sfc" -ArgumentList "/scannow" -Wait -WindowStyle Hidden
    }
}

function Invoke-DISMRepair {
    Invoke-Task "DISM Health Repair" {
        Start-Process "Dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -WindowStyle Hidden
    }
}

function Invoke-DirectXRepair {
    Invoke-Task "DirectX and Visual C++ Repair" {
        $dlls = @(
            "$env:SystemRoot\System32\d3d*.dll",
            "$env:SystemRoot\System32\dxgi*.dll",
            "$env:SystemRoot\SysWOW64\d3d*.dll",
            "$env:SystemRoot\SysWOW64\dxgi*.dll",
            "$env:SystemRoot\System32\msvc*.dll",
            "$env:SystemRoot\System32\vcruntime*.dll",
            "$env:SystemRoot\SysWOW64\msvc*.dll",
            "$env:SystemRoot\SysWOW64\vcruntime*.dll"
        )
        foreach ($pattern in $dlls) {
            Get-Item $pattern -ErrorAction SilentlyContinue | ForEach-Object { regsvr32 /s $_.FullName 2>$null }
        }
    }
}
