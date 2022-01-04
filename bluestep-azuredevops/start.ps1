Import-module VSTeam
Login-AzAccount

#Naming convention: DevOps-<ProjectName>-<SubscriptionName>-<Environment>-<AzureRoleName>

$AzAdAppPrefix = 'DevOps-'
$roles = @('Bluestep Contributor')
$RefreshCredentials = $false
$Whatif = $true

# Issue a new token at https://dev.azure.com/bluestepbank/_usersSettings/tokens
# Also remember to checkout roles in PIM so it allows you to do role assignments and create AAD app registrations.
$Token = 'Super secret token'
$Organization = 'bluestepbank'
Set-VSTeamAccount -Account $Organization -PersonalAccessToken $Token

# Old subscriptions (AZ-Env-Subscription)
$Prod = @('Credit Report','Authority Control Information', 'Datawarehouse', 'Infrastructure', 'Party', 'Bluestep Auth', 'Azure', 'Bluestep Libraries', 'Communication', 'Deposit Portal', 'Document Portal', 'Property Master', 'ServiceLayer', 'Loans', 'EArchive', 'Deposits', 'MODELO')
$Test = @('Credit Report','Authority Control Information', 'Datawarehouse', 'Infrastructure', 'Party', 'Bluestep Auth', 'Azure', 'Bluestep Libraries', 'Communication', 'Deposit Portal', 'Document Portal', 'Property Master', 'ServiceLayer', 'Loans', 'EArchive', 'Deposits', 'MODELO')
$DevOps = @('Credit Report','Authority Control Information', 'Datawarehouse', 'Infrastructure', 'Party', 'Bluestep Auth', 'Azure', 'Bluestep Libraries', 'Communication', 'Deposit Portal', 'Document Portal', 'Property Master', 'ServiceLayer', 'Loans', 'EArchive', 'Deposits', 'MODELO')

# New subscriptions
$Shared = @('Credit Report','Authority Control Information', 'Datawarehouse', 'Infrastructure', 'Party', 'Bluestep Auth', 'Azure', 'Bluestep Libraries', 'Communication', 'Deposit Portal', 'Document Portal', 'Property Master', 'ServiceLayer', 'Loans', 'EArchive', 'Deposits', 'MODELO')
$Infra = @('Infrastructure')
$CoreBanking = @('MODELO')
$BICC = @('Datawarehouse')
$Finance = @()
$ITSecurity = @()
$Management = @()
$Web = @('Deposits')

$AvailableEnvironments = @('Production', 'Test', 'Sandbox')

function New-RandomPassword {
    [CmdletBinding()]
    
    $Password = -join ((65..90) + (97..122) | Get-Random -Count (Get-random -Minimum 20 -Maximum 35) | % { [char]$_ })
    $Password = "$Password$(([guid]::NewGuid()).guid -replace '-','')"
    Write-Output "$Password"
}

function New-AzDevOpsServiceEndpoint {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Object]
        $Subscription,

        [Parameter(Mandatory)]
        [string]
        $Applicationid,

        [Parameter(Mandatory)]
        [string]
        $ApplicationSecret,

        [Parameter(Mandatory)]
        [string]
        $EndpointName,

        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )

    $hashtable = @{
        'data'          = @{
            SubscriptionId   = $Subscription.id
            SubscriptionName = $Subscription.Name
            environment      = "AzureCloud"
            scopeLevel       = "Subscription"
            creationMode     = "Manual"
        }
        'Authorization' = @{
            parameters = @{
                tenantid            = $Subscription.TenantId
                serviceprincipalid  = $ApplicationId
                authenticationType  = "spnKey"
                serviceprincipalkey = $ApplicationSecret
            
            }
            scheme     = "ServicePrincipal"
        }
    }
    
    Add-VSTeamServiceEndpoint -endpointName $EndpointName -endpointType 'azurerm' -ProjectName $ProjectName -object $hashtable
}

$AzSubs = @{}
Get-AzSubscription | 
Where-object { $_.SubscriptionPolicies[0].QuotaId -ne "MSDN_2014-09-01" } | 
ForEach-Object {
    $AzSubs.Add($_.Name, $_)
}

$Projects = Get-VSTeamProject | Sort-Object Name

