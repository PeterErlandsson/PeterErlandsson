if ($env:MSI_SECRET -and (Get-Module -ListAvailable Az.Accounts)) {
    Connect-AzAccount -Identity
Select-AzSubscription -Subscription 9d957d40-b4aa-47b6-83ec-2f5bc899a938
}
    
$env:JiraBackupCount = '7'
$env:ConfluenceBackupCount = '7'

# Atlassian subdomain i.e. whateverproceeds.atlassian.net
$env:account = 'bluestep'
# username with domain something@domain.com
$env:username = 'sebastian.claesson@bluestep.se'
$env:StorageAccount = 'stbackuptxmvelnigqfdu'
$env:ResourceGroupName = 'bstp-atlassianbackup-prod-we'
$env:AzureFileShare = 'backup'
# Token created from product https://confluence.atlassian.com/cloud/api-tokens-938839638.html
# NOTE: The token retrieved from the user is bound to the user, if users is disabled then the token is disabled!
# NOTE: The user needs to be an administrator in the product to be able to perform backups; https://getsupport.atlassian.com/servicedesk/customer/portal/42/PSCLOUD-44535
    
