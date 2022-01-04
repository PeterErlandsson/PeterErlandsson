param location string = resourceGroup().location

param suffix string = 'bstp'

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











resource hubNSG 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: '${suffix}-nsg-hub-we'
  location: location
  properties: {
    securityRules: [for nsg in networkSecurityGroupRule: {
      name: nsg.name
      properties: nsg.properties
    }]
  }
}