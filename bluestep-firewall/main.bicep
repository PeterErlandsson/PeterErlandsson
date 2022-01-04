param location string = resourceGroup().location

param dnsServers array = [
  '10.126.196.20'
  '10.126.196.22'
  '10.126.0.11'
  '10.126.0.12'
]

param authorizationKey string = '9dcb03a9-b092-49bf-9729-6c2e80d88755'
param circuitId string = '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-cdpnet-infra-we/providers/Microsoft.Network/expressRouteCircuits/bstp-cdpnet-er01-we'

param GatewaySubnetIPRange string = '10.129.145.0/24'
param firewallIp string = '10.129.144.4'

param firewallSubnetIPRange string = '10.129.144.0/26'
param firewallVnetIPRange string = '10.129.144.0/21'
param firewallSubnetServiceEndpoints array = [
  {
    'service': 'Microsoft.Storage'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.Sql'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.AzureCosmosDB'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.KeyVault'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.ServiceBus'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.EventHub'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.AzureActiveDirectory'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.Web'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.CognitiveServices'
    'locations': [
      '*'
    ]
  }
  {
    'service': 'Microsoft.ContainerRegistry'
    'locations': [
      '*'
    ]
  }
]

param firewallPublicIpNames array = [
  'pip-fw-prod-001'
  'pip-fw-prod-002'
  'pip-fw-prod-003'
  'pip-fw-prod-004'
]

@allowed([
  'Standard'
  'Premium'
])
param firewallPolicySKU string = 'Premium'

@allowed([
  'Standard'
  'Premium'
])
param firewallSKU string = 'Premium'

@allowed([
  'Alert'
  'Deny'
  'Off'
])
param firewallThreatIntelMode string = 'Deny'

param firewallDNSProxyMode bool = true

module publicIpAddresses 'publicIP.bicep' = {
  name: 'fwpublicIpAddress'
  params: {
    sku: 'Standard'
    tier: 'Regional'
    location: location
    firewallPublicIpNames: firewallPublicIpNames
    publicIpAddressPrefixId: publicIpAddressPrefix.id
  }
}

resource vgwpublicIpAddress 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'fwpublicIpAddress'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

var firewallSubnetIpConfig = [
  {
    name: 'ipc-firewallSubnet'
    properties: {
      subnet: {
        id: '${vnet.id}/subnets/AzureFirewallSubnet'
      }
    }
  }
]

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2021-02-01' = {
  name: 'fwp-hub-prod'
  location: location
  properties: {
    snat: {
      privateRanges:[
        '194.209.69.0/24'
        '10.0.0.0/8'
        '172.16.0.0/12'
        '192.168.0.0/16'
        '100.64.0.0/10'
      ]
    }
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

resource azureFirewallWestEuropePolicy 'Microsoft.Network/firewallPolicies@2021-02-01' = {
  name: 'fwp-hub-prod-westeurope'
  location: location
  properties: {
    basePolicy: {
      id: azureFirewallPolicy.id
    }
    threatIntelMode: firewallThreatIntelMode
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
      name: 'AZFW_VNet'
      tier: firewallSKU
    }
    firewallPolicy: {
      id: azureFirewallWestEuropePolicy.id
    }
    ipConfigurations: union(firewallSubnetIpConfig, publicIpAddresses.outputs.publicIps)
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-connectivity-production'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        firewallVnetIPRange
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          routeTable: {
            id: routeTable.id
          }
          addressPrefix: firewallSubnetIPRange
          serviceEndpoints: firewallSubnetServiceEndpoints
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          routeTable: {
            id: routeTableGateway.id
          }
          addressPrefix: GatewaySubnetIPRange
        }
      }
    ]
  }
}

resource publicIpAddressPrefix 'Microsoft.Network/publicIPPrefixes@2020-11-01' = {
  name: 'ippre-firewall-prod'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    prefixLength: 30
  }
}

resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: 'rt-fw-hub-prod'
  location: location
  properties: {
    routes: [
      {
        name: 'default_to_internet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}

resource routeTableGateway 'Microsoft.Network/routeTables@2020-11-01' = {
  name: 'rt-gateway-hub-prod'
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'bluestep_azure'
        properties: {
          addressPrefix: '10.128.0.0/15'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'BICC_Prod'
        properties: {
          addressPrefix: '10.129.0.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'BICC_Test'
        properties: {
          addressPrefix: '10.129.16.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'BICC_Sandbox'
        properties: {
          addressPrefix: '10.129.8.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Corebanking_Prod'
        properties: {
          addressPrefix: '10.129.24.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Corebanking_Test'
        properties: {
          addressPrefix: '10.129.40.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Corebanking_Sandbox'
        properties: {
          addressPrefix: '10.129.32.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Finance_Prod'
        properties: {
          addressPrefix: '10.129.48.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Finance_Test'
        properties: {
          addressPrefix: '10.129.64.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Finance_Sandbox'
        properties: {
          addressPrefix: '10.129.56.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Infrastructure_Prod'
        properties: {
          addressPrefix: '10.129.72.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Infrastructure_Test'
        properties: {
          addressPrefix: '10.129.88.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Infrastructure_Sandbox'
        properties: {
          addressPrefix: '10.129.80.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'ITSecurity_Prod'
        properties: {
          addressPrefix: '10.129.96.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'ITSecurity_Test'
        properties: {
          addressPrefix: '10.129.112.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'ITSecurity_Sandbox'
        properties: {
          addressPrefix: '10.129.104.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Shared_Prod'
        properties: {
          addressPrefix: '10.128.0.0/18'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Shared_Test'
        properties: {
          addressPrefix: '10.128.128.0/18'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Shared_Sandbox'
        properties: {
          addressPrefix: '10.128.64.0/18'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Web_Prod'
        properties: {
          addressPrefix: '10.129.120.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Web_Test'
        properties: {
          addressPrefix: '10.129.136.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Web_Sandbox'
        properties: {
          addressPrefix: '10.129.128.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Management_Production'
        properties: {
          addressPrefix: '10.129.152.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'Management_Test'
        properties: {
          addressPrefix: '10.129.160.0/21'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'to_axians_all'
        properties: {
          addressPrefix: '10.126.0.0/15'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'to_old_hub'
        properties: {
          addressPrefix: '10.126.196.0/23'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
    ]
  }
}

resource logworkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'log-azurefirewall-prod-we'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource vgw 'Microsoft.Network/virtualNetworkGateways@2020-07-01' = {
  name: 'vgw-hub-prod'
  location: location
  tags: {}
  properties: {
    gatewayType: 'ExpressRoute'
    vpnGatewayGeneration: 'None'
    sku: {
      name: 'ErGw1AZ'
      tier: 'ErGw1AZ'
    }
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet.id}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: vgwpublicIpAddress.id
          }
        }
      }
    ]
  }
}

resource symbolicname 'Microsoft.Network/connections@2020-07-01' = {
  name: 'ERConnection'
  location: location
  properties: {
    connectionMode: 'Default'
    routingWeight: 0
    enableBgp: false
    connectionType: 'ExpressRoute'
    authorizationKey: authorizationKey
    virtualNetworkGateway1: {
      properties: {}
      id: vgw.id
    }
    peer: {
      id: circuitId
    }
  }
}
