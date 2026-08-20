function Invoke-FullOptimization {
    Write-SLog "====== Full Optimization Started ======"
    Invoke-RestorePoint
    Invoke-TempClean
    Invoke-PowerPlan
    Invoke-VisualEffects
    Invoke-RAMOptimization
    Invoke-ProcessorOptimization
    Invoke-StartupCleaner
    Invoke-GameDVRDisable
    Invoke-ServiceOptimization
    Invoke-SSDTrim
    Invoke-RegistryCleaner
    Write-SLog "====== Full Optimization Complete ======"
    Write-SLog "Please restart your device to apply all system changes."
}

function Invoke-TempClean {
    Invoke-Task "Temp Files Clean" {
        $paths = @(
            "$env:TEMP\*", "$env:SystemRoot\Temp\*", "$env:SystemRoot\Prefetch\*",
            "$env:LocalAppData\Microsoft\Windows\INetCache\*",
            "$env:APPDATA\Microsoft\Windows\Recent\*",
            "$env:SystemRoot\SoftwareDistribution\Download\*",
            "$env:SystemRoot\Minidump\*",
            "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*",
            "$env:LocalAppData\Google\Chrome\User Data\Default\Cache\*",
            "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache\*",
            "$env:LocalAppData\Mozilla\Firefox\Profiles\*\cache2\*",
            "$env:LocalAppData\Microsoft\Windows\WebCache\*"
        )
        foreach ($p in $paths) { Remove-Item $p -Force -Recurse -ErrorAction SilentlyContinue }
        Stop-Service wuauserv,bits -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
        Start-Service wuauserv,bits -ErrorAction SilentlyContinue
    }
}

function Invoke-PowerPlan {
    Invoke-Task "Power Plan Optimization" {
        powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        powercfg /s e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 2>$null
        powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 2>$null
        powercfg /setactive scheme_current 2>$null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    }
}

function Invoke-VisualEffects {
    Invoke-Task "Visual Effects" {
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f 2>$null | Out-Null
        reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f 2>$null | Out-Null
        reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f 2>$null | Out-Null
        reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f 2>$null | Out-Null
    }
}

function Invoke-RAMOptimization {
    Invoke-Task "RAM Optimization" {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f 2>$null | Out-Null
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
    }
}

function Invoke-ProcessorOptimization {
    Invoke-Task "Processor Optimization" {
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f 2>$null | Out-Null
        bcdedit /set useplatformtick yes 2>$null | Out-Null
        bcdedit /set disabledynamictick yes 2>$null | Out-Null
        bcdedit /set useplatformclock false 2>$null | Out-Null
        fsutil behavior set disablelastaccess 1 2>$null | Out-Null
        fsutil behavior set disable8dot3 1 2>$null | Out-Null
    }
}

function Invoke-StartupCleaner {
    Invoke-Task "Startup Cleaner" {
        $apps = @("OneDrive","Spotify","Discord","Steam","EpicGamesLauncher","Teams","Zoom","Skype","GoogleDriveFS")
        foreach ($app in $apps) { reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v $app /f 2>$null | Out-Null }
        $tasks = @("MicrosoftEdgeUpdateTaskMachineCore","MicrosoftEdgeUpdateTaskMachineUA","GoogleUpdateTaskMachineCore","GoogleUpdateTaskMachineUA","Adobe Acrobat Update Task")
        foreach ($t in $tasks) { schtasks /Change /TN $t /DISABLE 2>$null | Out-Null }
    }
}

function Invoke-GameDVRDisable {
    Invoke-Task "Game DVR and Xbox Bar Disable" {
        reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    }
}

