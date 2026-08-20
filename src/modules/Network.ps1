function Invoke-NetworkOptimization {
    Invoke-Task "Network Optimization" {
        ipconfig /flushdns | Out-Null
        netsh int tcp set global autotuninglevel=normal 2>$null | Out-Null
        netsh int tcp set global ecncapability=enabled 2>$null | Out-Null
        netsh int tcp set global timestamps=disabled 2>$null | Out-Null
        netsh int tcp set global rss=enabled 2>$null | Out-Null
        netsh int tcp set global chimney=enabled 2>$null | Out-Null
        netsh winsock reset 2>$null | Out-Null
        netsh int ip reset 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d 384 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheEntryTtlLimit" /t REG_DWORD /d 64000 /f 2>$null | Out-Null
    }
}

function Set-DNSServer {
    param([string]$Primary, [string]$Secondary)
    Invoke-Task "Set DNS $Primary" {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        if ($adapter) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses ($Primary,$Secondary) -ErrorAction SilentlyContinue
            ipconfig /flushdns | Out-Null
            Write-SLog "   DNS -> $Primary / $Secondary on $($adapter.Name)"
        }
    }
}

function Reset-DNSAuto {
    Invoke-Task "Reset DNS to DHCP" {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        if ($adapter) { Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue }
        ipconfig /flushdns | Out-Null
    }
}

function Disable-WindowsUpdate {
    Invoke-Task "Disable Windows Update" {
        Stop-Service wuauserv,UsoSvc,bits -Force -ErrorAction SilentlyContinue
        Set-Service wuauserv,UsoSvc -StartupType Disabled -ErrorAction SilentlyContinue
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE 2>$null | Out-Null
    }
}

function Enable-WindowsUpdate {
    Invoke-Task "Enable Windows Update" {
        Set-Service wuauserv,UsoSvc,bits -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service wuauserv,UsoSvc,bits -ErrorAction SilentlyContinue
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f 2>$null | Out-Null
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /f 2>$null | Out-Null
        schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /ENABLE 2>$null | Out-Null
    }
}

function Reset-WindowsUpdate {
    Invoke-Task "Reset Windows Update" {
        Stop-Service wuauserv,bits,cryptsvc,msiserver -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\catroot2\*" -Force -Recurse -ErrorAction SilentlyContinue
        Start-Service wuauserv,bits,cryptsvc -ErrorAction SilentlyContinue
    }
}
