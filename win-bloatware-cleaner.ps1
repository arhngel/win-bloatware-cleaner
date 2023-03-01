# Run PowerShell as administrator before executing this script
# Remove Windows Bloatware, Disable Cortana, and Clean Registry Entries Script with System Restore Point

# Create a system restore point
Checkpoint-Computer -Description "System Restore Point before Removing Windows Bloatware, Disabling Cortana, and Cleaning Registry Entries"

# List of Windows Bloatware to be removed
$Bloatware = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MinecraftUWP",
    "Microsoft.MixedReality.Portal",
    "Microsoft.Office.OneNote",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.ScreenSketch",
    "Microsoft.SkypeApp",
    "Microsoft.SolitaireCollection",
    "Microsoft.StorePurchaseApp",
    "Microsoft.Todos",
    "Microsoft.Wallet",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCalculator",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsCommunicationsApps",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

# Remove Windows Bloatware
ForEach ($App in $Bloatware) {
    Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage
}

# Disable Cortana
$Cortana = Get-AppxPackage -Name Microsoft.549981C3F5F10 -AllUsers
If ($Cortana) {
    Remove-AppxPackage -Package $Cortana.PackageFullName -AllUsers
    Get-AppxProvisionedPackage -Online | where DisplayName -EQ "Microsoft.Windows.Cortana" | Remove-AppxProvisionedPackage -Online
}

# Clean Registry Entries
$Bloatware | ForEach-Object {
    $AppKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\"
    $AppKey += (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\" -Name $_).$_
    if (Test-Path -Path $AppKey) {
        Remove-Item -Path $AppKey -Recurse
    }
}

Write-Output "Windows bloatware removed, Cortana disabled, and registry entries cleaned successfully."