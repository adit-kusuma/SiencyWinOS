function Invoke-FullRepair {
    Write-SLog "====== Full System Repair Started ======"
    Invoke-SFCScan
    Invoke-DISMRepair
    Invoke-DirectXRepair
    Invoke-NetworkRepair
    Invoke-FontRepair
    Write-SLog "====== Full System Repair Complete ======"
}

function Invoke-NetworkRepair {
    Invoke-Task "Network Stack Repair" {
        netsh winsock reset 2>$null | Out-Null
        netsh int ip reset 2>$null | Out-Null
        netsh int tcp reset 2>$null | Out-Null
        ipconfig /flushdns | Out-Null
        ipconfig /release 2>$null | Out-Null
        ipconfig /renew 2>$null | Out-Null
        Write-SLog "   Winsock, IP stack, TCP stack reset. DNS flushed, IP renewed."
    }
}

function Invoke-FontRepair {
    Invoke-Task "Font Cache Repair" {
        Stop-Service FontCache -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\FNTCACHE.DAT" -Force -ErrorAction SilentlyContinue
        Start-Service FontCache -ErrorAction SilentlyContinue
        Write-SLog "   Font cache cleared and rebuilt"
    }
}

function Invoke-WindowsUpdateRepair {
    Invoke-Task "Windows Update Repair" {
        Stop-Service wuauserv,bits,cryptsvc,msiserver -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\catroot2\*" -Force -Recurse -ErrorAction SilentlyContinue
        regsvr32 /s wuaueng.dll 2>$null
        regsvr32 /s wuaueng1.dll 2>$null
        regsvr32 /s atl.dll 2>$null
        regsvr32 /s wucltui.dll 2>$null
        regsvr32 /s wups.dll 2>$null
        regsvr32 /s wups2.dll 2>$null
        regsvr32 /s wuweb.dll 2>$null
        Start-Service wuauserv,bits,cryptsvc -ErrorAction SilentlyContinue
        Write-SLog "   Windows Update components reset and re-registered"
    }
}

function Invoke-IconCacheRepair {
    Invoke-Task "Icon Cache Repair" {
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\Explorer\iconcache_*" -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue
        Start-Process explorer
        Write-SLog "   Icon and thumbnail cache cleared, Explorer restarted"
    }
}
