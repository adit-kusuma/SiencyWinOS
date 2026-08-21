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
            Write-SLog "   Drive $($_.DriveLetter): Free $([math]::Round($_.SizeRemaining/1GB,1)) GB / $([math]::Round($_.Size/1GB,1)) GB  [$($_.HealthStatus)]"
        }
    } catch { Write-SLog "   [ERR] Could not read disk info" }
    fsutil behavior set DisableDeleteNotify 0 | Out-Null
    Write-SLog "   [OK] TRIM enabled"
}

function Invoke-SFCScan {
    Invoke-Task "SFC System Scan" {
        Write-SLog "   Running sfc /scannow (this may take a few minutes)..."
        Start-Process "sfc" -ArgumentList "/scannow" -Wait -WindowStyle Hidden
        Write-SLog "   SFC scan complete"
    }
}

function Invoke-DISMRepair {
    Invoke-Task "DISM Health Repair" {
        Write-SLog "   Running DISM RestoreHealth (this may take several minutes)..."
        Start-Process "Dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -WindowStyle Hidden
        Write-SLog "   DISM repair complete"
    }
}

function Invoke-DirectXRepair {
    Invoke-Task "DirectX and Visual C++ Repair" {
        $patterns = @(
            "$env:SystemRoot\System32\d3d*.dll",  "$env:SystemRoot\System32\dxgi*.dll",
            "$env:SystemRoot\SysWOW64\d3d*.dll",  "$env:SystemRoot\SysWOW64\dxgi*.dll",
            "$env:SystemRoot\System32\msvc*.dll",  "$env:SystemRoot\System32\vcruntime*.dll",
            "$env:SystemRoot\SysWOW64\msvc*.dll",  "$env:SystemRoot\SysWOW64\vcruntime*.dll"
        )
        $count = 0
        foreach ($p in $patterns) { Get-Item $p -ErrorAction SilentlyContinue | ForEach-Object { regsvr32 /s $_.FullName 2>$null; $count++ } }
        Write-SLog "   Re-registered $count DLL files"
    }
}

function Get-InstalledSoftware {
    $software = @()
    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    foreach ($path in $paths) {
        Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } |
        ForEach-Object {
            $software += [PSCustomObject]@{
                Name      = $_.DisplayName
                Version   = $_.DisplayVersion
                Publisher = $_.Publisher
                Size      = if ($_.EstimatedSize) { "$([math]::Round($_.EstimatedSize/1024,1)) MB" } else { "N/A" }
                UninstallString = $_.UninstallString
            }
        }
    }
    return $software | Sort-Object Name -Unique
}

function Invoke-UninstallSoftware {
    param([string]$UninstallString, [string]$Name)
    Write-SLog ">> Uninstalling $Name..."
    try {
        if ($UninstallString -match "msiexec") {
            $args = $UninstallString -replace "msiexec.exe","" -replace "MsiExec.exe",""
            $args = $args.Trim() + " /quiet /norestart"
            Start-Process "msiexec.exe" -ArgumentList $args -Wait -WindowStyle Hidden
        } else {
            Start-Process "cmd.exe" -ArgumentList "/c `"$UninstallString`" /S /silent /quiet" -Wait -WindowStyle Hidden
        }
        Write-SLog "   [OK] $Name uninstalled"
    } catch { Write-SLog "   [ERR] Could not uninstall $Name" }
}

function Get-StartupPrograms {
    $items = @()
    $regPaths = @(
        @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; Scope="Current User"},
        @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; Scope="All Users"},
        @{Path="HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"; Scope="All Users (32bit)"}
    )
    foreach ($rp in $regPaths) {
        $props = Get-ItemProperty $rp.Path -ErrorAction SilentlyContinue
        if ($props) {
            $props.PSObject.Properties | Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
                $items += [PSCustomObject]@{ Name=$_.Name; Path=$_.Value; Scope=$rp.Scope; RegPath=$rp.Path }
            }
        }
    }
    return $items
}

function Disable-StartupItem {
    param([string]$Name, [string]$RegPath)
    Invoke-Task "Disable startup: $Name" {
        Remove-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue
    }
}
