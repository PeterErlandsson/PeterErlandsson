targetScope = 'managementGroup'

param resourceGroupNamePrefix string = 'rg-spoke-'

param environment string = 'production'

var BICCSubscription = '9c1f72c2-f361-47ef-9e84-385945de7c43'
var CoreBankingSubscription = 'f9eb3a45-65eb-4b77-a97a-3e8d15bb3202'
var FinanceSubscription = 'd903b703-93ed-43c2-ad4c-0c3815e44fba'
var InfraSubscription = '373ea7c9-4c36-440b-a23a-f2ded206dbe4'
var ITSecuritySubscription = '851fe226-3dbe-41b9-9523-1cd7914ba9f0'
var SharedSubscription = '15fd53fd-1f42-46b2-8d17-b4e4177147cb'
var WebSubscription = '1a4b8123-9a77-4b77-9c37-0fe324ee7588'
var ManagementSubscription = 'd903b703-93ed-43c2-ad4c-0c3815e44fba'


module BICCRGLock './modules/resourceLock.bicep' = {
  name: 'BICCResourceGroupLock'
  scope: resourceGroup(BICCSubscription,'${resourceGroupNamePrefix}${environment}')
}

module CoreBankingRGLock './modules/resourceLock.bicep' = {
  name: 'CoreBankingResourceGroupLock'
  scope: resourceGroup(CoreBankingSubscription,'${resourceGroupNamePrefix}${environment}')
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

module ManagementRGLock './modules/resourceLock.bicep' = {
  name: 'ManagementResourceGroupLock'
  scope: resourceGroup(ManagementSubscription,'${resourceGroupNamePrefix}${environment}')
}
