& "C:\Program Files\PowerShell\7\pwsh.exe" -c "Install-Module Az -force -allowClobber -scope AllUsers"
& "C:\Program Files\PowerShell\7\pwsh.exe" -c "Ipmo Az; Uninstall-AzureRm -Confirm:0"
Restart-Computer -Force