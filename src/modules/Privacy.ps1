function Invoke-PrivacyClean {
    Invoke-Task "Privacy Clean" {
        Stop-Service DiagTrack,dmwappushservice,PcaSvc,RemoteRegistry -Force -ErrorAction SilentlyContinue
        Set-Service DiagTrack,dmwappushservice,PcaSvc,RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityHistory" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityHistory" /v "PublishUserActivities" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\INetCache\*" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\WebCache\*" -Force -Recurse -ErrorAction SilentlyContinue
    }
}
