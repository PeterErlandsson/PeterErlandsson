param firewallPublicIpNames array
param publicIpAddressPrefixId string
param location string
param sku string
param tier string

resource publicipAddress 'Microsoft.Network/publicIPAddresses@2020-11-01' = [for ip in firewallPublicIpNames: {
  name: ip
  location: location
  sku: {
    name: sku
    tier: tier
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPPrefix: {
      id: publicIpAddressPrefixId
    }
  }
}]

output publicIps array = [for (item, index) in firewallPublicIpNames: {
  name: 'ipc-fw-prod-00${index}'
  properties: {
    publicIPAddress: {
      id: publicipAddress[index].id
    }
  }
}]
