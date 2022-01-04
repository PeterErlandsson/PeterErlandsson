param resourceGroupNamePrefix string = 'rg-spoke-'
param environment string = 'test'

var BICCSubscription = 'cd477377-d2d8-4b06-bea0-0e8c0c88ace3'
var CoreBankingSubscription = '4baeebd9-1115-4ab0-9989-a2bc0e9182ce'
var FinanceSubscription = 'c71088dc-0794-4389-866e-45d2a5f50632'
var InfraSubscription = '86d71566-8cbd-4e51-a115-fd7e0df0c3a0'
var ITSecuritySubscription = '8e943c51-c120-4a91-954e-a2039f3df53e'
var SharedSubscription = 'e151adf0-bce6-4aad-ab51-8accf2021f77'
var WebSubscription = 'ad9a9cc4-f2cc-42a9-9941-49acae2ffb87'
var ManagementSubscription = '37aa9fba-943a-47bb-89f1-6be68d729ec3'

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
