targetScope = 'managementGroup'

param resourceGroupNamePrefix string = 'rg-spoke-'

param location string = 'West Europe'

param dnsServer array = [
  '10.129.144.4'
]

param firewallIp string = '10.129.144.4'

param environment string = 'production'

param routes array = []

param peerNetworkId string = '/subscriptions/2887160a-ea77-4845-aba8-644475701efa/resourceGroups/rg-hub-prod-we/providers/Microsoft.Network/virtualNetworks/vnet-connectivity-production'

var BICCSubscription = '9c1f72c2-f361-47ef-9e84-385945de7c43'
var CoreBankingSubscription = 'f9eb3a45-65eb-4b77-a97a-3e8d15bb3202'
var FinanceSubscription = '008d0703-8b3e-486f-bd44-1a73545e4bb6'
var InfraSubscription = '373ea7c9-4c36-440b-a23a-f2ded206dbe4'
var ITSecuritySubscription = '851fe226-3dbe-41b9-9523-1cd7914ba9f0'
var SharedSubscription = '15fd53fd-1f42-46b2-8d17-b4e4177147cb'
var WebSubscription = '1a4b8123-9a77-4b77-9c37-0fe324ee7588'
var ManagementSubscription = 'd903b703-93ed-43c2-ad4c-0c3815e44fba'

module BICC './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-BICCProd'
  scope: resourceGroup(BICCSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    rtroutes: routes
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.0.0/21'
    ]
    subnets: []
  }
}

module CoreBanking './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-CoreBankingProd'
  scope: resourceGroup(CoreBankingSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    rtroutes: routes
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.24.0/21'
    ]
    subnets: []
  }
}

module Finance './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-FinanceProd'
  scope: resourceGroup(FinanceSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    rtroutes: routes
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.48.0/21'
    ]
    subnets: [
      {
        name: 'snet-morsapp-prod-westeu'
        addressPrefix: '10.129.48.0/29'
      }
      {
        name: 'snet-morssql-prod-westeu'
        addressPrefix: '10.129.48.8/29'
      }
     {
        name: 'snet-prevapp-prod-westeu'
        addressPrefix: '10.129.48.16/29'
        privateEndpointNetworkPolicies: 'Disabled'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Sql'
          }
        ]
      }
      {
        name: 'snet-ubwapp-prod-westeu'
        addressPrefix: '10.129.48.24/29'
      }
      {
        name: 'snet-ubwweb-prod-westeu'
        addressPrefix: '10.129.48.32/29'
      }
      {
        name: 'snet-ubwsql-prod-westeu'
        addressPrefix: '10.129.48.40/29'
      }
    ]
  }
}

