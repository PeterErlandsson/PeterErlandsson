# Input bindings are passed in via param block.
param($Timer)

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Backup Jira &/or Confluence use either $true or $false.
$ConfluenceBackup = $true
# Location on machine where script is run to dump the backup zip file.
### IMPROVEMENT SUGGESTION: integration to Azure Storage Accounts
$Context = (Get-AzStorageAccount -Name $env:StorageAccount -ResourceGroupName $env:ResourceGroupName -ErrorAction Stop).Context
# Tells the script whether or not to pull down the attachments as well
$attachments = $true
# Tells the script whether to export the backup for Cloud or Server
$cloud = $true

# $env:token = ConvertFrom-SecureString -SecureString (Get-AzKeyVaultSecret -VaultName 'kv-atlassianbackup-prod' -Name 'AtlassianBackupToken').SecretValue

function Start-AtlassianBackup {
    [CmdletBinding()]
    param (
        # The base uri for the Atlassian account and product.
        [Parameter(mandatory)]
        [string]
        $Account,

        # Headers
        [Parameter(mandatory)]
        $Headers,

        # Attachments included in backup
        [Parameter(mandatory)]
        [switch]
        $Attachments,

        # If we're backing up a cloud product
        [Parameter(mandatory)]
        [switch]
        $Cloud,

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

    Write-host "Will now attempt to start a backup for $Product"

    # Contruct the Json body.
    $BodyJson = @{
        cbAttachments = $Attachments.IsPresent
        exportToCloud = $Cloud.IsPresent
    } | ConvertTo-Json

    # Create the webrequest using System.Net.Webrequest.
    switch ($Product) {
        'Jira' {
            $ProductApi = "$Uri/rest/backup/1/export/runbackup"
        }
        'Confluence' {
            $ProductApi = "$Uri/wiki/rest/obm/1.0/runbackup"
        }
    }
    $Request = [System.Net.WebRequest]::Create($ProductApi)
    $Request.Method = 'POST'
    $Headers.Keys | ForEach-Object {
        $Request.Headers.Add($_, $Headers[$_])
    }
    # Convert the json to a byte array.
    $ByteArray = $([Text.Encoding]::UTF8).GetBytes($BodyJson)
    $Request.ContentLength = $ByteArray.Length
    # Get and write to request stream
    $RequestStream = $Request.GetRequestStream()
    $RequestStream.Write($ByteArray, 0, $ByteArray.Length)

    # Start the backup of Jira.
    Try {
        $Response = $Request.GetResponse()
    }
    Catch [System.Net.WebException] { 
        $Exception = $_.Exception
        $Response = $exception.Response.GetResponseStream()
        $ErrorStream = (new-object System.IO.StreamReader $Response).ReadToEnd()
        Throw $ErrorStream
    }

    Write-Host "SUCCESS: A new $product backup has been successfully requested at Atlassian Cloud."
}

#Set the SecurityProtocol to tls 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# Create Header
$headers = @{
    "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($env:username):$env:AtlassianToken")))"
    "Content-Type"  = "application/json"
}

[PSCustomObject]@{
    Product = 'Confluence'
    Backup  = $ConfluenceBackup
} | Where-Object { $_.Backup } | ForEach-Object {
    $Params = @{
        Account        = $env:account
        Headers        = $Headers
        Product        = $_.Product
        AzureFileShare = $env:AzureFileShare
        Attachments    = $attachments
        Cloud          = $Cloud
        Context        = $Context
    }
    Start-AtlassianBackup @params
}