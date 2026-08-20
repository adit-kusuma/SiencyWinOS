$global:LogBuffer = [System.Collections.Generic.List[string]]::new()
$global:LogControl = $null

function Write-SLog {
    param([string]$Message, [string]$Level = "INFO")
    $time = Get-Date -Format "HH:mm:ss"
    $entry = "[$time][$Level] $Message"
    $global:LogBuffer.Add($entry)
    if ($global:LogControl) {
        $global:LogControl.Dispatcher.Invoke([action]{
            $global:LogControl.Text += "$entry`n"
            $global:LogControl.Parent.ScrollToEnd()
        })
    }
}

function Clear-SLog {
    $global:LogBuffer.Clear()
    if ($global:LogControl) {
        $global:LogControl.Dispatcher.Invoke([action]{ $global:LogControl.Text = "" })
    }
}
