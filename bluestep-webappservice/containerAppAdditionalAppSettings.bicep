// Deploy appsettings to existing App Service 
// Since appsettings can't be added using ARM templates

param existingAppSettings object {
    default: {}
}

param functionAppName string

resource additionalAppSettings 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${functionAppName}/appsettings'
  properties: existingAppSettings
}
