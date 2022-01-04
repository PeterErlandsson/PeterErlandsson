param(
    # Display name for app registration
    $ServerAppDisplayName = 'weblogincontainerapp',

    # App name used for template
    $AppName = 'weblogincontainerapp',
    
    # Unique identifier for app, defaults to an azure websites url
    $ServerAppIdentifierUri = "https://$AppName.azurewebsites.net",
    
    # ReplyUris, this is where AzureAD will send the token. Make sure to get this right!
    $ReplyUri = "https://$AppName.azurewebsites.net/.auth/login/aad/callback"
)


# Create configuration for delegated permissions to graph API
# Get application id of Microsoft Graph
$GraphAppId = az ad sp list --query '[?appDisplayName==''Microsoft Graph''].appId' -o tsv --all
# Get all permissions available to graph
$Permissions = az ad sp show --id $GraphAppId --query 'oauth2Permissions' | ConvertFrom-Json
# Select the permissions we need
$EmailPermission = $Permissions.Where{ $_.value -eq 'email' }.id
$ProfilePermission = $Permissions.Where{ $_.value -eq 'profile' }.id
$OpenIdPermission = $Permissions.Where{ $_.value -eq 'openid' }.id

# Build part of a manifest for requiredResourceAccess
$requiredResourceAccess = @(
    @{
        resourceAppId  = $GraphAppId
        resourceAccess = @(
            @{
                id   = $EmailPermission
                type = 'Scope'
            },
            @{
                id   = $ProfilePermission
                type = 'Scope'
            },
            @{
                id   = $OpenIdPermission
                type = 'Scope'
            }
        ) 
    }
) | ConvertTo-Json -AsArray -Depth 4 -Compress | ConvertTo-Json
# Pipe to ConvertTo-Json twice to escape all quotes, or az cli will remove them when parsing

# Register the application
$ServerApp = az ad app create --display-name $ServerAppDisplayName --identifier-uris $ServerAppIdentifierUri  --required-resource-accesses $requiredResourceAccess --reply-urls $ReplyUri | ConvertFrom-Json
# Create a service principal for the application
$null = az ad sp create --id $ServerApp.AppId

# Consent the application for all users
$null = az ad app permission grant --id $ServerApp.AppId --api $GraphAppId --scope "email openid profile"

# Set application to use V2 access tokens
$Body = @{
    api = @{
        requestedAccessTokenVersion = 2
    }
} | ConvertTo-Json -Compress | ConvertTo-Json
# Pipe to ConvertTo-Json twice to escape all quotes, or az cli will remove them when parsing

# Might take a few seconds before app is registered and replicated, waiting before modifying newly created app
Start-Sleep -Seconds 10
$null = az rest --method PATCH --uri "https://graph.microsoft.com/v1.0/applications/$($ServerApp.objectId)" --body $Body --headers "Content-Type=application/json"

# Output the ClientId for use later
Write-Output $ServerApp.AppId