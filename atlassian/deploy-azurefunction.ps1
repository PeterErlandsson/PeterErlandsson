[CmdletBinding()]
param (

    # Subscription Id
    [Parameter(Mandatory)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory)]
    [string]
    # Identifier of the atlassian account, <identifier>.atlassian.net
    $AtlassianAccount,

    [Parameter(Mandatory)]
    [string]
    ## This is the user in whos context we are running as, it is needed to give temporary access to the Azure KeyVault.
    $RunningAsUser = 'user@company.domain',

    [Parameter(Mandatory)]
    [string]
    # Identity of the user who will create the needed API token at https://id.atlassian.com/manage-profile/security
    $AtlassianUser = 'user@company.domain',

    # Resource group name
    [Parameter()]
    [string]
    $ResourceGroupName = "rg-atlassianbackup-prod-we",

    [Parameter()]
    [string]
    # How many copies of Confluence should be saved
    $Location = 'West Europe',

    [Parameter()]
    [string]
    # What environment are we deploying to (if you have multiple atlassian environments.)
    $Environment = 'prod',

    # Function application name
    [Parameter()]
    [string]
    $FunctionAppName = "backup",

    [Parameter()]
    [int]
    # How many copies of Jira should be saved
    $JiraBackupCount = 7,

    [Parameter()]
    [int]
    # How many copies of Confluence should be saved
    $ConfluenceBackupCount = 7
)

Connect-AzAccount
# Set the subscription ID to the one where you wish to create your resources.
Select-AzSubscription -Subscription $SubscriptionId 

if ((Get-location).Path.split('\')[-1] -ne 'atlassian') {
    Write-Error "Please make sure you are at the root of the repository, which should be atlassian."
    exit
}

# Uncomment to build the json.
# bicep build .\main.bicep

# Configuration section
## This is the configuration for Atlassian settings
$ProfileSettings = @{
    # Identity of the user who will create the needed API token at https://id.atlassian.com/manage-profile/security
    'AtlassianUser'         = $AtlassianUser
    # Identifier of the atlassian account, <identifier>.atlassian.net
    'AtlassianAccount'      = $AtlassianAccount
    # How many copies of Jira should be saved
    'JiraBackupCount'       = $JiraBackupCount
    # How many copies of Confluence should be saved
    'ConfluenceBackupCount' = $ConfluenceBackupCount
}

## Resource/Resourcegroup configuration
$resourceParams = @{
    environment     = $Environment
    functionAppName = $FunctionAppName
    Location        = $Location
    Owner           = $RunningAsUser
    TemplateFile    = '.\main.json' 
    ErrorAction     = 'stop' 
}

# $ResourceGroupName = "rg-atlassian$($resourceParams['functionAppName'])-$($resourceParams['environment'])-we"
$ArchivePath = ".\Temporary\$($resourceParams['functionAppName']).zip"

if (!(test-path -path $(Split-Path -Parent $ArchivePath))) {
    New-item -Path $(Split-Path -Parent $ArchivePath) -ItemType Directory
}


if (!(Get-AzResourceGroup -Name $ResourceGroupName -Location $resourceParams['Location'])) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $resourceParams['Location'] -Force
}

$Deployment = New-AzResourceGroupDeployment @resourceParams -ResourceGroupName $ResourceGroupName -Name "main-$(Get-date -format yyyyMMdd_hh_mm)"

$RoleParams = @{
    RoleDefinitionName = 'Storage Account Contributor'
    ObjectId           = $Deployment.Outputs['websiteIdentity'].Value
    Scope              = $Deployment.Outputs['scope'].Value
}

if (!(Get-AzRoleAssignment @RoleParams)) {
    New-AzRoleAssignment @RoleParams | Out-null
}

$StorageAccName = $Deployment.Outputs['storageAccName'].Value

$ProfileFile = Get-Content -Path .\backup\profile.ps1
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern 'Select-AzSubscription -Subscription' -SimpleMatch), "`Select-AzSubscription -Subscription $SubscriptionId")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:StorageAccount' -SimpleMatch), "`$env:StorageAccount = '$StorageAccName'")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:username' -SimpleMatch), "`$env:username = '$($ProfileSettings['AtlassianUser'])'")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:account' -SimpleMatch), "`$env:account = '$($ProfileSettings['AtlassianAccount'])'")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:ResourceGroupName' -SimpleMatch), "`$env:ResourceGroupName = '$($ResourceGroupName)'")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:ConfluenceBackupCount' -SimpleMatch), "`$env:ConfluenceBackupCount = '$($ProfileSettings['ConfluenceBackupCount'])'")
$ProfileFile = $ProfileFile.Replace($($ProfileFile | Select-String -Pattern '$env:JiraBackupCount' -SimpleMatch), "`$env:JiraBackupCount = '$($ProfileSettings['JiraBackupCount'])'")
$ProfileFile | Out-File -FilePath .\backup\profile.ps1

$KeyVaultAccess = Set-AzKeyVaultAccessPolicy -VaultName $Deployment.Outputs['kv'].Value -ResourceGroupName $ResourceGroupName -UserPrincipalName $RunningAsUser -PermissionsToSecrets @('set', 'list') -PassThru
Write-verbose "Please log onto https://id.atlassian.com/manage-profile/security/api-tokens and generate an API token, The user needs to have administrators (backup) access rights." -verbose
$Secret = Set-AzKeyvaultSecret -VaultName $Deployment.Outputs['kv'].Value -Name 'AtlassianBackupToken' -SecretValue $(Read-Host -Prompt 'Atlassian Token' -AsSecureString) -ContentType 'Atlassian Token'
$KeyVaultAccess | Remove-AzKeyVaultAccessPolicy

$AppSettings = @{}
$(Get-AzWebApp -Name $Deployment.Outputs['azWebAppName'].Value).SiteConfig.AppSettings | ForEach-Object {
    $AppSettings.Add($_.Name, $_.Value)
}

$AppSettings['AtlassianToken'] = "@Microsoft.KeyVault(SecretUri=$($Secret.Id))"
Set-AzWebApp -Name $Deployment.Outputs['azWebAppName'].Value -AppSettings $($AppSettings) -ResourceGroupName $ResourceGroupName | Out-null

Get-childitem -path ".\$($resourceParams['functionAppName'])" -Force -ErrorAction Stop | Compress-Archive -DestinationPath "$ArchivePath" -Confirm:$false -Force
Publish-AzWebapp -ResourceGroupName $ResourceGroupName -Name $Deployment.Outputs['azWebAppName'].Value -ArchivePath $(Get-Childitem -Path $ArchivePath).FullName -Force | Out-null
