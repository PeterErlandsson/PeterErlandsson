param resourceGroupNamePrefix string = 'rg-spoke-'

param location string = 'West Europe'

param dnsServer array = [
  '10.129.144.4'
]

param firewallIp string = '10.129.144.4'

param environment string = 'sandbox'

var BICCSubscription = '0149c4d7-fb82-4de7-9e90-0ccdc1bcd848'
var CoreBankingSubscription = '05f95129-2ad8-4695-b828-30468a3aaf41'
var FinanceSubscription = '1165cc94-4417-4ac0-bd6e-3a163d0b6bc1'
var InfraSubscription = 'd26d75b1-5a52-43ec-ac93-bf944abbe5a7'
var ITSecuritySubscription = '02e20428-86a7-4726-b1f8-4c0ac4cf81b6'
var SharedSubscription = '40ef3b89-6881-410d-882f-cd0c7fb8d205'
var WebSubscription = 'acd59361-7d2f-4939-a846-bb9266a6d622'

module BICC './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-BICCSandbox'
  scope: resourceGroup(BICCSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.8.0/21'
    ]
    subnets: []
  }
}

module CoreBanking './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-CoreBankingSandbox'
  scope: resourceGroup(CoreBankingSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.32.0/21'
    ]
    subnets: []
  }
}

module Finance './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-FinanceSandbox'
  scope: resourceGroup(FinanceSubscription, '${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.56.0/21'
    ]
    subnets: []
  }
}

module Infra './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-InfraSandbox'
  scope: resourceGroup(InfraSubscription,'${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.80.0/21'
    ]
    subnets: [
      {
        name: 'internal'
        addressPrefix: '10.129.80.0/24'
      }
    ]
  }
}

module ITSecurity './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-ITSecuritySandbox'
  scope: resourceGroup(ITSecuritySubscription,'${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.104.0/21'
    ]
    subnets: []
  }
}

module Shared './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-SharedSandbox'
  scope: resourceGroup(SharedSubscription,'${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.128.64.0/18'
    ]
    subnets: []
  }
}

module Web './modules/vnet.bicep' = {
  name: 'vnetSpokeDeploy-WebSandbox'
  scope: resourceGroup(WebSubscription,'${resourceGroupNamePrefix}${environment}')
  params: {
    location: location
    DnsServer: dnsServer
    firewallIp: firewallIp
    addressPrefixes: [
      '10.129.128.0/21'
    ]
    subnets: []
  }
}
