targetScope = 'resourceGroup'

resource Lock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'ReadLock'
  properties: {
    level: 'ReadOnly'
    notes: 'Managed by code, please submit a PR @ https://dev.azure.com/bluestepbank/Infrastructure/_git/Azure-resources'
  }
}
