param resourceGroupNamePrefix string = 'rg-spoke-'

param location string = 'West Europe'

param dnsServer array = [
  '10.129.144.4'
]

param environment string = 'test'

param firewallIp string = '10.129.144.4'

param routes array = []

param peerNetworkId string = '/subscriptions/2887160a-ea77-4845-aba8-644475701efa/resourceGroups/rg-hub-prod-we/providers/Microsoft.Network/virtualNetworks/vnet-connectivity-production'

var BICCSubscription = 'cd477377-d2d8-4b06-bea0-0e8c0c88ace3'
var CoreBankingSubscription = '4baeebd9-1115-4ab0-9989-a2bc0e9182ce'
var FinanceSubscription = 'c71088dc-0794-4389-866e-45d2a5f50632'
var InfraSubscription = '86d71566-8cbd-4e51-a115-fd7e0df0c3a0'
var ITSecuritySubscription = '8e943c51-c120-4a91-954e-a2039f3df53e'
var SharedSubscription = 'e151adf0-bce6-4aad-ab51-8accf2021f77'
var WebSubscription = 'ad9a9cc4-f2cc-42a9-9941-49acae2ffb87'
var ManagementSubscription = '37aa9fba-943a-47bb-89f1-6be68d729ec3'

module BICC './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-BICCTest'
  scope: resourceGroup(BICCSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.16.0/21'
    ]
    subnets: []
  }
}

module CoreBanking './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-CoreBankingTest'
  scope: resourceGroup(CoreBankingSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
     networkSecurityGroups: [
      {
        name: 'nsg-snet-sql-managedinstance-modelo-test'
        properties: {
          securityRules: [
            {
              name: 'SqlManagement'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '10.129.40.32/27'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 200
                protocol: 'tcp'
                sourceAddressPrefix: 'SqlManagement'
                sourcePortRanges: [
	                	'9000'
		                '9003'
	                	'1438'
	                	'1440'
		                '1452'
                  ]
              }
            }
			      {
              name: 'Mi_Subnet'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '10.129.40.32/27'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 210
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.40.32/27'
                sourcePortRange: '*'
              }
            }
				    {
              name: 'Health_Probe'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '10.129.40.32/27'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 220
                protocol: 'tcp'
                sourceAddressPrefix: 'AzureLoadBalancer'
                sourcePortRange: '*'
              }
            }
            {
              name: 'From_Mi_SubNet_To_AzureCloud'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: 'AzureCloud'
                destinationPortRange: '*'
                direction: 'Outbound'
                priority: 210
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.40.32/27'
                sourcePortRanges: [
		                '443'
		                '12000'
                  ]
              }
            }
					  {
              name: 'From_Mi_Subnet'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '10.129.40.32/27'
                destinationPortRange: '*'
                direction: 'Outbound'
                priority: 220
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.40.32/27'
                sourcePortRange: '*'
              }
            }
          ]
        } 
      }
    ]

    routeTables: [
      {
        name: 'rt-snet-sql-managedinstance-modelo-test'
        properties: {
	        disableBgpRoutePropagation: true
	        routes: [
            {
              name: 'subnet-to-vnetlocal'
              properties: {
              addressPrefix: '10.129.40.32/27'
              nextHopType: 'VnetLocal'
              }
            }
            {
              name: 'mi-azurecloud-westeurope-internet'
              properties: {
              addressPrefix: 'AzureCloud.WestEurope'
              nextHopType: 'Internet'
              }
            }
            {
              name: 'mi-azuremonitor-internet'
              properties: {
              addressPrefix: 'AzureMonitor'
              nextHopType: 'Internet'
              }
            }
            {
              name: 'mi-eventhub-westeurope-internet'
              properties: {
              addressPrefix: 'EventHub.WestEurope'
              nextHopType: 'Internet'
              }
            }
            {
              name: 'mi-sqlmanagement-internet'
              properties: {
              addressPrefix: 'SqlManagement'
              nextHopType: 'Internet'
              }
            }
            {
              name: 'mi-storage-internet'
              properties: {
              addressPrefix: 'Storage'
              nextHopType: 'Internet'
              }
            }
            {
              name: 'mi-azureactivedirectory-internet'
              properties: {
              addressPrefix: 'AzureActiveDirectory'
              nextHopType: 'Internet'
              }
            }
          ] 
        }  
      }     
    ]
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.40.0/21'
    ]
    subnets: [
      {
        name: 'snet-modeloapp-test-westeu'
        addressPrefix: '10.129.40.0/29'
      }
      {
        name: 'snet-sql-managedinstance-modelo-test'
        addressPrefix: '10.129.40.32/27'
        routeTable: 'rt-snet-sql-managedinstance-modelo-test'
        networkSecurityGroup: 'nsg-snet-sql-managedinstance-modelo-test'
         delegations: [
          {
            name: 'delegation'
            properties: {
              serviceName: 'Microsoft.Sql/managedInstances'
            }
            type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
          }
        ]
      }
      {
        name: 'snet-modelosql-test-westeu'
        addressPrefix: '10.129.40.8/29'
      }
    ]
  }
}

module Finance './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-FinanceTest'
  scope: resourceGroup(FinanceSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.64.0/21'
    ]
    subnets: [
    {
        name: 'snet-morssql-test-westeu'
        addressPrefix: '10.129.64.0/29'
      }
     {
        name: 'snet-morsapp-test-westeu'
        addressPrefix: '10.129.64.8/29'
      }
     {
        name: 'snet-prevapp-test-westeu'
        addressPrefix: '10.129.64.16/29'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
     {
        name: 'snet-ubwapp-test-westeu'
        addressPrefix: '10.129.64.24/29'
      }
     {
        name: 'snet-ubwweb-test-westeu'
        addressPrefix: '10.129.64.32/29'
      }
     {
        name: 'snet-ubwsql-test-westeu'
        addressPrefix: '10.129.64.40/29'
      } 
    ]
  }
}

