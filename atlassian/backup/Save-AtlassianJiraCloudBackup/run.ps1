# Input bindings are passed in via param block.
param($Timer)

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}
# Backup Jira &/or Confluence use either $true or $false.
$JiraBackup = $true
# Location on machine where script is run to dump the backup zip file.
### IMPROVEMENT SUGGESTION: integration to Azure Storage Accounts
$Context = (Get-AzStorageAccount -Name $env:StorageAccount -ResourceGroupName $env:ResourceGroupName -ErrorAction Stop).Context

# $env:token = ConvertFrom-SecureString -SecureString (Get-AzKeyVaultSecret -VaultName 'kv-atlassianbackup-prod' -Name 'AtlassianBackupToken').SecretValue

function Save-AtlassianBackup {
    [CmdletBinding()]
    param (
        # The base uri for the Atlassian account and product.
        [Parameter(mandatory)]
        [string]
        $Account,

        # Headers
        [Parameter(mandatory)]
        $Headers,

        # Product
        [Parameter(mandatory)]
        [string]
        [ValidateSet('Jira', 'Confluence')]
        $Product,

        # AzureFileShare
        [Parameter()]
        [string]
        $AzureFileShare,

        # Storage account context
        [Parameter(mandatory)]        
        $Context
    )
        
    $Uri = "https://$account.atlassian.net"

    # Get the date as a string
    $today = Get-Date -format yyyyMMdd-HHmm

    # Create the webrequest using System.Net.Webrequest.
    switch ($Product) {
        'Jira' {
            $Download = "$Uri/plugins/servlet"
            $Progress = "$Uri/rest/backup/1/export/getProgress?taskId="
        }
        'Confluence' {
            $Download = "$Uri/wiki/download"
            $Progress = "$Uri/wiki/rest/obm/1.0/getprogress"
        }
    }

    # Find the latest (current) backup task id.
    if ($Product -eq 'Jira') {
        $WebParams = @{
            Method      = 'GET'
            Headers     = $headers
            ErrorAction = 'Stop'
            Uri         = "$Uri/rest/backup/1/export/lastTaskId"
        }
        $LatestRequest = Invoke-WebRequest @WebParams
        $LatestBackupID = $LatestRequest.Content
        $Progress = "$Progress{0}" -f $LatestBackupID 
    } 

    $WebParams = @{
        Method      = 'GET'
        Headers     = $headers
        Uri         = $Progress
        ErrorAction = 'Stop'
    }
        # Get the progress of the latest (current) task id.
        $BackupRequest = Invoke-RestMethod @WebParams 
        if ($Product -eq 'Jira') {
            Write-Host "Backup status is at the step '$($BackupRequest.Message)'." 
            $DownloadUrl = "$Download/{0}" -f $BackupRequest.result
            Write-Host "Download URL: $DownloadUrl - Result: $($BackupRequest.result)"
        }
        elseif ($Product -eq 'Confluence') {
            Write-Host "Backup status is at the step '$($BackupRequest.currentStatus)'."
            $DownloadUrl = "$Download/{0}" -f $BackupRequest.fileName
        }

    #Download the backup as a zip.
    $TempPath = (Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath "$Product-backup-$today.zip")
    $WebParams = @{
        Method      = 'GET'
        Headers     = $headers
        Uri         = $DownloadUrl
        OutFile     = $TempPath
        ErrorAction = 'Stop'
    }

    try {
        Invoke-WebRequest @WebParams
    }
    catch {
        throw
    }
    Get-Childitem -Path $TempPath -Recurse | Foreach-Object { Set-AzStorageFileContent -ShareName $AzureFileShare -Source $_.FullName -Context $Context -Force }
    Write-Host "SUCCESS: Backup is saved at '$AzureFileShare' with the name '$Product-backup-$today.zip'"
}

#Set the SecurityProtocol to tls 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# Create Header
$headers = @{
    "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($env:username):$env:AtlassianToken")))"
    "Content-Type"  = "application/json"
}

[PSCustomObject]@{
    Product = 'Jira'
    Backup  = $JiraBackup
} | Where-Object { $_.Backup } | ForEach-Object {
    $Params = @{
        Account        = $env:account
        Headers        = $Headers
        Product        = $_.Product
        AzureFileShare = $env:AzureFileShare
        Context        = $Context
    }
    Save-AtlassianBackup @params
}