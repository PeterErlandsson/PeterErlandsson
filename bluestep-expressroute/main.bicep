param location string = resourceGroup().location

param dnsServers array = [
  '10.126.196.20'
  '10.126.196.22'
  '10.126.0.11'
  '10.126.0.12'
]

param firewallVnetAddressPrefixes array = [
  '10.126.196.0/23'
]

param subnets array = [
  {
    Name: 'GatewaySubnet'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.96/27'
      serviceEndpoints: []
      delegations: []
    }
  }
  {
    Name: 'bstp-net-mgmnt-jmp-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.64/28'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
          locations: [
            'westeurope'
            'northeurope'
          ]
        }
      ]
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-cdpnet-adfs-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.32/28'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
          locations: [
            'westeurope'
            'northeurope'
          ]
        }
        {
          service: 'Microsoft.KeyVault'
          locations: [
            '*'
          ]
        }
      ]
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-net-wac-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.128/28'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
          locations: [
            'westeurope'
            'northeurope'
          ]
        }
        {
          service: 'Microsoft.KeyVault'
          locations: [
            '*'
          ]
        }
      ]
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-cdpnet-adfs-proxy-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.48/28'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
          locations: [
            'westeurope'
            'northeurope'
          ]
        }
        {
          service: 'Microsoft.KeyVault'
          locations: [
            '*'
          ]
        }
      ]
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-cdpnet-dc-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.16/28'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
          locations: [
            'westeurope'
            'northeurope'
          ]
        }
        {
          service: 'Microsoft.KeyVault'
          locations: [
            '*'
          ]
        }
      ]
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-net-vs-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.144/28'
      serviceEndpoints: []
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-net-adf-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.160/28'
      serviceEndpoints: []
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'bstp-net-bi-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.176/28'
      serviceEndpoints: []
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
  {
    Name: 'AzureFirewallSubnet'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.192/26'
      serviceEndpoints: []
      delegations: []
    }
  }
  {
    Name: 'bstp-net-vdi-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.197.0/25'
      serviceEndpoints: []
      delegations: []
    }
  }
  {
    Name: 'bstp-net-filehub-subnet-we'
    Properties: {
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      addressPrefix: '10.126.196.80/28'
      serviceEndpoints: []
      delegations: []
      networkSecurityGroup: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-nsg-hub-rg-we/providers/Microsoft.Network/networkSecurityGroups/bstp-nsg-hub-we'
      }
      routeTable: {
        id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-hub-rg-we/providers/Microsoft.Network/routeTables/bstp-net-hub-rt-we'
      }
    }
  }
]

param vnetpeering array = [
  {
    Name: 'bstp-cdpnet-az-infra-devops-peer-we'
    Properties: {
      remoteVirtualNetwork: {
        id: '/subscriptions/4cce1b5c-7a0c-455a-a9b9-7de30b3433a5/resourceGroups/bstp-cdnet-devops-we/providers/Microsoft.Network/virtualNetworks/bstp-cdpnet-vnet01-we'
      }
      allowVirtualNetworkAccess: 'true'
      allowForwardedTraffic: 'true'
      allowGatewayTransit: 'true'
      useRemoteGateways: 'false'
      doNotVerifyRemoteGateways: 'false'
      remoteAddressSpace: {
        addressPrefixes: [
          '10.126.192.0/24'
          '10.126.194.0/24'
        ]
      }
      routeServiceVips: {}
    }
  }
  {
    Name: 'bstp-net-hub-az-test-peer-we'
    Properties: {
      remoteVirtualNetwork: {
        id: '/subscriptions/9bf93c12-d72e-4aee-abec-b8020eb869ab/resourceGroups/AZ-TEST-NETWORK-RG/providers/Microsoft.Network/virtualNetworks/AZ-TEST-NETWORK-VNET'
      }
      allowVirtualNetworkAccess: 'true'
      allowForwardedTraffic: 'true'
      allowGatewayTransit: 'true'
      useRemoteGateways: 'false'
      doNotVerifyRemoteGateways: 'false'
      remoteAddressSpace: {
        addressPrefixes: [
          '10.126.128.0/20'
          '10.127.0.0/18'
        ]
      }
      routeServiceVips: {}
    }
  }
  {
    Name: 'bstp-net-az-hub-prod-peer-we'
    Properties: {
      remoteVirtualNetwork: {
        id: '/subscriptions/9d957d40-b4aa-47b6-83ec-2f5bc899a938/resourceGroups/bstp-cdpnet-prod-vnet01-we/providers/Microsoft.Network/virtualNetworks/bstp-cdpnet-prod-vnet01-we'
      }
      allowVirtualNetworkAccess: 'true'
      allowForwardedTraffic: 'true'
      allowGatewayTransit: 'true'
      useRemoteGateways: 'false'
      doNotVerifyRemoteGateways: 'false'
      remoteAddressSpace: {
        addressPrefixes: [
          '10.126.144.0/20'
          '10.127.64.0/18'
        ]
      }
      routeServiceVips: {}
    }
  }
]
param prefix string = 'bstp'

