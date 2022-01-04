# Introduction 
This folder contains different networks per environment in Azure.
If you want to edit a production network, you make the change to the production.bicep file etc.

## Examples
This example has two subnets, one simple subnet and one subnet with the service endpoints for Microsoft SQL and Storage enabled.
To view what service endpoints that can be enabled, please check out https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-network/virtual-network-service-endpoints-overview.md
```
module Infra './modules/vnet.bicep' = {
  name: '<Name of deployment>'
  scope: resourceGroup(<Subscription Id>, '${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    rtroutes: routes
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.72.0/21'
    ]
    subnets: [
      {
        name: 'snet-internal'
        addressPrefix: '10.129.72.0/24'
      }
      {
        name: 'snet-sqldatabasebackend'
        addressPrefix: '10.129.73.16/28'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Sql'
            'locations': [
              'westeurope'
              'northeurope'
            ]
          }
          {
            'service': 'Microsoft.Storage'
            'locations': [
              'westeurope'
              'northeurope'
            ]
          }
        ]
        privateEndpointNetworkPolicies: 'Enabled'
      }
    ]
  }
}
```

## Links to read more:
Subnet resource: https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks/subnets?tabs=bicep
Virtual network resource: https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep
Service endpoints: https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-network/virtual-network-service-endpoints-overview.md