function Invoke-ServiceOptimization {
    Invoke-Task "Unnecessary Services Disable" {
        $svcs = @("SysMain","WSearch","Fax","XblAuthManager","XblGameSave","XboxGipSvc","XboxNetApiSvc","MapsBroker","RemoteRegistry","TabletInputService","DiagTrack","dmwappushservice")
        foreach ($s in $svcs) {
            Stop-Service $s -Force -ErrorAction SilentlyContinue
            Set-Service $s -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
}

function Invoke-SSDTrim {
    Invoke-Task "SSD TRIM Enable" {
        fsutil behavior set DisableDeleteNotify 0 | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    }
}

function Invoke-RegistryCleaner {
    Invoke-Task "Registry Cleaner" {
        $keys = @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",
            "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache",
            "HKCU:\Software\Microsoft\Windows\ShellNoRoam\MUICache",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StreamMRU",
            "HKCU:\Software\Microsoft\Search Assistant\ACMru",
            "HKCU:\Software\Microsoft\Internet Explorer\TypedURLs"
        )
        foreach ($k in $keys) { Remove-Item $k -Force -Recurse -ErrorAction SilentlyContinue }
        Start-Sleep -Milliseconds 500
        Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | ForEach-Object {
            $ip = $_.GetValue("InstallLocation")
            if ($ip -and (-not (Test-Path $ip))) { Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }
}

function Invoke-RestorePoint {
    Invoke-Task "Create Restore Point" {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "SiencyWinOS Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    }
}

function Invoke-BloatwareRemover {
    Invoke-Task "Bloatware Remover" {
        $apps = @("*xbox*","*bingweather*","*bingnews*","*3dbuilder*","*holographic*","*solitaire*","*feedbackhub*","*windowsmaps*","*yourphone*","*CandyCrush*","*TikTok*","*Disney*","*gethelp*","*advertising*","*onenote*")
        foreach ($app in $apps) { Get-AppxPackage $app -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue }
    }
}

function Invoke-DiskClean {
    Invoke-Task "Disk Cleanup" {
        Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        Start-Process "Dism.exe" -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
}

function Invoke-GPUOptimization {
    Invoke-Task "GPU Optimization" {
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f 2>$null | Out-Null
        reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d 8 /f 2>$null | Out-Null
        $gpu = (Get-WmiObject Win32_VideoController | Select-Object -First 1).Name
        Write-SLog "   GPU Detected: $gpu"
        if ($gpu -like "*NVIDIA*") {
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PerfLevelSrc" /t REG_DWORD /d 8738 /f 2>$null | Out-Null
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t REG_DWORD /d 1 /f 2>$null | Out-Null
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f 2>$null | Out-Null
            Write-SLog "   [OK] NVIDIA tweaks applied"
        } elseif ($gpu -like "*AMD*" -or $gpu -like "*Radeon*") {
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d 0 /f 2>$null | Out-Null
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d 0 /f 2>$null | Out-Null
            Write-SLog "   [OK] AMD tweaks applied"
        } elseif ($gpu -like "*Intel*") {
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d 1 /f 2>$null | Out-Null
            Write-SLog "   [OK] Intel GPU tweaks applied"
        }
    }
}

function Invoke-AudioOptimization {
    Invoke-Task "Audio Optimization" {
        $audioTasks = @("Audio","Playback","Pro Audio")
        foreach ($task in $audioTasks) {
            $p = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\$task"
            reg add $p /v "Scheduling Category" /t REG_SZ /d "High" /f 2>$null | Out-Null
            reg add $p /v "Priority" /t REG_DWORD /d 6 /f 2>$null | Out-Null
            reg add $p /v "SFIO Priority" /t REG_SZ /d "High" /f 2>$null | Out-Null
            reg add $p /v "Background Only" /t REG_SZ /d "False" /f 2>$null | Out-Null
            reg add $p /v "Clock Rate" /t REG_DWORD /d 10000 /f 2>$null | Out-Null
        }
        reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f 2>$null | Out-Null
        Start-Service AudioSrv,AudioEndpointBuilder -ErrorAction SilentlyContinue
    }
}

function Invoke-DisplayOptimization {
    Invoke-Task "Display Optimization" {
        reg add "HKCU\Control Panel\Desktop" /v "Win8DpiScaling" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f 2>$null | Out-Null
    }
}
