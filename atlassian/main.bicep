@maxLength(9)
param functionAppName string 

@allowed([
  'tst'
  'prod'
  'dev'
])
param environment string

param location string = resourceGroup().location

param owner string

var Tags = {
  'environment': environment
  'Owner': owner
}
var storageAccountName = 'st${functionAppName}${uniqueString(subscription().subscriptionId, resourceGroup().id)}'
var hostingPlanName = 'hostplan-${environment}-${functionAppName}'
var functionName = '${environment}-${functionAppName}-${uniqueString(subscription().subscriptionId, resourceGroup().id)}'
var actions = [
  'Microsoft.KeyVault/vaults/read'
  'Microsoft.KeyVault/vaults/secrets/read'
]
var dataActions = [
  'Microsoft.KeyVault/vaults/keys/read'
  'Microsoft.KeyVault/vaults/secrets/readMetadata/action'
  'Microsoft.KeyVault/vaults/secrets/getSecret/action'
]
var CustomRoleDefGuid = guid(subscription().id, string(actions), string(dataActions))

resource azFunction 'Microsoft.Web/sites@2019-08-01' = {
  name: functionName
  location: location
  kind: 'functionApp'
  identity: {
    type: 'SystemAssigned'
  }
  tags: Tags
  properties: {
    // name: functionName
    serverFarmId: HostPlan.id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
        }
        {
          'name': 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          'value': 'InstrumentationKey=${appInsights.properties.InstrumentationKey}'
      }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'powershell'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME_VERSION'
          'value': '~7'
        }
        {
          'name': 'AtlassianToken'
          'value': '@Microsoft.KeyVault(SecretUri=)'
        }
        {
          'name': 'AzureWebJobsStorage'
          'value': 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
          // '[concat('DefaultEndpointsProtocol=https;AccountName=',variables('storageAccountName'),';AccountKey=',listKeys(resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName')), '2019-06-01').keys[0].value,';EndpointSuffix=','core.windows.net')]'
        }
        {
          'name': 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          'value': 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
          // '[concat('DefaultEndpointsProtocol=https;AccountName=',variables('storageAccountName'),';AccountKey=',listKeys(resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName')), '2019-06-01').keys[0].value,';EndpointSuffix=','core.windows.net')]'
        }
        {
          'name': 'WEBSITE_CONTENTSHARE'
          'value': '${toLower(functionName)}8224'
          // '[concat(toLower(variables('functionName')), '8224')]'
        }
      ]
    }
  }
}

resource HostPlan 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: hostingPlanName
  location: location
  tags: Tags
  sku: {
    name: 'B1'
    size: 'YB1'
    tier: 'Basic'
    family: 'Y'
    capacity: 0
  }
  properties: {
    // name: hostingPlanName
  }
}

resource StorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  tags: Tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

resource StorageShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${StorageAccount.name}/default/${functionAppName}'
  properties: {
    accessTier:'Cool'
  }
}

resource RoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: CustomRoleDefGuid
  properties: {
    roleName: 'Bluestep-Keyvault-Reader'
    description: 'Read permissions on the secrets'
    assignableScopes: [
      resourceGroup().id
    ]
    permissions: [
      {
        actions: actions
        notActions: []
        dataActions: dataActions
        notDataActions: []
      }
    ]
  }
}

// resource RoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(functionName, RoleDefinition.id,deployment().name)
//   properties: {
//     roleDefinitionId: RoleDefinition.id
//     principalId: azFunction.identity.principalId
//     principalType: 'ServicePrincipal'
//   }
// }

// resource RoleStorageShareContributorAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(functionName, '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb', deployment().name)
//   properties: {
//     roleDefinitionId: '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb'
//     principalId: azFunction.identity.principalId
//     principalType: 'ServicePrincipal'
//   }
// }

resource KeyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'kv-atlassian${functionAppName}-${environment}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: azFunction.identity.principalId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}


resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: 'bstp-appi-${functionName}'
  location: location
  kind: 'web'
  properties: {
    Application_Type:'web'
    IngestionMode: 'ApplicationInsights'
    ApplicationId: 'bstp-appi-${functionName}'
  }
}

output WebsiteIdentity string = azFunction.identity.principalId
output CustomRoleDefinition string = CustomRoleDefGuid
output scope string = resourceGroup().id
output AzWebAppName string = functionName
output StorageAccName string = StorageAccount.name
output kv string = KeyVault.name
