param location string

param DnsServer array
param subnets array
param addressPrefixes array
param firewallIp string

param enableDdosProtection bool = false
// param enableVmProtection bool = false
param ipAllocations array = []

param peerNetworkId string = ''

param rtdisableBgpRoutePropagation bool = true
param rtroutes array = []
param routeTables array = []
param networkSecurityGroups array = []

var subscriptionName = toLower(replace(replace(subscription().displayName, '_', '-'), ' ', '-'))
var fwpeer = [
  {
    name: 'peer-azfirewall'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
      allowGatewayTransit: false
      useRemoteGateways: true
      doNotVerifyRemoteGateways: false
      remoteVirtualNetwork: {
        id: peerNetworkId
      }
      remoteAddressSpace: {
        addressPrefixes: [
          '10.129.144.0/21'
        ]
      }
      remoteGateways: [
        {
          id: '/subscriptions/2887160a-ea77-4845-aba8-644475701efa/resourceGroups/rg-hub-prod-we/providers/Microsoft.Network/virtualNetworkGateways/vgw-hub-prod'
        }
      ]
    }
  }
]

var defaultroutes = [
  {
    name: 'default_to_firewall'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: firewallIp
    }
  }
]
var allroutes = union(rtroutes, defaultroutes)

resource vnet 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  dependsOn: [
    routeTablesCopy
    networkSecurityGroupCopy
  ]
  name: 'vnet-${subscriptionName}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: {
      dnsServers: DnsServer
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        addressPrefixes: contains(subnet,'addressPrefixes') ? subnet.addressPrefixes : []
        networkSecurityGroup: {
          id: contains(subnet,'networkSecurityGroup') ? resourceId('Microsoft.Network/networkSecurityGroups', subnet.networkSecurityGroup) : defaultNSG.id
        }
        routeTable: {
          id: contains(subnet,'routeTable') ? resourceId('Microsoft.Network/routeTables', subnet.routeTable) : routeTable.id
        }
        
        serviceEndpoints:  contains(subnet,'serviceEndpoints') ? subnet.serviceEndpoints : []
        serviceEndpointPolicies:  contains(subnet,'serviceEndpointPolicies') ? subnet.serviceEndpointPolicies : []
        ipAllocations:  contains(subnet,'ipAllocations') ? subnet.ipAllocations : []
        delegations:  contains(subnet,'delegations') ? subnet.delegations : []
        privateEndpointNetworkPolicies:  contains(subnet,'privateEndpointNetworkPolicies') ? subnet.privateEndpointNetworkPolicies : 'Enabled'
        privateLinkServiceNetworkPolicies:  contains(subnet,'privateLinkServiceNetworkPolicies') ? subnet.privateLinkServiceNetworkPolicies : 'Enabled'
      }
    }]
    virtualNetworkPeerings: ((!contains(subscriptionName,'sandbox')) ? fwpeer : [])
    enableDdosProtection: enableDdosProtection
    // enableVmProtection: enableVmProtection
    ipAllocations: ipAllocations
  }
}

resource routeTablesCopy 'Microsoft.Network/routeTables@2021-02-01' = [for rt in routeTables: {
  name: '${rt.name}'
  location: location
  properties: rt.properties
}]

resource networkSecurityGroupCopy 'Microsoft.Network/networkSecurityGroups@2021-02-01' = [for nsg in networkSecurityGroups: {
  name: '${nsg.name}'
  location: location
  properties: nsg.properties
}]

resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: 'rt-spoke-${subscriptionName}'
  location: location
  properties: {
    routes: allroutes
    disableBgpRoutePropagation: rtdisableBgpRoutePropagation
  }
}

resource defaultNSG 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg-spoke-${subscriptionName}'
  location: location
  properties: {
    securityRules: []
  }
}
