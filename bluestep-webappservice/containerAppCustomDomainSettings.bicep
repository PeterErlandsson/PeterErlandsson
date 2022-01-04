param functionAppName string
param customHostname string
param serverFarmId string
param enableSSL bool
param keyvaultId string
param keyvaultCertificateName string
param location string {
  default: resourceGroup().location
  metadata: {
      description: 'Location for all resources created'
  }
}

resource sslCertificate 'Microsoft.Web/certificates@2020-09-01' = if (enableSSL) {
  // condition: enableSSL == true
  name: '${functionAppName}-${customHostname}-cert'
  location: location
  properties: {
    keyVaultId: keyvaultId
    keyVaultSecretName: keyvaultCertificateName
    serverFarmId: serverFarmId
  }
}

resource CustomDomain 'Microsoft.Web/sites/hostnameBindings@2020-09-01' = {
  name: '${functionAppName}/${customHostname}'
  location: location
  properties: {
    siteName: functionAppName
    azureResourceName: functionAppName
    azureResourceType: 'Website'
    customHostNameDnsRecordType: 'CName'
    hostNameType: 'Managed'
    sslState: enableSSL ? 'SniEnabled' : json('null')
    thumbprint: enableSSL ? sslCertificate.properties.Thumbprint : json('null')
  }
}