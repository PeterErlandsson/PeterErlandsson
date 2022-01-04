param appName string {
    metadata: {
        description: 'Name that will be common for all resources created.'
    }
}

param customHostname string {
    metadata: {
        description: 'The custom domain name to be used for the web app'
    }
}
param enableSSL bool
param certificateKeyvaultId string
param certificateKeyvaultSecretName string
param httpsOnly bool

param serverFarmId string

param dockerRegistryUrl string
param dockerRegistryUserName string
param dockerRegistryPassword string {
    secure: true
}
param dockerImageName string


param subnetId string
param privatelinkSubnetId string

param appSettings object {
    default: {}
    metadata: {
        description: 'Key-Value pairs representing custom app settings'
    }
}

param appClientId string
param tenantId string
param allowedAudiences array

param environment string {
    allowed:[
        'prod'
        'tst'
        'dev'
    ]
}
param location string {
    default: resourceGroup().location
    metadata: {
        description: 'Location for all resources created'
    }
}
var appNameNoDash = replace(appName, '-', '')
var uniqueStringRg = uniqueString(resourceGroup().id)
var keyVaultName = 'kv-${take(appNameNoDash, 17)}-${environment}'

resource containerApp 'Microsoft.Web/sites@2020-06-01' = {
    name: 'app-${appName}-${environment}'
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        serverFarmId: serverFarmId
        clientAffinityEnabled: true
        siteConfig: {
            'linuxFxVersion': concat('DOCKER|',dockerImageName)
            'windowsFxVersion': 'null'
          }
          httpsOnly: httpsOnly
    }
    tags: {
        'hidden-link:${serverFarmId}': 'Resource'
    }
}

resource privateLink 'Microsoft.Network/privateEndpoints@2020-07-01' = {
  name: 'pe-onprem-${appName}-${environment}'
  location: location
  dependsOn:[
      containerApp
  ]
  properties: {
    subnet: {
        id: privatelinkSubnetId
    }
    privateLinkServiceConnections: [
        {
            name: 'pec-onprem-${appName}-${environment}'
            properties: {
                privateLinkServiceId: containerApp.id
                groupIds: [
                    'sites'
                ]
            }
        }
    ]
  }
}

resource vnetIntegration 'Microsoft.Web/sites/config@2020-06-01' = {
    name: '${containerApp.name}/virtualNetwork'
    properties: {
        subnetResourceId: subnetId
        swiftSupported: true
    }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
    name: keyVaultName
    location: location
    properties: {
        enabledForDeployment: false
        enabledForTemplateDeployment: false
        enabledForDiskEncryption: false
        tenantId: subscription().tenantId
        accessPolicies: [
            {
                // delegate secrets access to function app
                tenantId: containerApp.identity.tenantId
                objectId: containerApp.identity.principalId
                permissions: {
                    secrets: [
                        'get'
                    ]
                }
            }
        ]
        sku: {
            name: 'standard'
            family: 'A'
        }
    }
}

resource secretDockerRegistryPassword 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
    name: '${keyvault.name}/dockerRegistryPassword'
    properties: {
        value: dockerRegistryPassword
    }
}

resource containerAppSettings 'Microsoft.Web/sites/config@2020-06-01' = {
    name: '${containerApp.name}/appsettings'
    properties: {
        DOCKER_REGISTRY_SERVER_URL: dockerRegistryUrl
        DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryUserName
        DOCKER_REGISTRY_SERVER_PASSWORD: '@Microsoft.KeyVault(SecretUri=${reference(secretDockerRegistryPassword.id).secretUri})'
        DOCKER_CUSTOM_IMAGE_NAME: dockerImageName
    }
}

module additionalAppSettings './containerAppAdditionalAppSettings.bicep' = {
    name: 'additionalAppSettings'
    params: {
        existingAppSettings: union(containerAppSettings.properties, appSettings)
        functionAppName: containerApp.name
    }
}

module authSettings './containerAppAuthSettings.bicep' = {
    name: 'authSettings'
    params: {
        functionAppName: containerApp.name
        allowedAudiences: allowedAudiences
        appClientId: appClientId
        tenantId: tenantId
    }
}

module customDomainSettings './containerAppCustomDomainSettings.bicep' = {
    name: 'customDomainSettings'
    params: {
        functionAppName: containerApp.name
        customHostname: customHostname
        serverFarmId: serverFarmId
        enableSSL: enableSSL
        keyvaultId: certificateKeyvaultId
        keyvaultCertificateName: certificateKeyvaultSecretName
    }
}


output PrincipalTenantId string = containerApp.identity.tenantId
output PrincipalId string = containerApp.identity.principalId

output containerAppkind string = containerApp.kind