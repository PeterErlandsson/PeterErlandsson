param Environment string = 'dev'
param servicename string = 'modeloservices'
param location string = resourceGroup().location
param skufamily string = 'basic'
param skutier string = 'B1'

var hostplanname = 'plan-${servicename}-${Environment}-001'
var webappname = 'app-${servicename}-${Environment}-001'

resource hostplan 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: hostplanname
  location: location
  sku: {
    tier: skufamily
    name: skutier
  }
}

resource webapp 'Microsoft.Web/sites@2021-01-01' = {
  name: webappname
  location: location
  properties: {
    serverFarmId: hostplan.id
  }
}
