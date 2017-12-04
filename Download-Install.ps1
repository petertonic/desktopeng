<#
.SYNOPSIS
    Download and installs the MSI or EXE, given the URL for the installer
.DESCRIPTION
    Download and installs the MSI or EXE, given the URL for the installer. If any installation flags are
    provided in the second parameter, those flags will be applied during the install. If a path to the app's
    Program Files directory is provided in the third parameter, the script will check to see if the app is
    already installed and exit if the path already exists. T
.NOTES
    Name: Download-Install.ps1
    Author: Peter Ton
    Date created: 12/01/2017
    Version: 1.0
.PARAMETERS
    -installer_url URL to the MSI or EXE installer package
    -flags (optional) flags to be applied during installation
    -check_path (optional) path (within Program Files) to check before install
.EXAMPLES
    .\Download-Install.ps1 https://s3.amazonaws.com/cargurus-windows-packages/Dropbox+39.4.49+Offline+Installer.exe
    .\Download-Install.ps1 https://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi /qb!
    .\Download-Install.ps1 https://s3.amazonaws.com/cargurus-windows-packages/installer_vista_win7_win8-64-3.0.2.2.msi "/qb! /L* log.txt COMPANY_CODE=XXXXXXXXXXXXX" -check_path Confer\RepMgr64.exe
#>

param (
    [Parameter(Mandatory=$true)][string]$installer_url,
    [string]$flags,
    [string]$check_path
)

# Check if app is already installed
if ($check_path) {
    if ((Test-Path("C:\Program Files\$check_path")) -or (Test-Path("C:\Program Files (x86)\$check_path"))) {
        echo "App is already installed!"
        break
    }
}

# Check for EXE or MSI
if ($installer_url.EndsWith("msi")) {
    $installer_extension = "msi"
} elseif($installer_url.EndsWith("exe")) {
    $installer_extension = "exe"
} else {
    echo "Could not detect exe or msi"
    break
}

# Path to temporary installer
$temp_installer_path = $env:TEMP + "\cginstaller." + $installer_extension

# Download
echo "Downloading"
$client = New-Object System.Net.WebClient
$client.DownloadFile($installer_url, $temp_installer_path)

# Install
echo "Installing"
if ($flags) {
    Start-Process -Wait -FilePath $temp_installer_path -ArgumentList $flags
} else {
    Start-Process -Wait -FilePath $temp_installer_path
}

# Clean up
echo "Cleaning up"
Remove-Item -Path "$temp_installer_path"