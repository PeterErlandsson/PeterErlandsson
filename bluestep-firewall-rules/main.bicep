param azureFirewallPolicyName string = 'fwp-hub-prod'

var rulecollectiongroup = ['placeholder']

@batchSize(1)
resource rcgs 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = [for rcg in rulecollectiongroup: {
  name: '${azureFirewallPolicyName}/${rcg.name}'
  properties: rcg.properties
}]

resource ipgproduction 'Microsoft.Network/ipGroups@2021-02-01' existing = {
  name: 'ipg-production'
}

resource ipgtest 'Microsoft.Network/ipGroups@2021-02-01' existing = {
  name: 'ipg-test'
}

resource ipgsandbox 'Microsoft.Network/ipGroups@2021-02-01' existing = {
  name: 'ipg-sandbox'
}

resource ipgdomaincontroller 'Microsoft.Network/ipGroups@2021-02-01' existing = {
  name: 'ipg-domaincontroller'
}

resource ipgadfs 'Microsoft.Network/ipGroups@2021-02-01' existing = {
  name: 'ipg-adfs'
}

module RGLock './modules/resourceLock.bicep' = {
  name: 'ResourceGroupLock'
  scope: resourceGroup(subscription().subscriptionId,resourceGroup().name)
  dependsOn: rcgs
}
