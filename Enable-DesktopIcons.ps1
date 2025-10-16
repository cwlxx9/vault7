# Enable all Desktop Icons (This PC, User Files, Network, Recycle Bin, Control Panel)

# Registry path for desktop icons
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

# List of icon GUIDs (for the right side of the Settings window)
$icons = @{
    "ThisPC"        = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    "UserFiles"     = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    "Network"       = "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
    "RecycleBin"    = "{645FF040-5081-101B-9F08-00AA002F954E}"
    "ControlPanel"  = "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
}

# Set all to visible (0 = show, 1 = hide)
foreach ($icon in $icons.Values) {
    Set-ItemProperty -Path $regPath -Name $icon -Value 0 -Force
}

# Refresh desktop without restarting Explorer
$shell = New-Object -ComObject Shell.Application
$shell.NameSpace(0).Self.InvokeVerb("refresh")

Write-Host "✅ All desktop icons enabled and desktop refreshed (without reopening File Explorer)." -ForegroundColor Green
