# Input bindings are passed in via param block.
param($Timer)

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

$Context = (Get-AzStorageAccount -Name $env:StorageAccount -ResourceGroupName $env:ResourceGroupName -ErrorAction Stop).Context
$BackupFiles = Get-AzStorageFile -ShareName $env:AzureFileShare -Context $Context
$ConfluenceBackupFiles = $BackupFiles | Where-Object {$_.Name -like 'Confluence*'}
$JiraBackupFiles = $BackupFiles | Where-Object {$_.Name -like 'Jira*'}

if ($ConfluenceBackupFiles.Count -gt $env:ConfluenceBackupCount) {
    $ConfluenceBackupFiles | 
    Sort-Object Name | 
    Select-Object -First $($ConfluenceBackupFiles.Count - 7) |
    ForEach-Object {
        Write-Host "$($_.Name) was successfully deleted."
        $_.Delete()
    }
}

if ($JiraBackupFiles.Count -gt $env:JiraBackupCount) {
    $JiraBackupFiles | 
    Sort-Object Name | 
    Select-Object -First $($JiraBackupFiles.Count - 7) |
    ForEach-Object {
        Write-Host "$($_.Name) was successfully deleted."
        $_.Delete()
    }
}