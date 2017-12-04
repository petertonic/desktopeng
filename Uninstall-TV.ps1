# Determine if this is a 32-bit or a 64-bit machine.
if (${env:ProgramFiles(x86)}) {
    # 64-bit
    $program_files = ${env:ProgramFiles(x86)}
}
else {
    # 32-bit
    $program_files = $env:ProgramFiles
}

echo "Removing existing TeamViewer install"
Start-Process -Wait -FilePath "$program_files\TeamViewer\uninstall.exe" -ArgumentList "/S"

# Wait 10 seconds, then delete Teamviewer folder
Start-Sleep -s 10
Remove-Item "$program_files\TeamViewer\" -Force -Recurse