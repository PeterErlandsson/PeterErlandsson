param resourceGroupNamePrefix string = 'rg-spoke-'
param environment string = 'sandbox'

var BICCSubscription = '0149c4d7-fb82-4de7-9e90-0ccdc1bcd848'
var CoreBankingSubscription = '05f95129-2ad8-4695-b828-30468a3aaf41'
var FinanceSubscription = '1165cc94-4417-4ac0-bd6e-3a163d0b6bc1'
var InfraSubscription = 'd26d75b1-5a52-43ec-ac93-bf944abbe5a7'
var ITSecuritySubscription = '02e20428-86a7-4726-b1f8-4c0ac4cf81b6'
var SharedSubscription = '40ef3b89-6881-410d-882f-cd0c7fb8d205'
var WebSubscription = 'acd59361-7d2f-4939-a846-bb9266a6d622'

module BICCRGLock './modules/resourceLock.bicep' = {
  name: 'BICCResourceGroupLock'
  scope: resourceGroup(BICCSubscription, '${resourceGroupNamePrefix}${environment}')
}

module CoreBankingRGLock './modules/resourceLock.bicep' = {
  name: 'CoreBankingResourceGroupLock'
  scope: resourceGroup(CoreBankingSubscription, '${resourceGroupNamePrefix}${environment}')
}


module FinanceRGLock './modules/resourceLock.bicep' = {
  name: 'FinanceResourceGroupLock'
  scope: resourceGroup(FinanceSubscription,'${resourceGroupNamePrefix}${environment}')
}

module InfraRGLock './modules/resourceLock.bicep' = {
  name: 'InfraResourceGroupLock'
  scope: resourceGroup(InfraSubscription,'${resourceGroupNamePrefix}${environment}')
}

module ITSecurityRGLock './modules/resourceLock.bicep' = {
  name: 'ITSecurityResourceGroupLock'
  scope: resourceGroup(ITSecuritySubscription,'${resourceGroupNamePrefix}${environment}')
}

module SharedRGLock './modules/resourceLock.bicep' = {
  name: 'SharedResourceGroupLock'
  scope: resourceGroup(SharedSubscription,'${resourceGroupNamePrefix}${environment}')
}

module WebRGLock './modules/resourceLock.bicep' = {
  name: 'WebResourceGroupLock'
  scope: resourceGroup(WebSubscription,'${resourceGroupNamePrefix}${environment}')
}