module Infra './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-InfraTest'
  scope: resourceGroup(InfraSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.88.0/21'
    ]
    subnets: [
      {
        name: 'internal'
        addressPrefix: '10.129.88.0/24'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Storage'
          }
          {
            'service': 'Microsoft.KeyVault'
          }
        ]
      }
      {
        name: 'snet-buildagent-test'
        addressPrefix: '10.129.89.0/26'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Storage'
          }
          {
            'service': 'Microsoft.KeyVault'
          }
        ]
        privateEndpointNetworkPolicies: 'Enabled'
      }
    ]
  }
}

module ITSecurity './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-ITSecurityTest'
  scope: resourceGroup(ITSecuritySubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.112.0/21'
    ]
    subnets: []
  }
}

module Shared './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-SharedTest'
  scope: resourceGroup(SharedSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.128.128.0/18'
    ]
    subnets: [
      {
        name: 'snet-shared-westeu-001'
        addressPrefix: '10.128.128.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
      }
      {
        name: 'snet-k8s-api-test'
        addressPrefix: '10.128.136.0/21'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.KeyVault'
          }
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
      {
        name: 'snet-k8s-sit'
        addressPrefix: '10.128.144.0/22'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.KeyVault'
          }
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
      {
        name: 'snet-k8s-uat'
        addressPrefix: '10.128.148.0/22'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.KeyVault'
          }
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
      {
        name: 'snet-k8s-elastic-test'
        addressPrefix: '10.128.152.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.KeyVault'
          }
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
      {
        name: 'snet-k8s-dev'
        addressPrefix: '10.128.160.0/21'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.KeyVault'
          }
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
    ]
  }
}

module Web './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-WebTest'
  scope: resourceGroup(WebSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    networkSecurityGroups: [
      {
        name: 'nsg-gateway'
        properties: {
          securityRules: [
            {
              name: 'AllowInternetAndVlanOutBound'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '*'
                destinationPortRange: '*'
                direction: 'Outbound'
                priority: 100
                protocol: '*'
                sourceAddressPrefix: '*'
                sourcePortRange: '*'
              }
            }
            {
              name: 'AllowLoadBalancer'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '*'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 110
                protocol: '*'
                sourceAddressPrefix: 'AzureLoadBalancer'
                sourcePortRange: '*'
              }
            }
            {
              name: 'AllowRdpVlan'
              properties: {
                access: 'Allow'
                destinationAddressPrefixes: [
                  '10.129.136.0/26'
                  '10.129.136.64/26'
                ]
                destinationPortRange: '3389'
                direction: 'Inbound'
                priority: 220
                protocol: '*'
                sourceAddressPrefix: '10.126.45.0/27'
                sourcePortRange: '*'
              }
            }
            {
              name: 'AllowHttpsandHttpForConsultants'
              properties: {
                access: 'Allow'
                destinationAddressPrefixes: [
                  '10.129.136.0/26'
                  '10.129.136.64/26'
                ]
                destinationPortRanges: [
                  '80'
                  '443'
                ]
                direction: 'Inbound'
                priority: 230
                protocol: '*'
                sourceAddressPrefix: '10.126.45.0/27'
                sourcePortRange: '*'
              }
            }
            {
              name: 'AllowVirtualNetwork'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '*'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 100
                protocol: '*'
                sourceAddressPrefix: 'VirtualNetwork'
                sourcePortRange: '*'
              }
            }
            {
              name: 'AllowInternetTraffic65200to65535'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '*'
                destinationPortRange: '65200-65535'
                direction: 'Inbound'
                priority: 130
                protocol: '*'
                sourceAddressPrefix: 'GatewayManager'
                sourcePortRange: '*'
              }
            }
            {
              name: 'Deny_All'
              properties: {
                access: 'Deny'
                destinationAddressPrefix: '*'
                destinationPortRange: '*'
                direction: 'Inbound'
                priority: 4096
                protocol: '*'
                sourceAddressPrefix: '*'
                sourcePortRange: '*'
              }
            }
          ]
        }
      }
    ]
    routeTables: [
      {
        name: 'rt-gateway'
        properties: {
          disableBgpRoutePropagation: true
          routes: [
            {
              name: 'Gateway_default'
              properties: {
                addressPrefix: '0.0.0.0/0'
                nextHopType: 'Internet'
              }
            }
            {
              name: 'ExpressRoute'
              properties: {
                addressPrefix: '10.0.0.0/8'
                nextHopType: 'VirtualAppliance'
                nextHopIpAddress: '10.129.144.4'
              }
            }
          ]
        }
      }
    ]
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.136.0/21'
    ]
    subnets: [
      {
        name: 'frontend'
        addressPrefix: '10.129.136.0/26'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Sql'
          }
          {
            'service': 'Microsoft.Storage'
          }
          {
            'service': 'Microsoft.KeyVault'
          }
        ]
      }
      {
        name: 'gateway'
        addressPrefix: '10.129.136.64/26'
        routeTable: 'rt-gateway'
        networkSecurityGroup: 'nsg-gateway'
        serviceEndpoints: [
          {
            'service': 'Microsoft.AzureActiveDirectory'
          }
          {
            'service': 'Microsoft.KeyVault'
          }
        ]
      }
    ]
  }
}

module Management './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-ManagementTest'
  scope: resourceGroup(ManagementSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.160.0/21'
    ]
    subnets: []
  }
}
