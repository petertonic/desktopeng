param (
    [Parameter(Mandatory=$true)][string]$host_msi_url,
    [Parameter(Mandatory=$true)][string]$configuration_id,
    [Parameter(Mandatory=$true)][string]$assingment_tool_url,
    [Parameter(Mandatory=$true)][string]$api_token
)

# Exit if Teamviewer is already installed
if ((Test-Path("C:\Program Files\TeamViewer\")) -or (Test-Path("C:\Program Files (x86)\TeamViewer\"))) {
    echo "Teamviewer already installed, exiting..."
}
else {
    $tv_msi_path = $env:TEMP + "\TeamViewer_Host-idc$configuration_id.msi"
    $assign_path = $env:TEMP + "\tvassign.exe"

    echo "Downloading TV"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($host_msi_url, $tv_msi_path)
    $client.DownloadFile($assingment_tool_url, $assign_path)

    echo "Installing TV"
    Start-Process -Wait -FilePath $tv_msi_path -ArgumentList "/qn"

    # Remove desktop icon
    Remove-Item -Path "c:\users\Public\Desktop\TeamViewer 12 Host.lnk"

    # Determine if this is a 32-bit or a 64-bit machine.
    if (${env:ProgramFiles(x86)}) {
        # 64-bit
        $program_files = ${env:ProgramFiles(x86)}
    }
    else {
        # 32-bit
        $program_files = $env:ProgramFiles
    }

    # Wait for AssignmentData.json...
    while (!(Test-Path "$program_files\TeamViewer\AssignmentData.json")) {
        Start-Sleep 10
    }

    echo "Assigning TV"
    Start-Process -Wait -FilePath $assign_path -ArgumentList "-apitoken $([char]34)$api_token$([char]34) -datafile $([char]34)$program_files\TeamViewer\AssignmentData.json$([char]34)"
}