$Projects | ForEach-Object {
    $CurrentProjectName = $_.Name
    Write-Verbose "Now processing the project $($CurrentProjectName).." -Verbose
    $CurrentSEList = Get-VSTeamServiceEndpoint -ProjectName $CurrentProjectName

    $CurrentProjectSubscriptions = New-Object System.Collections.Arraylist

    switch ($CurrentProjectName) {
        # Old
        { $CurrentProjectName -in $Prod } { 
            Write-verbose "The project '$CurrentProjectName' is included in the AZ-PROD-subscription." -Verbose 
            $CurrentProjectSubscriptions.Add('AZ-PROD-SUBSCRIPTION') | Out-null
        }
        { $CurrentProjectName -in $Test } { 
            Write-verbose "The project '$CurrentProjectName' is included in the AZ-TEST-subscription." -Verbose 
            $CurrentProjectSubscriptions.Add('AZ-TEST-SUBSCRIPTION') | Out-null
        }
        { $CurrentProjectName -in $DevOps } { 
            Write-verbose "The project '$CurrentProjectName' is included in the AZ-DEVOPS-subscription." -Verbose 
            $CurrentProjectSubscriptions.Add('AZ-DEVOPS-SUBSCRIPTION') | Out-null
        }
        # New 
        { $CurrentProjectName -in $Shared } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Shared subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("Shared_$_") } | Out-null
        }
        { $CurrentProjectName -in $Infra } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Infrastructure subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("Infrastructure_$_") } | Out-null
        }
        { $CurrentProjectName -in $CoreBanking } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Core banking subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("Core banking_$_") } | Out-null
        }
        { $CurrentProjectName -in $BICC } { 
            Write-verbose "The project '$CurrentProjectName' is included in the BICC subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("BICC_$_") } | Out-null
        }
        { $CurrentProjectName -in $Finance } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Finance subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("Finance_$_") } | Out-null
        }
        { $CurrentProjectName -in $ITSecurity } { 
            Write-verbose "The project '$CurrentProjectName' is included in the IT Security subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("IT Security_$_") } | Out-null
        }
        { $CurrentProjectName -in $Management } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Management subscriptions." -Verbose 
            $AvailableEnvironments | Where-Object { $_ -ne 'Sandbox' } | ForEach-Object { $CurrentProjectSubscriptions.Add("Management_$_") } | Out-null
        }
        { $CurrentProjectName -in $Web } { 
            Write-verbose "The project '$CurrentProjectName' is included in the Web subscriptions." -Verbose 
            $AvailableEnvironments | ForEach-Object { $CurrentProjectSubscriptions.Add("Web_$_") } | Out-null
        }
        default { Write-Warning "Unable to match any subscription for this project '$CurrentProjectName'" }
    }
    $CurrentProjectSubscriptions | ForEach-Object -Begin {
        $AllAzAdApps = Get-AzADApplication
    } {
        $CurrentSubscription = $_
        $roles | ForEach-Object {
            $CurrentRole = $_
            $ServiceEndpointName = "$CurrentSubscription-{0}" -f $_ -replace ' ', ''
            $AzAdApp = "$AzAdAppPrefix{0}-{1}-{2}" -f ($CurrentProjectName -replace '_', '-' -replace ' ', '-'), ($currentSubscription -replace '_', '-' -replace ' ', '-'), ($CurrentRole -replace '_', '' -replace ' ', '')
            $AzureADApp = $AllAzAdApps | Where-Object { $_.DisplayName -eq $AzAdApp }
            $SubscriptionData = $AzSubs[$CurrentSubscription]
            $Password = New-RandomPassword
            $SecureStringPW = ConvertTo-SecureString -String $Password -AsPlainText -Force
            if (!$AzureADApp) {
                $Params = @{
                    DisplayName             = $AzAdApp 
                    AvailableToOtherTenants = $false 
                    Confirm                 = $false 
                    Password                = $SecureStringPW 
                    IdentifierUris          = "http://bluestep.se/$AzAdApp"
                }
                if ($WhatIf) {
                    Write-Verbose "Would have created a new Azure AD Application called '$AzAdApp'" -verbose
                    Write-Verbose "Would assigned rights as $CurrentRole on the subscription: $($SubscriptionData.Name)" -verbose
                }
                else {
                    try {
                        Write-Verbose "The Azure AD Application registrations called '$AzAdApp' does not exists, will create it.." -Verbose
                        $NewAzAdApp = New-AzADApplication @Params -ErrorAction Stop
                    }
                    catch {
                        throw
                    }
                    try {
                        Write-verbose "Creating the service principal for the Application registration.." -verbose
                        New-AzAdServicePrincipal -ApplicationId $NewAzAdApp.ApplicationId -SkipAssignment
                    }
                    catch {
                        throw
                    }

                    try {
                        Write-verbose "Assigning rights for $($NewAzAdApp.DisplayName) as $CurrentRole for the subscription $($SubscriptionData.id)" -verbose
                        Start-sleep -Seconds 60
                        $Params = @{
                            ApplicationId      = $NewAzAdApp.Applicationid.guid
                            RoleDefinitionName = $CurrentRole
                            Description        = "Allows $($NewAzAdApp.Applicationid) the role of $CurrentRole over subscription $($SubscriptionData.Id)"
                            Scope              = "/subscriptions/$($SubscriptionData.id)"
                        }
                        New-AzRoleAssignment @Params -ErrorAction Stop
                    }
                    catch {
                        throw
                    }
                    try {
                        Write-verbose "Creating the Azure DevOps Service Endpoint in the project $CurrentProjectName.." -verbose
                        $Params = @{
                            Subscription      = $SubscriptionData
                            ProjectName       = $CurrentProjectName
                            Applicationid     = $NewAzAdApp.ApplicationId
                            ApplicationSecret = $Password
                            EndpointName      = $ServiceEndpointName
                        }
                        New-AzDevOpsServiceEndpoint @Params -ErrorAction Stop
                    }
                    catch {
                        throw
                    }
                }

            }
            else {
                if (! (Get-AzAdServicePrincipal -ApplicationId $AzureADApp.ApplicationId)) {
                    if ($WhatIf) {
                        Write-Verbose "Would have created a service principal for the Azure AD App registration: $($AzureADApp.DisplayName)" -Verbose
                    }
                    else {
                        Write-verbose "The App registration is missing a service principal in Azure ad.. Creating.." -verbose
                        try {
                            New-AzAdServicePrincipal -ApplicationId $AzureADApp.ApplicationId -SkipAssignment
                        }
                        catch {
                            throw
                        }
                        try {
                            Write-verbose "Assigning rights for $($AzureADApp.Name) as $CurrentRole for the subscription $($SubscriptionData.id)" -verbose
                            $Params = @{
                                ApplicationId      = $AzureADApp.Applicationid.guid
                                RoleDefinitionName = $CurrentRole
                                Description        = "Allows $($AzureADApp.Applicationid) the role of $CurrentRole over subscription $($SubscriptionData.Id)"
                                Scope              = "/subscriptions/$($SubscriptionData.id)"
                            }
                            New-AzRoleAssignment @Params -ErrorAction Stop
                        }
                        catch {
                            throw
                        }

                    }
                }
                else {
                    if (! (Get-AzRoleAssignment -ObjectId $(Get-AzADServicePrincipal -ApplicationId $AzureADApp.ApplicationId.Guid).Id -scope "/subscriptions/$($SubscriptionData.id)")) {
                        if ($whatif) {
                            Write-verbose "Would have assigned rights for $($AzureADApp.DisplayName) as $CurrentRole for the subscription $($SubscriptionData.Name)" -verbose
                        }
                        else {
                            $Params = @{
                                ApplicationId      = $AzureADApp.Applicationid.guid
                                RoleDefinitionName = $CurrentRole
                                Description        = "Allows $($AzureADApp.Applicationid) the role of $CurrentRole over subscription $($SubscriptionData.Id)"
                                Scope              = "/subscriptions/$($SubscriptionData.id)"
                            }
                            New-AzRoleAssignment @Params -ErrorAction Stop
                        }
                    }
                }
                if ($ServiceEndpointName -notin $CurrentSEList.Name) {
                    if ($WhatIf) {
                        Write-verbose "Would have created a new Azure DevOps service endpoint for the project $CurrentProjectName called $ServiceEndpointName" -verbose
                    }
                    else {
                        try {
                            $Password = New-RandomPassword
                            $SecureStringPW = ConvertTo-SecureString -String $Password -AsPlainText -Force
                            $AzureADApp | New-AzADAppCredential -Password $SecureStringPW -EndDate $((Get-Date).AddYears(1))
                            $Params = @{
                                Subscription      = $SubscriptionData
                                ProjectName       = $CurrentProjectName
                                Applicationid     = $AzureADApp.ApplicationId
                                ApplicationSecret = $Password
                                EndpointName      = $ServiceEndpointName
                            }
                            Write-verbose "Creating a new Azure DevOps service endpoint for the project $CurrentProjectName called $ServiceEndpointName" -verbose
                            New-AzDevOpsServiceEndpoint @Params -ErrorAction Stop
                        }
                        catch {
                            throw
                        }

                    }
                }
                else {
                    # $Password = New-RandomPassword
                    # $SecureStringPW = ConvertTo-SecureString -String $Password -AsPlainText -Force
                    # $DevOpsSE = Get-VSTeamServiceEndpoint -ProjectName $CurrentProjectName | Where-object {
                    #     $_.Name -eq $ServiceEndpointName
                    # }
                    # $Params = @{
                    #     ProjectName = $CurrentProjectName
                    #     id = $DevOpsSE.id
                    #     object = @{
                    #         'isShared' = $false
                    #         'Type' = 'azurerm'
                    #         'Authorization' = @{
                    #             'isShared' = $false
                    #             parameters = @{
                    #                 tenantid            = $Subscription.TenantId
                    #                 serviceprincipalid  = $AzureAdApp.ApplicationId
                    #                 authenticationType  = "spnKey"
                    #                 serviceprincipalkey = $Password
                                    
                    #             }
                    #             scheme     = "ServicePrincipal"
                    #         }
                    #     }
                    # }
                    # Update-VSTeamServiceEndpoint @Params -ErrorAction Stop
                }
                    
            }
            if ($RefreshCredentials) {
                if ($WhatIf) {
                    Write-verbose "Would have refreshed credentials for the $ServiceEndpointName" -verbose
                }
                else {
                    $DevOpsSE = $CurrentSEList | Where-Object { $_.Name -eq $ServiceEndpointName }
                    $AzureADApp | New-AzADAppCredential -Password $SecureStringPW -EndDate $((Get-Date).AddYears(1))
                    $Params = @{
                        ProjectName = $CurrentProjectName
                        id          = $DevOpsSE.Id
                        object      = @{
                            'Authorization' = @{
                                parameters = @{
                                    tenantid            = $Subscription.TenantId
                                    serviceprincipalid  = $AzureAdApp.ApplicationId
                                    authenticationType  = "spnKey"
                                    serviceprincipalkey = $Password
                                    
                                }
                                scheme     = "ServicePrincipal"
                            }
                        }
                    }
                    Update-VSTeamServiceEndpoint @Params -ErrorAction Stop 
                }
                   
            }
        }
    }
}

