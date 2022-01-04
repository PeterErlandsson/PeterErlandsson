param location string = resourceGroup().location

param VnetSpoke array = [
  {
    name: 'vnet-infrastructure-test'
    id: '/subscriptions/86d71566-8cbd-4e51-a115-fd7e0df0c3a0/resourceGroups/rg-spoke-test/providers/Microsoft.Network/virtualNetworks/vnet-infrastructure-test'
    allowRemoteVnetToUseHubVnetGateways: true
    enableInternetSecurity: true
    labels: []
  }
  {
    name: 'bstp-cpnet-infra-vnet01-we'
    id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-cdpnet-infra-we/providers/Microsoft.Network/virtualNetworks/bstp-cpnet-infra-vnet01-we'
    allowRemoteVnetToUseHubVnetGateways: false
    enableInternetSecurity: false
    labels: []
  }
]

param dnsServers array = [
  '10.126.196.20'
  '10.126.196.22'
  '10.126.0.11'
  '10.126.0.12'
]

param firewallIPRange string = '10.129.144.0/21'

@allowed([
  'Standard'
  'Premium'
])
param firewallPolicySKU string = 'Standard'

@allowed([
  'Standard'
  'Premium'
])
param firewallSKU string = 'Standard'

@allowed([
  'Alert'
  'Deny'
  'Off'
])
param firewallThreatIntelMode string = 'Deny'

param firewallDNSProxyMode bool = true

resource virtualWAN 'Microsoft.Network/virtualWans@2020-11-01' = {
  name: 'vwan-hub-prod-001'
  location: location
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    office365LocalBreakoutCategory: 'None'
    type: 'Standard'
  }
}

resource virtualHub 'Microsoft.Network/virtualHubs@2020-11-01' = {
  name: 'vhub-prod-001'
  location: location
  properties: {
    addressPrefix: firewallIPRange
    virtualWan: {
      id: virtualWAN.id
    }
  }
}

resource virtualhubconnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2020-07-01' = [for spoke in VnetSpoke: {
  name: '${virtualHub.name}/hub-${spoke.name}'
  properties: {
    enableInternetSecurity: spoke.enableInternetSecurity
    allowRemoteVnetToUseHubVnetGateways: spoke.allowRemoteVnetToUseHubVnetGateways
    remoteVirtualNetwork: {
      id: spoke.id
    }
    routingConfiguration: {
      associatedRouteTable: {
        id: routetable.id
      }
      propagatedRouteTables: {
        ids: [
          {
            id: routetable.id
          }
        ]
        labels: spoke.labels
      }
    }
  }
}]

resource routetable 'Microsoft.Network/virtualHubs/hubRouteTables@2020-11-01' = {
  name: '${virtualHub.name}/RT-fw-vnet'
  properties: {
    labels: [
      'vnet'
    ]
    routes: [
      {
        name: 'SpokeToFirewall'
        destinationType: 'CIDR'
        destinations: [
          '10.128.0.0/15'
        ]
        nextHop: azureFirewall.id
        nextHopType: 'ResourceId'
      }
      {
        name: 'InternetToFirewall'
        destinationType: 'CIDR'
        destinations: [
          '0.0.0.0/0'
        ]
        nextHop: azureFirewall.id
        nextHopType: 'ResourceId'
      }
    ]
  }
}

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2020-07-01' = {
  name: 'fwp-hub-we'
  location: location
  properties: {
    threatIntelMode: firewallThreatIntelMode
    dnsSettings: {
      servers: dnsServers
      enableProxy: firewallDNSProxyMode
    }
    sku: {
      tier: firewallPolicySKU
    }
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2020-07-01' = {
  name: 'fw-hub-we'
  location: location
  properties: {
    sku: {
      name: 'AZFW_Hub'
      tier: firewallSKU
    }
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHub: {
      id: virtualHub.id
    }
    firewallPolicy: {
      id: azureFirewallPolicy.id
    }
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}
