$global:ThemeIsDark = $true

$global:DarkTheme = @{
    BG           = "#0F0F0F"
    BGSecondary  = "#1A1A1A"
    BGCard       = "#161616"
    Border       = "#2A2A2A"
    Accent       = "#00CC66"
    AccentHover  = "#00FF88"
    TextPrimary  = "#EEEEEE"
    TextSecondary= "#888888"
    TextAccent   = "#00CC66"
    ButtonBG     = "#1E1E1E"
    ButtonBorder = "#333333"
    LogBG        = "#0A0A0A"
    LogText      = "#00CC66"
    Warning      = "#FF8800"
    Danger       = "#FF4444"
    Info         = "#4488FF"
}

$global:LightTheme = @{
    BG           = "#F5F5F5"
    BGSecondary  = "#FFFFFF"
    BGCard       = "#FAFAFA"
    Border       = "#DDDDDD"
    Accent       = "#007A3D"
    AccentHover  = "#009A4D"
    TextPrimary  = "#111111"
    TextSecondary= "#666666"
    TextAccent   = "#007A3D"
    ButtonBG     = "#EEEEEE"
    ButtonBorder = "#CCCCCC"
    LogBG        = "#F0F0F0"
    LogText      = "#007A3D"
    Warning      = "#CC6600"
    Danger       = "#CC2222"
    Info         = "#2255CC"
}

function Get-Theme {
    if ($global:ThemeIsDark) { return $global:DarkTheme }
    return $global:LightTheme
}

function Toggle-Theme {
    $global:ThemeIsDark = -not $global:ThemeIsDark
}