@allowed([
  'Standard'
  'Premium'
])
param firewallSKU string = 'Standard'

param threatIntelWhitelist object = {
    ipAddresses: []
    fqdns: []
}

@allowed([
  'Alert'
  'Deny'
  'Off'
])
param firewallThreatIntelMode string = 'Deny'

param firewallDNSProxyMode bool = false
param firewallRequireProxyForNetworkRules bool = false

@allowed([
  'Off'
  'Alert'
  'Deny'
])
param firewallIntrusionDetection string = 'Deny'

param firewallIntrusionSignatureOverrides array = []
param firewallInstrusionBypassTrafficSettings array = []
param firewallIdentity object = {}

param networkSecurityGroupRule array = [
  {
    Name: 'RDP'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '3389'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '192.168.65.0/24'
        '10.126.40.0/24'
        '10.126.34.0/24'
        '10.126.196.64/28'
        '10.126.0.16'
        '10.126.50.0/23'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '102'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_DCtoDC'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.20'
        '10.126.196.22'
      ]
      destinationAddressPrefixes: [
        '10.126.196.20'
        '10.126.196.22'
      ]
      access: 'Allow'
      priority: '100'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '25'
        '53'
        '67'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '2535'
        '3268-3269'
        '5722'
        '9389'
        '49152-65535'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_DCPorts_from_OnPremDC_To_AzDC'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.0.11'
        '10.126.0.12'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '101'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '25'
        '53'
        '67'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '2535'
        '3268-3269'
        '5722'
        '9389'
        '49152-65535'
      ]
      destinationApplicationSecurityGroups: [
        {
          id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-cdpnet-infra-we/providers/Microsoft.Network/applicationSecurityGroups/bstp-cdpnet-dc-asg-we'
        }
      ]
    }
  }
  {
    Name: 'AllowDNSLookup'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '53'
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.128.0/20'
        '10.126.144.0/20'
        '10.126.194.0/24'
        '10.126.192.0/24'
        '10.126.196.0/23'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '103'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: [
        {
          id: '/subscriptions/d42486c4-f86c-4f3a-8ba9-9f5803e332d8/resourceGroups/bstp-cdpnet-infra-we/providers/Microsoft.Network/applicationSecurityGroups/bstp-cdpnet-dc-asg-we'
        }
      ]
    }
  }
  {
    Name: 'Allow_RFC1918toDC'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.0.0.0/8'
        '172.16.0.0/12'
        '192.168.0.0/16'
      ]
      destinationAddressPrefixes: [
        '10.126.196.20'
        '10.126.196.22'
      ]
      access: 'Allow'
      priority: '104'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '25'
        '53'
        '67'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '2535'
        '3268-3269'
        '5722'
        '9389'
        '49152-65535'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'adfs_to_adfs'
    properties: {
      protocol: '*'
      description: 'Rule to allow traffic between adfs servers'
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
        '10.126.196.38'
      ]
      destinationAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
        '10.126.196.38'
      ]
      access: 'Allow'
      priority: '105'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_WAP_To_ADFS_HTTPS'
    properties: {
      protocol: '*'
      description: 'Allow traffic from wap to adfs HTTPS'
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
        '52.137.57.9'
      ]
      destinationAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
        '10.126.196.38'
      ]
      access: 'Allow'
      priority: '106'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_RFC1918_ADFS_443'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.0.0.0/8'
        '172.16.0.0/12'
        '192.168.0.0/16'
      ]
      destinationAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
        '10.126.196.38'
      ]
      access: 'Allow'
      priority: '107'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'allow_npm_from_onprem_to_jumpsrvtest'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '8084'
      destinationAddressPrefix: '10.126.128.21'
      sourceAddressPrefix: '10.126.13.11'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '110'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Deny_All'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: '*'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Deny'
      priority: '4096'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow-RDP-Vnet'
    properties: {
      protocol: '*'
      description: 'Allow RDP from Vnet'
      sourcePortRange: '*'
      destinationPortRange: '3389'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '200'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow-HTTPS-From-Everywhere'
    properties: {
      protocol: '*'
      description: 'Allow HTTPS from Everywhere'
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: ''
      sourceAddressPrefix: '*'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
      ]
      access: 'Allow'
      priority: '201'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow-https-internet'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: 'Internet'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '210'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow-wap-https-adfs'
    properties: {
      protocol: '*'
      description: 'Allows Https from wap to adfs and lb'
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: ''
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
      ]
      destinationAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
        '10.126.196.38'
      ]
      access: 'Allow'
      priority: '220'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Deny-All'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
      ]
      destinationAddressPrefixes: []
      access: 'Deny'
      priority: '221'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowAzureLoadBalancer'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: 'AzureLoadBalancer'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '4095'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowAzureLoabbalancer'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: 'AzureLoadBalancer'
      sourceAddressPrefix: '*'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '200'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AD_Audit_Incoming'
    properties: {
      protocol: '*'
      description: 'Incoming ports from AD Audit to ADFS'
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: ''
      sourceAddressPrefix: '10.126.1.5'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: [
        '10.126.196.36'
        '10.126.196.37'
      ]
      access: 'Allow'
      priority: '108'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '135'
        '137'
        '138'
        '139'
        '445'
        '49152-65535'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowWacToRFC1918'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '5985'
      destinationAddressPrefix: ''
      sourceAddressPrefix: '10.126.196.132'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: [
        '10.0.0.0/8'
        '172.16.0.0/12'
        '192.168.0.0/16'
      ]
      access: 'Allow'
      priority: '111'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowadfstowacTEMP'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: '10.126.196.132'
      sourceAddressPrefix: '10.126.196.36'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '112'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '3389'
        '445'
        '443'
        '5985'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_All_Outbound'
    properties: {
      protocol: '*'
      description: 'Allow All outboind except wap.'
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '*'
      sourceAddressPrefix: '*'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '222'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allowhktowachttps'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: '10.126.196.132'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.40.0/23'
        '192.168.65.0/24'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '113'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowWapToSupportBluestep'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '5721'
      destinationAddressPrefix: '217.151.196.229'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.196.53'
        '10.126.196.54'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '211'
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AD_Audit_Incoming_DCs'
    properties: {
      protocol: '*'
      description: 'Incoming ports from AD Audit to DCs'
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: ''
      sourceAddressPrefix: '10.126.1.5'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: [
        '10.126.196.22'
        '10.126.196.20'
      ]
      access: 'Allow'
      priority: '109'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '389'
        '636'
        '3268'
        '3269'
        '88'
        '135'
        '137'
        '138'
        '139'
        '445'
        '49152-65535'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowAxiansF5ToNPS'
    properties: {
      protocol: '*'
      description: 'Azure MFA extension'
      sourcePortRange: '*'
      destinationPortRange: ''
      destinationAddressPrefix: '10.126.196.39'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.22.250'
        '10.126.22.251'
        '10.126.22.252'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '114'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: [
        '1812'
        '1813'
      ]
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'AllowAxiansF5PingToNPS'
    properties: {
      protocol: 'ICMP'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '10.126.196.39'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.22.250'
        '10.126.22.251'
        '10.126.22.252'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '115'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Deny_Internet_To_AZ-VS-03'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '10.126.196.149'
      sourceAddressPrefix: 'Internet'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Deny'
      priority: '120'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Deny_Internet_To_AZ-VS-03_Public'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '52.174.180.121'
      sourceAddressPrefix: 'Internet'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Deny'
      priority: '119'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_AZ-VS-03_To_HUB_Vnet'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '10.126.196.0/23'
      sourceAddressPrefix: '10.126.196.149'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '116'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_BS_VPN_TO_WAC'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: '10.126.196.132'
      sourceAddressPrefix: ''
      sourceAddressPrefixes: [
        '10.126.34.0/24'
        '10.126.50.0/23'
      ]
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '121'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
  {
    Name: 'Allow_Jumphub_TO_WAC'
    properties: {
      protocol: '*'
      description: ''
      sourcePortRange: '*'
      destinationPortRange: '443'
      destinationAddressPrefix: '10.126.196.132'
      sourceAddressPrefix: '10.126.196.68'
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
      access: 'Allow'
      priority: '122'
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      destinationApplicationSecurityGroups: []
    }
  }
]

param rtdisableBgpRoutePropagation bool = false
param rtroutes array = []

var defaultroutes = [
  {
    name: 'default_to_internet'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'Internet'
    }
  }
]
var allroutes = union(rtroutes, defaultroutes)

var expressRoutePeering = [
  {
    Name: 'AzurePrivatePeering'
    properties: {
      peeringType: 'AzurePrivatePeering'
      azureASN: 12076
      peerASN: 2119
      primaryPeerAddressPrefix: '172.17.80.224/30'
      secondaryPeerAddressPrefix: '172.17.80.228/30'
      primaryAzurePort: ''
      secondaryAzurePort: ''
      state: 'Enabled'
      vlanId: 100
      microsoftPeeringConfig: {
        advertisedPublicPrefixes: []
        advertisedCommunities: []
        customerASN: 0
        legacyMode: 0
        routingRegistryName: 'NONE'
      }
    }
  }
  {
    Name: 'MicrosoftPeering'
    properties: {
      routeFilter: {
        id: expressRouteFilter.id
      }
      peeringType: 'MicrosoftPeering'
      azureASN: 12076
      peerASN: 2119
      primaryPeerAddressPrefix: '193.214.128.224/30'
      secondaryPeerAddressPrefix: '193.214.128.228/30'
      primaryAzurePort: ''
      secondaryAzurePort: ''
      state: 'Enabled'
      vlanId: 101
      microsoftPeeringConfig: {
        advertisedPublicPrefixes: [
          '193.214.128.220/30'
        ]
        advertisedCommunities: [
          '12076:54002'
          '12076:51002'
          '12076:52002'
          '12076:53002'
        ]
        customerASN: 0
        legacyMode: 0
        routingRegistryName: 'NONE'
      }
    }
  }
]

var vnetName = '${prefix}-cpnet-infra-vnet01-we'
var firewallName = '${prefix}-net-azfw-hub-we'
var firewallPolicyName = '${prefix}-net-fwp-hub-we'

resource firewallPublicIp 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: '${prefix}-net-azfw-pip-hub-we'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    ipAddress: '52.157.228.141'
    idleTimeoutInMinutes: 4
  }
}

resource gatewayPublicIp 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: '${prefix}-cdpnet-er-pip01'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    ipAddress: '52.174.34.165'
    idleTimeoutInMinutes: 4
  }
}

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2020-07-01' = {
  name: firewallPolicyName
  location: location
  properties: {
    threatIntelMode: firewallThreatIntelMode
    threatIntelWhitelist: threatIntelWhitelist
    dnsSettings: {
      servers: dnsServers
      enableProxy: firewallDNSProxyMode
    }
    // intrusionDetection: {
    //   mode: firewallIntrusionDetection
    //   configuration: {
    //     signatureOverrides: firewallIntrusionSignatureOverrides
    //     bypassTrafficSettings: firewallInstrusionBypassTrafficSettings
    //   }
    // }
    sku: {
      tier: firewallSKU
    }
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2020-07-01' = {
  name: firewallName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bstp-net-azfw-pip-hub-we'
        properties: {
          privateIPAddress: '10.126.196.196'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: firewallPublicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubNetwork.name, 'AzureFirewallSubnet')
          }
        }
      }
    ]
    firewallPolicy: {
      id: azureFirewallPolicy.id
    }
    additionalProperties: {}
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