module Infra './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-InfraProd'
  scope: resourceGroup(InfraSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    rtroutes: routes
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.72.0/21'
    ]
    subnets: [
      {
        name: 'internal'
        addressPrefix: '10.129.72.0/24'
      }
      {
        name: 'vm-printserver-prod'
        addressPrefix: '10.129.73.0/29'
      }
      {
        name: 'vdi-swift'
        addressPrefix: '10.129.73.8/29'
        networkSecurityGroup: 'nsg-vdi-swift-production'
      }
      {
        name: 'snet-goanywhere'
        addressPrefix: '10.129.73.16/28'
        serviceEndpoints: [
          {
            'service': 'Microsoft.Sql'
          }
          {
            'service': 'Microsoft.Storage'
          }
        ]
        privateEndpointNetworkPolicies: 'Disabled'
      }
      {
        name: 'snet-s1d-prod-westeu'
        addressPrefix: '10.129.73.32/29'
      }
      {
        name: 'snet-buildagent-prod'
        addressPrefix: '10.129.73.64/26'
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
      {
        name: 'snet-goanywhere-gateway-external'
        addressPrefix: '10.129.73.40/29'
      }
      {
        name: 'snet-exchange-westeu-001'
        addressPrefix: '10.129.73.48/29'
      }
    ]
    networkSecurityGroups: [
      {
        Name: 'nsg-vdi-swift-production'
        properties: {
          securityRules: [
            {
              name: 'Allow_office_wifi_rdp'
              properties: {
                access: 'Allow'
                direction: 'Inbound'
                priority: 300
                protocol: 'tcp'
                sourceAddressPrefix: '10.126.40.0/23'
                sourcePortRange: '*'
                destinationAddressPrefix: '10.129.73.8/29'
                destinationPortRange: '3389'
              }
            }
            {
              name: 'Allow_sthlm_office_wired_rdp'
              properties: {
                access: 'Allow'
                direction: 'Inbound'
                priority: 310
                protocol: 'tcp'
                sourceAddressPrefix: '192.168.65.0/24'
                sourcePortRange: '*'
                destinationAddressPrefix: '10.129.73.8/29'
                destinationPortRange: '3389'
              }
            }
            {
              name: 'Allow_vpn_f5_personal_rdp'
              properties: {
                access: 'Allow'
                direction: 'Inbound'
                priority: 320
                protocol: 'tcp'
                sourceAddressPrefix: '10.126.50.0/23'
                sourcePortRange: '*'
                destinationAddressPrefix: '10.129.73.8/29'
                destinationPortRange: '3389'
              }
            }
            {
              name: 'Deny_all_internet'
              properties: {
                access: 'Deny'
                direction: 'Inbound'
                priority: 330
                protocol: 'tcp'
                sourceAddressPrefix: 'Internet'
                sourcePortRange: '*'
                destinationAddressPrefix: '10.129.73.8/29'
                destinationPortRange: '*'
              }
            }
            {
              name: 'Allow_WindowsVirtualDesktop_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3000
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'WindowsVirtualDesktop'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_vpn_swift_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3010
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: '194.209.69.0/24'
                destinationPortRange: '31501'
              }
            }
            {
              name: 'Allow_Azurecloud_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3020
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'AzureCloud'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_storage_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3030
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'Storage'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_AzureVirtualDesktop_http'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3040
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefixes: [
                  '169.254.169.254'
                  '168.63.129.16'
                ]
                destinationPortRange: '80'
              }
            }
            {
              name: 'Allow_AzureInstanceMetaDataServiceEndpoint_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3050
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: '169.254.169.254'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_Internet_1688'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3060
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'Internet'
                destinationPortRange: '1688'
              }
            }
            {
              name: 'Allow_Internet_123'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3070
                protocol: 'udp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'Internet'
                destinationPortRange: '123'
              }
            }
            {
              name: 'Allow_AzureAd_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3080
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'AzureActiveDirectory'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_ADFS_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3090
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: '52.137.57.9'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Allow_Splunk'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3100
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: '10.126.66.12'
                destinationPortRange: '8089'
              }
            }
            {
              name: 'Allow_Internet_https'
              properties: {
                access: 'Allow'
                direction: 'Outbound'
                priority: 3110
                protocol: 'tcp'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'Internet'
                destinationPortRange: '443'
              }
            }
            {
              name: 'Deny_Internet'
              properties: {
                access: 'Deny'
                direction: 'Outbound'
                priority: 3500
                protocol: '*'
                sourceAddressPrefix: '10.129.73.8/29'
                sourcePortRange: '*'
                destinationAddressPrefix: 'Internet'
                destinationPortRange: '*'
              }
            }
          ]
        }
      }
    ]
  }
}

module ITSecurity './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-ITSecurityProd'
  scope: resourceGroup(ITSecuritySubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.96.0/21'
    ]
    subnets: []
  }
}

module Shared './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-SharedProd'
  scope: resourceGroup(SharedSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.128.0.0/18'
    ]
    subnets: [
      {
        name: 'snet-k8s-prod'
        addressPrefix: '10.128.0.0/20'
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
        name: 'snet-k8s-api-prod'
        addressPrefix: '10.128.16.0/20'
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
        name: 'snet-k8s-elastic-prod'
        addressPrefix: '10.128.32.0/24'
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
        name: 'snet-shared-westeu-001'
        addressPrefix: '10.128.35.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
  }
}

module Web './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-WebProd'
  scope: resourceGroup(WebSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
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
              name: 'AllowInternetTrafficHttpsAndHttp'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '*'
                destinationPortRanges: [
                  '80'
                  '443'
                ]
                direction: 'Inbound'
                priority: 120
                protocol: '*'
                sourceAddressPrefix: '*'
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
      {
        name: 'nsg-frontend'
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
              name: 'AllowInternalHttpPorts'
              properties: {
                access: 'Allow'
                destinationAddressPrefix: '10.129.120.4'
                destinationPortRanges: [
                  '80'
                  '443'
                ]
                direction: 'Inbound'
                priority: 120
                protocol: '*'
                sourceAddressPrefix: '10.126.45.0/27'
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
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: []
    addressPrefixes: [
      '10.129.120.0/21'
    ]
    subnets: [
      {
        name: 'frontend'
        addressPrefix: '10.129.120.0/26'
        networkSecurityGroup: 'nsg-frontend'
        privateEndpointNetworkPolicies: 'Disabled'
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
        addressPrefix: '10.129.121.64/26'
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
  name: 'vnetSpokeDeploy-ManagementProd'
  scope: resourceGroup(ManagementSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    peerNetworkId: peerNetworkId
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    rtroutes: routes
    addressPrefixes: [
      '10.129.152.0/21'
    ]
    subnets: []
  }
}
