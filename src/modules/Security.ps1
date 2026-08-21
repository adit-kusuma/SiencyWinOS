function Invoke-SecurityScan {
    Write-SLog ">> Security Scan..."
    # Check Windows Defender status
    try {
        $defender = Get-MpComputerStatus -ErrorAction Stop
        Write-SLog "   Defender: $($defender.AMServiceEnabled) | RealTime: $($defender.RealTimeProtectionEnabled)"
        Write-SLog "   Definitions: $($defender.AntivirusSignatureLastUpdated)"
        Write-SLog "   Quick Scan: $($defender.QuickScanStartTime)"
    } catch { Write-SLog "   [INFO] Could not get Defender status" }
    # Check firewall
    try {
        $fw = Get-NetFirewallProfile -ErrorAction Stop
        foreach ($f in $fw) { Write-SLog "   Firewall [$($f.Name)]: $($f.Enabled)" }
    } catch { Write-SLog "   [INFO] Could not get Firewall status" }
    # Check open ports
    Write-SLog "   Checking listening ports..."
    try {
        $ports = Get-NetTCPConnection -State Listen -ErrorAction Stop | Select-Object LocalPort,OwningProcess |
            Sort-Object LocalPort | Select-Object -First 15
        foreach ($p in $ports) {
            try {
                $proc = Get-Process -Id $p.OwningProcess -ErrorAction SilentlyContinue
                Write-SLog "   Port $($p.LocalPort) <- $($proc.Name)"
            } catch { Write-SLog "   Port $($p.LocalPort) <- PID $($p.OwningProcess)" }
        }
    } catch {}
    Write-SLog ">> Security Scan Complete"
}

function Invoke-EnableDefender {
    Invoke-Task "Enable Windows Defender" {
        Set-Service WinDefend -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service WinDefend -ErrorAction SilentlyContinue
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
        Write-SLog "   Windows Defender enabled"
    }
}

function Invoke-EnableFirewall {
    Invoke-Task "Enable Firewall" {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction SilentlyContinue
        Write-SLog "   Firewall enabled on all profiles"
    }
}

function Invoke-DefenderScan {
    Invoke-Task "Quick Defender Scan" {
        Start-MpScan -ScanType QuickScan -ErrorAction SilentlyContinue
        Write-SLog "   Defender quick scan started in background"
    }
}