resource hubNetwork 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: firewallVnetAddressPrefixes
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: subnet.properties
    }]
    virtualNetworkPeerings: [for peering in vnetpeering: {
      name: peering.name
      properties: peering.properties
    }]
  }
}

resource hubNSG 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: '${prefix}-nsg-hub-we'
  location: location
  properties: {
    securityRules: [for nsg in networkSecurityGroupRule: {
      name: nsg.name
      properties: nsg.properties
    }]
  }
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-07-01' = {
  name: '${prefix}-cdpnet-vnetgw01-ER-we'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'default'
        type: 'Microsoft.Network/virtualNetworkGateways/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubNetwork.name, 'GatewaySubnet')
          }
          publicIPAddress: {
            id: gatewayPublicIp.id
          }
        }
      }
    ]
    gatewayType: 'ExpressRoute'
    vpnType: 'PolicyBased'
    vpnGatewayGeneration: 'None'
    enableBgp: false
    enablePrivateIpAddress: false
    activeActive: false
    sku: {
      name: 'Standard'
      tier: 'Standard'
    }
    packetCaptureDiagnosticState: 'None'
  }
}

resource expressRoute 'Microsoft.Network/expressRouteCircuits@2020-07-01' = {
  name: '${prefix}-cdpnet-er01-we'
  location: location
  sku: {
    family: 'UnlimitedData'
    name: 'Premium_UnlimitedData'
    tier: 'Premium'
  }
  properties: {
    allowClassicOperations: false
    authorizations: []
    peerings: expressRoutePeering
    serviceProviderProperties: {
      serviceProviderName: 'Telenor'
      peeringLocation: 'Amsterdam'
      bandwidthInMbps: 500
    }
    allowGlobalReach: false
    globalReachEnabled: false
    serviceKey: '73ec56af-dfcb-42c4-aa97-54ba724dd5e1'
  }
}

