# Define the shortcut location (on the current user's desktop)
$Desktop = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $Desktop "Logout Server.lnk"

# Define the target and arguments
$TargetPath = "C:\Windows\System32\shutdown.exe"
$Arguments = "-l"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)

# Set shortcut properties
$Shortcut.TargetPath = $TargetPath
$Shortcut.Arguments = $Arguments
$Shortcut.WindowStyle = 1
$Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,27"  # Optional: Log off icon
$Shortcut.Description = "Click to log out of the server"

# Save the shortcut
$Shortcut.Save()

Write-Host "Logout shortcut created on your desktop."