if (!($Whatif)) {
    $AzAdSPs = Get-AzADServicePrincipal -DisplayNameBeginsWith 'DevOps-'

    $AzAdSPs | Where-Object {
        $_.DisplayName -like "devops-*-az-prod-subscription-BluestepContributor"
    } | ForEach-Object {
        $AzAdSP = $_
        Select-AzSubscription -Subscription '9d957d40-b4aa-47b6-83ec-2f5bc899a938'
        @('bstp-cdpkey-prod-vault', 'bstp-cdpkey-api-vault') | ForEach-Object {
            $KeyVault = Get-AzKeyVault -VaultName $_ 
            if ($KeyVault) {
                Set-AzKeyVaultAccessPolicy -PermissionsToSecrets 'Get', 'List' -VaultName $KeyVault.VaultName -ObjectId $AzAdSP.Id -ResourceGroupName $KeyVault.ResourceGroupName
            }
            else {
                Throw "Couldn't find the keyvault called $_"
            }
        }
    }
    
    $AzAdSPs | Where-Object {
        $_.DisplayName -like "devops-*-az-test-subscription-BluestepContributor"
    } | ForEach-Object {
        $AzAdSP = $_
        Select-AzSubscription -Subscription '9d957d40-b4aa-47b6-83ec-2f5bc899a938'
        @('bstp-cdpkey-tapi-vault') | ForEach-Object {
            $KeyVault = Get-AzKeyVault -VaultName $_ 
            if ($KeyVault) {
                Set-AzKeyVaultAccessPolicy -PermissionsToSecrets 'Get', 'List' -VaultName $KeyVault.VaultName -ObjectId $AzAdSP.Id -ResourceGroupName $KeyVault.ResourceGroupName
            }
            else {
                Throw "Couldn't find the keyvault called $_"
            }
        }
    }
    
    $AzAdSPs | Where-Object {
        $_.DisplayName -like "devops-*-az-test-subscription-BluestepContributor"
    } | ForEach-Object {
        $AzAdSP = $_
        Select-AzSubscription -Subscription '9bf93c12-d72e-4aee-abec-b8020eb869ab'
        @('bstp-cdpkey-tela-vault', 'bstp-cdpkey-dev-vault', 'bstp-cdpkey-sit-vault', 'bstp-cdpkey-uat-vault') | ForEach-Object {
            $KeyVault = Get-AzKeyVault -VaultName $_ 
            if ($KeyVault) {
                Set-AzKeyVaultAccessPolicy -PermissionsToSecrets 'Get', 'List' -VaultName $KeyVault.VaultName -ObjectId $AzAdSP.Id -ResourceGroupName $KeyVault.ResourceGroupName
            }
            else {
                Throw "Couldn't find the keyvault called $_"
            }
        }
    }    
}