resource expressRouteFilter 'Microsoft.Network/routeFilters@2020-07-01' = {
  name: '${prefix}-ER-RouteFilter01-we'
  location: location
  properties: {
    rules: [
      {
        name: 'Azureservice'
        properties: {
          access: 'Allow'
          routeFilterRuleType: 'Community'
          communities: [
            '12076:54002'
            '12076:51002'
            '12076:52002'
            '12076:53002'
          ]
        }
        type: 'Microsoft.Network/routeFilters/routeFilterRules'
      }
    ]
  }
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2020-07-01' = {
  name: '${prefix}-cdpnet-lnetgw01-we'
  location: location
  properties: {
    gatewayIpAddress: '217.151.197.166'
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.65.0/24'
        '10.126.40.0/24'
        '10.126.10.0/24'
        '10.126.12.11/32'
        '10.126.12.12/32'
        '10.126.21.32/32'
        '10.126.21.38/32'
        '10.126.21.40/32'
        '10.126.34.0/24'
        '10.126.26.10/32'
        '10.126.26.11/32'
        '10.126.21.37/32'
        '10.126.1.11/32'
        '10.126.24.10/32'
        '10.126.17.12/32'
        '10.126.14.10/32'
        '10.126.2.13/32'
        '10.126.12.11/32'
        '10.126.45.0/24'
      ]
    }
  }
}

resource connection 'Microsoft.Network/connections@2020-07-01' = {
  name: 'con-cdpnet-ER-Telenor'
  location: location
  properties: {
    packetCaptureDiagnosticState: 'None'
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
    }
    connectionType: 'ExpressRoute'
    routingWeight: 0
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    ingressBytesTransferred: 0
    egressBytesTransferred: 0
    peer: {
      id: expressRoute.id
    }
    expressRouteGatewayBypass: false
    dpdTimeoutSeconds: 0
    connectionMode: 'Default'
  }
}

resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: 'rt-hub-prod'
  location: location
  properties: {
    routes: allroutes
    disableBgpRoutePropagation: rtdisableBgpRoutePropagation
  }
}
