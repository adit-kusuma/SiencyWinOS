Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

function Start-SiencyWinOS {
    $t = Get-Theme

    $xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="SiencyWinOS Optimizer v2.0"
    Height="780" Width="1100"
    MinHeight="640" MinWidth="900"
    WindowStartupLocation="CenterScreen"
    Background="$($t.BG)"
    FontFamily="Segoe UI">
    <Window.Resources>
        <Style x:Key="Btn" TargetType="Button">
            <Setter Property="Background" Value="$($t.ButtonBG)"/>
            <Setter Property="Foreground" Value="$($t.TextPrimary)"/>
            <Setter Property="BorderBrush" Value="$($t.ButtonBorder)"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Height" Value="34"/>
            <Setter Property="Margin" Value="3"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="8,0"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="$($t.Accent)"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                                <Setter TargetName="bd" Property="BorderBrush" Value="$($t.Accent)"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="$($t.AccentHover)"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Foreground" Value="$($t.TextSecondary)"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="BtnAccent" TargetType="Button" BasedOn="{StaticResource Btn}">
            <Setter Property="Background" Value="$($t.Accent)"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="$($t.Accent)"/>
        </Style>
        <Style x:Key="BtnDanger" TargetType="Button" BasedOn="{StaticResource Btn}">
            <Setter Property="Foreground" Value="$($t.Danger)"/>
            <Setter Property="BorderBrush" Value="$($t.Danger)"/>
        </Style>
        <Style x:Key="BtnWarn" TargetType="Button" BasedOn="{StaticResource Btn}">
            <Setter Property="Foreground" Value="$($t.Warning)"/>
            <Setter Property="BorderBrush" Value="$($t.Warning)"/>
        </Style>
        <Style x:Key="TabStyle" TargetType="TabItem">
            <Setter Property="Foreground" Value="$($t.TextSecondary)"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="12,8"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border x:Name="tb" Background="Transparent" BorderThickness="0,0,0,2" BorderBrush="Transparent" Padding="12,8">
                            <TextBlock x:Name="txt" Text="{TemplateBinding Header}" Foreground="$($t.TextSecondary)" FontWeight="SemiBold" FontSize="12"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="tb" Property="BorderBrush" Value="$($t.Accent)"/>
                                <Setter TargetName="txt" Property="Foreground" Value="$($t.Accent)"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="txt" Property="Foreground" Value="$($t.TextPrimary)"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="Card" TargetType="Border">
            <Setter Property="Background" Value="$($t.BGCard)"/>
            <Setter Property="BorderBrush" Value="$($t.Border)"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="6"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Margin" Value="4"/>
        </Style>
        <Style x:Key="SLabel" TargetType="TextBlock">
            <Setter Property="Foreground" Value="$($t.TextSecondary)"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Margin" Value="2,8,2,3"/>
        </Style>
        <Style x:Key="ChkStyle" TargetType="CheckBox">
            <Setter Property="Foreground" Value="$($t.TextPrimary)"/>
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="Margin" Value="2,2"/>
            <Setter Property="Cursor" Value="Hand"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="60"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="155"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Border Grid.Row="0" Background="$($t.BGSecondary)" BorderBrush="$($t.Border)" BorderThickness="0,0,0,1">
            <Grid Margin="14,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0" VerticalAlignment="Center">
                    <TextBlock Text="SiencyWinOS" FontSize="18" FontWeight="Bold" Foreground="$($t.Accent)"/>
                    <TextBlock Text="Windows Performance Optimizer  v2.0" FontSize="10" Foreground="$($t.TextSecondary)"/>
                </StackPanel>
                <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Center" VerticalAlignment="Center">
                    <Border Style="{StaticResource Card}" Margin="4,0" Padding="8,4">
                        <StackPanel>
                            <TextBlock x:Name="txtHeaderCPU"  Text="CPU: --%"        FontSize="11" Foreground="$($t.TextPrimary)"/>
                            <TextBlock x:Name="txtHeaderRAM"  Text="RAM: -- / -- MB" FontSize="11" Foreground="$($t.TextPrimary)"/>
                        </StackPanel>
                    </Border>
                    <Border Style="{StaticResource Card}" Margin="4,0" Padding="8,4">
                        <StackPanel>
                            <TextBlock x:Name="txtHeaderCPUTemp" Text="CPU Temp: --" FontSize="11" Foreground="$($t.Warning)"/>
                            <TextBlock x:Name="txtHeaderGPUTemp" Text="GPU Temp: --" FontSize="11" Foreground="$($t.Warning)"/>
                        </StackPanel>
                    </Border>
                    <Border Style="{StaticResource Card}" Margin="4,0" Padding="8,4">
                        <StackPanel>
                            <TextBlock x:Name="txtHeaderUptime" Text="Uptime: --" FontSize="11" Foreground="$($t.TextSecondary)"/>
                            <TextBlock x:Name="txtHeaderDisk"   Text="Disk C: --"  FontSize="11" Foreground="$($t.TextSecondary)"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
                <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button x:Name="btnToggleTheme" Content="Toggle Theme" Style="{StaticResource Btn}" Width="110" Height="28" Margin="4,0"/>
                    <Button x:Name="btnClearLog"    Content="Clear Log"    Style="{StaticResource Btn}" Width="80"  Height="28" Margin="4,0"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- TABS -->
        <TabControl Grid.Row="1" Background="$($t.BG)" BorderThickness="0" Margin="6,4,6,0">

            <!-- TAB: OPTIMIZE -->
            <TabItem Header="Optimize" Style="{StaticResource TabStyle}">
                <ScrollViewer VerticalScrollBarVisibility="Auto" Background="$($t.BG)">
                    <Grid Margin="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Border Grid.Column="0" Style="{StaticResource Card}">
                            <StackPanel>
                                <TextBlock Text="SYSTEM" Style="{StaticResource SLabel}"/>
                                <Button x:Name="btnFullOpt"      Content="Full Optimization"    Style="{StaticResource BtnAccent}"/>
                                <Button x:Name="btnTempClean"    Content="Temp Files Clean"     Style="{StaticResource Btn}"/>
                                <Button x:Name="btnRestorePoint" Content="Create Restore Point" Style="{StaticResource Btn}"/>
                                <Button x:Name="btnStartup"      Content="Startup Cleaner"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnSFCScan"      Content="SFC System Scan"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDISM"         Content="DISM Health Repair"   Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDiskClean"    Content="Disk Cleanup"         Style="{StaticResource Btn}"/>
                                <Button x:Name="btnIconCache"    Content="Icon Cache Repair"    Style="{StaticResource Btn}"/>
                                <Button x:Name="btnFontRepair"   Content="Font Cache Repair"    Style="{StaticResource Btn}"/>
                                <Button x:Name="btnWURepair"     Content="Windows Update Repair" Style="{StaticResource Btn}"/>
                            </StackPanel>
                        </Border>
                        <Border Grid.Column="1" Style="{StaticResource Card}">
                            <StackPanel>
                                <TextBlock Text="HARDWARE" Style="{StaticResource SLabel}"/>
                                <Button x:Name="btnRAM"       Content="RAM Optimization"       Style="{StaticResource Btn}"/>
                                <Button x:Name="btnProcessor" Content="Processor Optimization" Style="{StaticResource Btn}"/>
                                <Button x:Name="btnGPU"       Content="GPU Optimization"       Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDisplay"   Content="Display Optimizer"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnAudio"     Content="Audio Optimization"     Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDisk"      Content="Disk Health Check"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDXRepair"  Content="DirectX and VC++ Repair" Style="{StaticResource Btn}"/>
                                <Button x:Name="btnPowerPlan" Content="Power Plan High Perf"   Style="{StaticResource Btn}"/>
                                <Button x:Name="btnBattery"   Content="Battery Status"         Style="{StaticResource Btn}"/>
                            </StackPanel>
                        </Border>
                        <Border Grid.Column="2" Style="{StaticResource Card}">
                            <StackPanel>
                                <TextBlock Text="ADVANCED" Style="{StaticResource SLabel}"/>
                                <Button x:Name="btnPrivacy"     Content="Privacy Clean"          Style="{StaticResource Btn}"/>
                                <Button x:Name="btnTweaks"      Content="Full System Tweaks"     Style="{StaticResource Btn}"/>
                                <Button x:Name="btnRegistry"    Content="Registry Cleaner"       Style="{StaticResource Btn}"/>
                                <Button x:Name="btnKernelTimer" Content="Kernel Timer Resolution" Style="{StaticResource Btn}"/>
                                <Button x:Name="btnMMCSS"       Content="MMCSS Deep Tuning"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnDPC"         Content="DPC Latency Monitor"    Style="{StaticResource Btn}"/>
                                <Button x:Name="btnSSDTrim"     Content="Enable SSD TRIM"        Style="{StaticResource Btn}"/>
                                <Button x:Name="btnServices"    Content="Service Optimizer"      Style="{StaticResource Btn}"/>
                                <Button x:Name="btnPerfReport"  Content="Performance Report"     Style="{StaticResource Btn}"/>
                            </StackPanel>
                        </Border>
                    </Grid>
                </ScrollViewer>
            </TabItem>

            <!-- TAB: GAMING -->
            <TabItem Header="Gaming" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Button x:Name="btnGamingStart" Grid.Column="0" Content="START GAMING MODE" Style="{StaticResource BtnAccent}" Width="180" Height="38" Margin="0,0,8,0"/>
                            <Button x:Name="btnGamingStop"  Grid.Column="1" Content="STOP"              Style="{StaticResource BtnDanger}" Width="80"  Height="38" IsEnabled="False" Margin="0,0,8,0"/>
                            <StackPanel Grid.Column="2" VerticalAlignment="Center">
                                <TextBlock x:Name="txtGamingStatus" Text="Status: Inactive" FontWeight="Bold" FontSize="13" Foreground="$($t.Danger)"/>
                                <TextBlock x:Name="txtGamingCycle"  Text="Cycles: 0"        FontSize="11"     Foreground="$($t.TextSecondary)"/>
                            </StackPanel>
                        </Grid>
                    </Border>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="240"/>
                        </Grid.ColumnDefinitions>
                        <Border Grid.Column="0" Style="{StaticResource Card}" Margin="4,2,2,4">
                            <StackPanel>
                                <TextBlock Text="GAME BOOST" Style="{StaticResource SLabel}"/>
                                <Button x:Name="btnRobloxBoost"    Content="Roblox Booster"          Style="{StaticResource BtnWarn}"/>
                                <Button x:Name="btnMinecraftBoost" Content="Minecraft JVM Optimizer" Style="{StaticResource BtnWarn}"/>
                                <Button x:Name="btnValBoost"       Content="Valorant Boost"           Style="{StaticResource BtnWarn}"/>
                                <Button x:Name="btnKillBG"         Content="Kill Background Apps"     Style="{StaticResource Btn}"/>
                                <Button x:Name="btnFlushRAM"       Content="Flush RAM Now"            Style="{StaticResource Btn}"/>
                                <Button x:Name="btnFlushDNSGame"   Content="Flush DNS"                Style="{StaticResource Btn}"/>
                            </StackPanel>
                        </Border>
                        <Border Grid.Column="1" Style="{StaticResource Card}" Margin="2,2,4,4">
                            <StackPanel>
                                <TextBlock Text="REAL-TIME MONITOR" Style="{StaticResource SLabel}"/>
                                <TextBlock x:Name="txtMonRAM"     Text="RAM Used   : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.Accent)"       Margin="0,2"/>
                                <TextBlock x:Name="txtMonCPU"     Text="CPU Load   : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.Accent)"       Margin="0,2"/>
                                <TextBlock x:Name="txtMonCPUTemp" Text="CPU Temp   : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.Warning)"      Margin="0,2"/>
                                <TextBlock x:Name="txtMonGPUTemp" Text="GPU Temp   : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.Warning)"      Margin="0,2"/>
                                <TextBlock x:Name="txtMonRefresh" Text="Refresh Hz : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.Info)"         Margin="0,2"/>
                                <TextBlock x:Name="txtMonDNS"     Text="DNS Flush  : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.TextSecondary)" Margin="0,2"/>
                                <TextBlock x:Name="txtMonPower"   Text="Power Plan : --" FontFamily="Consolas" FontSize="11" Foreground="$($t.TextSecondary)" Margin="0,2"/>
                                <TextBlock x:Name="txtMonCycle"   Text="Cycle      : 0"  FontFamily="Consolas" FontSize="11" Foreground="$($t.TextSecondary)" Margin="0,2"/>
                            </StackPanel>
                        </Border>
                    </Grid>
                </Grid>
            </TabItem>

            <!-- TAB: BLOATWARE -->
            <TabItem Header="Bloatware" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <StackPanel Orientation="Horizontal">
                            <Button x:Name="btnLoadApps"       Content="Load Installed Apps"     Style="{StaticResource BtnAccent}" Width="170" Margin="0,0,6,0"/>
                            <Button x:Name="btnRemoveSelected" Content="Remove Selected"          Style="{StaticResource BtnDanger}" Width="140" Margin="0,0,6,0"/>
                            <Button x:Name="btnSelectAllApps"  Content="Select All"               Style="{StaticResource Btn}"       Width="90"  Margin="0,0,6,0"/>
                            <Button x:Name="btnDeselectAll"    Content="Deselect All"             Style="{StaticResource Btn}"       Width="90"  Margin="0,0,6,0"/>
                            <TextBlock x:Name="txtAppCount" Text="-- apps found" VerticalAlignment="Center" Foreground="$($t.TextSecondary)" FontSize="11" Margin="10,0"/>
                        </StackPanel>
                    </Border>
                    <Border Grid.Row="1" Style="{StaticResource Card}" Margin="4,2,4,4">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel x:Name="pnlAppList"/>
                        </ScrollViewer>
                    </Border>
                </Grid>
            </TabItem>

            <!-- TAB: PROCESSES -->
            <TabItem Header="Processes" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <StackPanel Orientation="Horizontal">
                            <Button x:Name="btnKillUnneeded" Content="Kill Unnecessary Processes"  Style="{StaticResource BtnAccent}" Width="210" Margin="0,0,6,0"/>
                            <Button x:Name="btnScanHighCPU"  Content="Scan High CPU"               Style="{StaticResource BtnWarn}"   Width="120" Margin="0,0,6,0"/>
                            <Button x:Name="btnScanHighRAM"  Content="Scan High RAM"               Style="{StaticResource BtnWarn}"   Width="120" Margin="0,0,6,0"/>
                            <Button x:Name="btnFullProcOpt"  Content="Full Process Optimization"   Style="{StaticResource Btn}"       Width="190"/>
                        </StackPanel>
                    </Border>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="200"/>
                        </Grid.ColumnDefinitions>
                        <Border Grid.Column="0" Style="{StaticResource Card}" Margin="4,2,2,4">
                            <StackPanel>
                                <TextBlock Text="BLACKLISTED PROCESSES (AUTO-KILLED)" Style="{StaticResource SLabel}"/>
                                <TextBlock FontFamily="Consolas" FontSize="11" Foreground="$($t.TextSecondary)" TextWrapping="Wrap" LineHeight="18"
                                    Text="CompatTelRunner, WerFault, WerMgr, Cortana, SearchIndexer, SearchProtocolHost, OneDrive, Teams, Discord, Zoom, Skype, GameBarPresenceWriter, XboxGamingOverlay, GoogleUpdate, MicrosoftEdgeUpdate, SpeechRuntime, DiagTrack, dmwappushservice, EpicWebHelper, AdobeUpdateService, NahimicService, RuntimeBroker, backgroundTaskHost, wsqmcons, OfficeClickToRun, YourPhone, DropboxUpdate ...and more"/>
                            </StackPanel>
                        </Border>
                        <Border Grid.Column="1" Style="{StaticResource Card}" Margin="2,2,4,4">
                            <StackPanel>
                                <TextBlock Text="QUICK ACTIONS" Style="{StaticResource SLabel}"/>
                                <Button x:Name="btnFlushRAMProc" Content="Flush RAM"         Style="{StaticResource Btn}"/>
                                <Button x:Name="btnClearRecycle" Content="Clear Recycle Bin" Style="{StaticResource Btn}"/>
                                <Button x:Name="btnOpenTaskMgr"  Content="Open Task Manager" Style="{StaticResource Btn}"/>
                            </StackPanel>
                        </Border>
                    </Grid>
                </Grid>
            </TabItem>

            <!-- TAB: NETWORK -->
            <TabItem Header="Network" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <Border Grid.Column="0" Style="{StaticResource Card}">
                        <StackPanel>
                            <TextBlock Text="NETWORK TOOLS" Style="{StaticResource SLabel}"/>
                            <Button x:Name="btnNetOpt"        Content="Network Optimization"     Style="{StaticResource BtnAccent}"/>
                            <Button x:Name="btnNetRepair"     Content="Full Network Repair"      Style="{StaticResource Btn}"/>
                            <Button x:Name="btnFlushDNS"      Content="Flush DNS"                Style="{StaticResource Btn}"/>
                            <Button x:Name="btnResetWinsock"  Content="Reset Winsock"            Style="{StaticResource Btn}"/>
                            <Button x:Name="btnRenewIP"       Content="Renew IP Address"         Style="{StaticResource Btn}"/>
                            <TextBlock Text="DNS SERVER" Style="{StaticResource SLabel}"/>
                            <Button x:Name="btnDNSCloud"  Content="Cloudflare   1.1.1.1"        Style="{StaticResource Btn}"/>
                            <Button x:Name="btnDNSGoogle" Content="Google       8.8.8.8"         Style="{StaticResource Btn}"/>
                            <Button x:Name="btnDNSOpen"   Content="OpenDNS      208.67.222.222"  Style="{StaticResource Btn}"/>
                            <Button x:Name="btnDNSQuad"   Content="Quad9        9.9.9.9"         Style="{StaticResource Btn}"/>
                            <Button x:Name="btnDNSAuto"   Content="Reset to Auto DHCP"           Style="{StaticResource BtnDanger}"/>
                        </StackPanel>
                    </Border>
                    <Border Grid.Column="1" Style="{StaticResource Card}">
                        <StackPanel>
                            <TextBlock Text="WINDOWS UPDATE" Style="{StaticResource SLabel}"/>
                            <Button x:Name="btnUpdateDisable" Content="Disable Windows Update" Style="{StaticResource BtnDanger}"/>
                            <Button x:Name="btnUpdateEnable"  Content="Enable Windows Update"  Style="{StaticResource BtnAccent}"/>
                            <Button x:Name="btnUpdateReset"   Content="Reset Windows Update"   Style="{StaticResource Btn}"/>
                            <TextBlock Text="SECURITY" Style="{StaticResource SLabel}"/>
                            <Button x:Name="btnSecScan"      Content="Security Scan"           Style="{StaticResource Btn}"/>
                            <Button x:Name="btnEnableDefend" Content="Enable Defender"         Style="{StaticResource BtnAccent}"/>
                            <Button x:Name="btnEnableFW"     Content="Enable Firewall"         Style="{StaticResource BtnAccent}"/>
                            <Button x:Name="btnDefendScan"   Content="Run Defender Quick Scan" Style="{StaticResource Btn}"/>
                        </StackPanel>
                    </Border>
                </Grid>
            </TabItem>

            <!-- TAB: STARTUP MANAGER -->
            <TabItem Header="Startup" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <StackPanel Orientation="Horizontal">
                            <Button x:Name="btnLoadStartup"        Content="Load Startup Programs"    Style="{StaticResource BtnAccent}" Width="180" Margin="0,0,6,0"/>
                            <Button x:Name="btnDisableSelStartup"  Content="Disable Selected"          Style="{StaticResource BtnDanger}" Width="140" Margin="0,0,6,0"/>
                            <Button x:Name="btnDisableAllStartup"  Content="Disable All Listed"        Style="{StaticResource Btn}"       Width="140"/>
                        </StackPanel>
                    </Border>
                    <Border Grid.Row="1" Style="{StaticResource Card}" Margin="4,2,4,4">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel x:Name="pnlStartupList"/>
                        </ScrollViewer>
                    </Border>
                </Grid>
            </TabItem>

            <!-- TAB: INSTALLED SOFTWARE -->
            <TabItem Header="Software" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <StackPanel Orientation="Horizontal">
                            <Button x:Name="btnLoadSoftware"    Content="Load Installed Software"  Style="{StaticResource BtnAccent}" Width="190" Margin="0,0,6,0"/>
                            <Button x:Name="btnUninstallSel"    Content="Uninstall Selected"        Style="{StaticResource BtnDanger}" Width="140" Margin="0,0,6,0"/>
                            <TextBlock x:Name="txtSoftCount" Text="-- programs found" VerticalAlignment="Center" Foreground="$($t.TextSecondary)" FontSize="11" Margin="10,0"/>
                        </StackPanel>
                    </Border>
                    <Border Grid.Row="1" Style="{StaticResource Card}" Margin="4,2,4,4">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <StackPanel x:Name="pnlSoftwareList"/>
                        </ScrollViewer>
                    </Border>
                </Grid>
            </TabItem>

            <!-- TAB: SYSTEM INFO -->
            <TabItem Header="System Info" Style="{StaticResource TabStyle}">
                <Grid Background="$($t.BG)" Margin="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Style="{StaticResource Card}" Margin="4,4,4,2">
                        <StackPanel Orientation="Horizontal">
                            <Button x:Name="btnRefreshInfo" Content="Refresh Info"       Style="{StaticResource BtnAccent}" Width="130" Margin="0,0,6,0"/>
                            <Button x:Name="btnPerfRep2"    Content="Performance Report" Style="{StaticResource Btn}"       Width="150" Margin="0,0,6,0"/>
                            <Button x:Name="btnBatRep"      Content="Battery Status"     Style="{StaticResource Btn}"       Width="120"/>
                        </StackPanel>
                    </Border>
                    <Border Grid.Row="1" Style="{StaticResource Card}" Margin="4,2,4,4">
                        <ScrollViewer VerticalScrollBarVisibility="Auto">
                            <TextBlock x:Name="txtSysInfo" FontFamily="Consolas" FontSize="12" Foreground="$($t.TextPrimary)" TextWrapping="Wrap" LineHeight="22"/>
                        </ScrollViewer>
                    </Border>
                </Grid>
            </TabItem>

        </TabControl>

        <!-- LOG -->
        <Border Grid.Row="2" Background="$($t.LogBG)" BorderBrush="$($t.Border)" BorderThickness="0,1,0,0" Margin="6,0,6,6">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="22"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Border Grid.Row="0" Background="$($t.BGSecondary)" BorderBrush="$($t.Border)" BorderThickness="0,0,0,1">
                    <TextBlock Text="  Output Log" FontSize="11" FontWeight="SemiBold" Foreground="$($t.TextSecondary)" VerticalAlignment="Center"/>
                </Border>
                <ScrollViewer Grid.Row="1" x:Name="logScroll" VerticalScrollBarVisibility="Auto">
                    <TextBlock x:Name="txtLog" FontFamily="Consolas" FontSize="11" Foreground="$($t.LogText)" Margin="8,4" TextWrapping="Wrap"/>
                </ScrollViewer>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

    try {
        $xml    = [xml]$xaml
        $reader = [System.Xml.XmlNodeReader]::new($xml)
        $Window = [Windows.Markup.XamlReader]::Load($reader)
    } catch {
        Write-Host "XAML ERROR: $_" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        return
    }

    $global:LogControl = $Window.FindName("txtLog")
    $global:LogScroll  = $Window.FindName("logScroll")

    # ── Stored data for picker tabs ──
    $script:AppItems     = @()
    $script:SoftItems    = @()
    $script:StartupItems = @()

    # ── Monitor timer ──
    $monTimer = New-Object System.Windows.Threading.DispatcherTimer
    $monTimer.Interval = [TimeSpan]::FromSeconds(3)
    $monTimer.Add_Tick({
        try {
            $snap = Get-SystemSnapshot
            $os   = Get-WmiObject Win32_OperatingSystem
            $uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
            $disk   = Get-PSDrive C -ErrorAction SilentlyContinue
            $freeGB = [math]::Round($disk.Free/1GB,1)
            $Window.FindName("txtHeaderCPU").Text     = "CPU: $($snap.CPULoad)%"
            $Window.FindName("txtHeaderRAM").Text     = "RAM: $($snap.UsedRAM) / $($snap.TotalRAM) MB"
            $Window.FindName("txtHeaderCPUTemp").Text = "CPU Temp: $($snap.CPUTemp)"
            $Window.FindName("txtHeaderGPUTemp").Text = "GPU Temp: $($snap.GPUTemp)"
            $Window.FindName("txtHeaderUptime").Text  = "Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
            $Window.FindName("txtHeaderDisk").Text    = "Disk C: $freeGB GB free"
            if ($global:GamingActive) {
                $Window.FindName("txtMonRAM").Text     = "RAM Used   : $($snap.UsedRAM) MB / $($snap.TotalRAM) MB"
                $Window.FindName("txtMonCPU").Text     = "CPU Load   : $($snap.CPULoad)%"
                $Window.FindName("txtMonCPUTemp").Text = "CPU Temp   : $($snap.CPUTemp)"
                $Window.FindName("txtMonGPUTemp").Text = "GPU Temp   : $($snap.GPUTemp)"
                $Window.FindName("txtMonRefresh").Text = "Refresh Hz : $($snap.Refresh) Hz"
                $Window.FindName("txtMonCycle").Text   = "Cycle      : $($global:GamingCycle)"
            }
        } catch {}
    })
    $monTimer.Start()

    # ── Gaming timer ──
    $gamingTimer = New-Object System.Windows.Threading.DispatcherTimer
    $gamingTimer.Interval = [TimeSpan]::FromSeconds(10)
    $gamingTimer.Add_Tick({
        if ($global:GamingActive) {
            Invoke-GamingCycle
            $Window.FindName("txtGamingCycle").Text = "Cycles: $($global:GamingCycle)"
            $Window.FindName("txtMonDNS").Text  = "DNS Flush  : OK (Cycle $($global:GamingCycle))"
            $Window.FindName("txtMonPower").Text = "Power Plan : Ultimate Performance"
        }
    })

    # ── Helper to add checkbox to panel ──
    function Add-CheckItem {
        param($Panel, $Label, $Tag, $SubLabel="")
        $chk = New-Object System.Windows.Controls.CheckBox
        $chk.Content = if ($SubLabel) { "$Label  [$SubLabel]" } else { $Label }
        $chk.Tag     = $Tag
        $chk.Foreground = [Windows.Media.BrushConverter]::new().ConvertFromString($t.TextPrimary)
        $chk.FontSize = 11
        $chk.Margin = [Windows.Thickness]::new(2,2,2,2)
        $Panel.Children.Add($chk) | Out-Null
        return $chk
    }

    # ── BUTTON WIRING ──

    $Window.FindName("btnToggleTheme").Add_Click({
        Toggle-Theme
        [System.Windows.MessageBox]::Show("Theme changed. Restart SiencyWinOS to apply.", "SiencyWinOS", "OK", "Information")
    })
    $Window.FindName("btnClearLog").Add_Click({ Clear-SLog })

    # Optimize
    $Window.FindName("btnFullOpt").Add_Click({      Invoke-FullOptimization })
    $Window.FindName("btnTempClean").Add_Click({    Invoke-TempClean })
    $Window.FindName("btnRestorePoint").Add_Click({ Invoke-RestorePoint })
    $Window.FindName("btnStartup").Add_Click({      Invoke-StartupCleaner })
    $Window.FindName("btnSFCScan").Add_Click({      Invoke-SFCScan })
    $Window.FindName("btnDISM").Add_Click({         Invoke-DISMRepair })
    $Window.FindName("btnDiskClean").Add_Click({    Invoke-DiskClean })
    $Window.FindName("btnIconCache").Add_Click({    Invoke-IconCacheRepair })
    $Window.FindName("btnFontRepair").Add_Click({   Invoke-FontRepair })
    $Window.FindName("btnWURepair").Add_Click({     Invoke-WindowsUpdateRepair })
    $Window.FindName("btnRAM").Add_Click({          Invoke-RAMOptimization })
    $Window.FindName("btnProcessor").Add_Click({    Invoke-ProcessorOptimization })
    $Window.FindName("btnGPU").Add_Click({          Invoke-GPUOptimization })
    $Window.FindName("btnDisplay").Add_Click({      Invoke-DisplayOptimization })
    $Window.FindName("btnAudio").Add_Click({        Invoke-AudioOptimization })
    $Window.FindName("btnDisk").Add_Click({         Get-DiskHealth })
    $Window.FindName("btnDXRepair").Add_Click({     Invoke-DirectXRepair })
    $Window.FindName("btnPowerPlan").Add_Click({    Invoke-PowerPlan })
    $Window.FindName("btnBattery").Add_Click({      Get-BatteryStatus })
    $Window.FindName("btnPrivacy").Add_Click({      Invoke-PrivacyClean })
    $Window.FindName("btnTweaks").Add_Click({       Invoke-FullTweaks })
    $Window.FindName("btnRegistry").Add_Click({     Invoke-RegistryCleaner })
    $Window.FindName("btnKernelTimer").Add_Click({  Invoke-KernelTimerResolution })
    $Window.FindName("btnMMCSS").Add_Click({        Invoke-MMCSSTuning })
    $Window.FindName("btnDPC").Add_Click({          Invoke-DPCMonitor })
    $Window.FindName("btnSSDTrim").Add_Click({      Invoke-SSDTrim })
    $Window.FindName("btnServices").Add_Click({     Invoke-ServiceOptimization })
    $Window.FindName("btnPerfReport").Add_Click({   Get-PerformanceReport })

    # Gaming
    $Window.FindName("btnGamingStart").Add_Click({
        Start-GamingMode
        $gamingTimer.Start()
        $Window.FindName("txtGamingStatus").Text = "Status: ACTIVE"
        $Window.FindName("txtGamingStatus").Foreground = [Windows.Media.Brushes]::LimeGreen
        $Window.FindName("btnGamingStart").IsEnabled = $false
        $Window.FindName("btnGamingStop").IsEnabled  = $true
    })
    $Window.FindName("btnGamingStop").Add_Click({
        Stop-GamingMode
        $gamingTimer.Stop()
        $Window.FindName("txtGamingStatus").Text = "Status: Inactive"
        $Window.FindName("txtGamingStatus").Foreground = [Windows.Media.Brushes]::Red
        $Window.FindName("btnGamingStart").IsEnabled = $true
        $Window.FindName("btnGamingStop").IsEnabled  = $false
    })
    $Window.FindName("btnRobloxBoost").Add_Click({    Invoke-RobloxBoost })
    $Window.FindName("btnMinecraftBoost").Add_Click({ Invoke-MinecraftBoost })
    $Window.FindName("btnValBoost").Add_Click({       Invoke-ValBoost })
    $Window.FindName("btnKillBG").Add_Click({         Invoke-KillBackground })
    $Window.FindName("btnFlushRAM").Add_Click({       Invoke-FlushRAM })
    $Window.FindName("btnFlushDNSGame").Add_Click({   Invoke-Task "Flush DNS" { ipconfig /flushdns | Out-Null } })

    # Bloatware Picker
    $Window.FindName("btnLoadApps").Add_Click({
        Write-SLog ">> Loading installed AppX packages..."
        $pnl = $Window.FindName("pnlAppList")
        $pnl.Children.Clear()
        $script:AppItems = Invoke-BloatwareRemover
        foreach ($app in $script:AppItems) {
            Add-CheckItem -Panel $pnl -Label $app.Name -Tag $app.PackageFullName -SubLabel "" | Out-Null
        }
        $Window.FindName("txtAppCount").Text = "$($script:AppItems.Count) apps found"
        Write-SLog "   Loaded $($script:AppItems.Count) installed apps"
    })
    $Window.FindName("btnSelectAllApps").Add_Click({
        $pnl = $Window.FindName("pnlAppList")
        foreach ($child in $pnl.Children) { $child.IsChecked = $true }
    })
    $Window.FindName("btnDeselectAll").Add_Click({
        $pnl = $Window.FindName("pnlAppList")
        foreach ($child in $pnl.Children) { $child.IsChecked = $false }
    })
    $Window.FindName("btnRemoveSelected").Add_Click({
        $pnl = $Window.FindName("pnlAppList")
        $toRemove = $pnl.Children | Where-Object { $_.IsChecked -eq $true }
        if (-not $toRemove) { Write-SLog "No apps selected."; return }
        foreach ($chk in @($toRemove)) {
            Remove-AppByName -PackageFullName $chk.Tag -Name $chk.Content
            $pnl.Children.Remove($chk)
        }
        $Window.FindName("txtAppCount").Text = "$($pnl.Children.Count) apps remaining"
    })

    # Process Manager
    $Window.FindName("btnKillUnneeded").Add_Click({  Stop-UnnecessaryProcesses })
    $Window.FindName("btnScanHighCPU").Add_Click({   Stop-HighCPUProcesses })
    $Window.FindName("btnScanHighRAM").Add_Click({   Stop-HighRAMProcesses })
    $Window.FindName("btnFullProcOpt").Add_Click({   Invoke-ProcessOptimization })
    $Window.FindName("btnFlushRAMProc").Add_Click({  Invoke-FlushRAM })
    $Window.FindName("btnClearRecycle").Add_Click({  Invoke-Task "Clear Recycle Bin" { Clear-RecycleBin -Force -ErrorAction SilentlyContinue } })
    $Window.FindName("btnOpenTaskMgr").Add_Click({   Start-Process taskmgr })

    # Network
    $Window.FindName("btnNetOpt").Add_Click({       Invoke-NetworkOptimization })
    $Window.FindName("btnNetRepair").Add_Click({    Invoke-NetworkRepair })
    $Window.FindName("btnFlushDNS").Add_Click({     Invoke-Task "Flush DNS"    { ipconfig /flushdns | Out-Null } })
    $Window.FindName("btnResetWinsock").Add_Click({ Invoke-Task "Reset Winsock" { netsh winsock reset 2>$null | Out-Null } })
    $Window.FindName("btnRenewIP").Add_Click({      Invoke-Task "Renew IP"     { ipconfig /release 2>$null | Out-Null; ipconfig /renew 2>$null | Out-Null } })
    $Window.FindName("btnDNSCloud").Add_Click({     Set-DNSServer "1.1.1.1"        "1.0.0.1" })
    $Window.FindName("btnDNSGoogle").Add_Click({    Set-DNSServer "8.8.8.8"        "8.8.4.4" })
    $Window.FindName("btnDNSOpen").Add_Click({      Set-DNSServer "208.67.222.222" "208.67.220.220" })
    $Window.FindName("btnDNSQuad").Add_Click({      Set-DNSServer "9.9.9.9"        "149.112.112.112" })
    $Window.FindName("btnDNSAuto").Add_Click({      Reset-DNSAuto })
    $Window.FindName("btnUpdateDisable").Add_Click({ Disable-WindowsUpdate })
    $Window.FindName("btnUpdateEnable").Add_Click({  Enable-WindowsUpdate })
    $Window.FindName("btnUpdateReset").Add_Click({   Reset-WindowsUpdate })
    $Window.FindName("btnSecScan").Add_Click({      Invoke-SecurityScan })
    $Window.FindName("btnEnableDefend").Add_Click({ Invoke-EnableDefender })
    $Window.FindName("btnEnableFW").Add_Click({     Invoke-EnableFirewall })
    $Window.FindName("btnDefendScan").Add_Click({   Invoke-DefenderScan })

    # Startup Manager
    $Window.FindName("btnLoadStartup").Add_Click({
        Write-SLog ">> Loading startup programs..."
        $pnl = $Window.FindName("pnlStartupList")
        $pnl.Children.Clear()
        $script:StartupItems = Get-StartupPrograms
        foreach ($item in $script:StartupItems) {
            Add-CheckItem -Panel $pnl -Label $item.Name -Tag "$($item.RegPath)|$($item.Name)" -SubLabel $item.Scope | Out-Null
        }
        Write-SLog "   Loaded $($script:StartupItems.Count) startup entries"
    })
    $Window.FindName("btnDisableSelStartup").Add_Click({
        $pnl = $Window.FindName("pnlStartupList")
        $sel = $pnl.Children | Where-Object { $_.IsChecked -eq $true }
        foreach ($chk in @($sel)) {
            $parts = $chk.Tag -split "\|"
            Disable-StartupItem -RegPath $parts[0] -Name $parts[1]
            $pnl.Children.Remove($chk)
        }
    })
    $Window.FindName("btnDisableAllStartup").Add_Click({
        $pnl = $Window.FindName("pnlStartupList")
        foreach ($chk in @($pnl.Children)) {
            $parts = $chk.Tag -split "\|"
            Disable-StartupItem -RegPath $parts[0] -Name $parts[1]
        }
        $pnl.Children.Clear()
        Write-SLog "All listed startup items disabled"
    })

    # Software Manager
    $Window.FindName("btnLoadSoftware").Add_Click({
        Write-SLog ">> Loading installed software..."
        $pnl = $Window.FindName("pnlSoftwareList")
        $pnl.Children.Clear()
        $script:SoftItems = Get-InstalledSoftware
        foreach ($soft in $script:SoftItems) {
            Add-CheckItem -Panel $pnl -Label $soft.Name -Tag $soft.UninstallString -SubLabel "$($soft.Version) | $($soft.Size)" | Out-Null
        }
        $Window.FindName("txtSoftCount").Text = "$($script:SoftItems.Count) programs found"
        Write-SLog "   Loaded $($script:SoftItems.Count) installed programs"
    })
    $Window.FindName("btnUninstallSel").Add_Click({
        $pnl = $Window.FindName("pnlSoftwareList")
        $sel = $pnl.Children | Where-Object { $_.IsChecked -eq $true }
        if (-not $sel) { Write-SLog "No software selected."; return }
        $res = [System.Windows.MessageBox]::Show("Uninstall $(@($sel).Count) selected program(s)?", "Confirm", "YesNo", "Warning")
        if ($res -ne "Yes") { return }
        foreach ($chk in @($sel)) {
            $name = ($chk.Content -split "\[")[0].Trim()
            Invoke-UninstallSoftware -UninstallString $chk.Tag -Name $name
            $pnl.Children.Remove($chk)
        }
        $Window.FindName("txtSoftCount").Text = "$($pnl.Children.Count) programs remaining"
    })

    # System Info
    $Window.FindName("btnRefreshInfo").Add_Click({
        $Window.FindName("txtSysInfo").Text = Get-FullSystemInfo
        Write-SLog "System info refreshed"
    })
    $Window.FindName("btnPerfRep2").Add_Click({  Get-PerformanceReport })
    $Window.FindName("btnBatRep").Add_Click({    Get-BatteryStatus })

    # On load
    $Window.Add_Loaded({
        Write-SLog "SiencyWinOS v2.0 ready - Running as Administrator"
        Write-SLog "Modules: Optimization, Gaming, Privacy, Network, System, Advanced, ProcessManager, Security, Repair, Monitor"
        $Window.FindName("txtSysInfo").Text = Get-FullSystemInfo
    })

    $Window.ShowDialog() | Out-Null
    $monTimer.Stop()
    $gamingTimer.Stop()
}
