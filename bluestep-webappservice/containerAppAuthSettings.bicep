// Deploy authettings to existing App Service 
// This will add AzureAD authentication to your App Service

param functionAppName string
param appClientId string
param tenantId string
param allowedAudiences array

resource authSettings 'Microsoft.Web/sites/config@2020-06-01' = {
    name: '${functionAppName}/authsettings'
    properties: {
        enabled: true
        unauthenticatedClientAction: 'RedirectToLoginPage'
        tokenStoreEnabled: true
        defaultProvider: 'AzureActiveDirectory'
        clientId: appClientId
        issuer: 'https://login.microsoftonline.com/${tenantId}/v2.0'
        allowedAudiences: allowedAudiences
    }
}
