param hostingPlanName string

param operatingSystem string {
    default: 'windows'
    allowed:[
        'windows'
        'linux'
    ]
}

param appServiceSku string {
    allowed: [
        'F1'   // Free                   Windows | Linux
        'D1'   // Shared                 Windows
        'B1'   // Basic                  Windows | Linux
        'B2'   // Basic                  Windows | Linux
        'B3'   // Basic                  Windows | Linux
        'S1'   // Standard               Windows | Linux
        'S2'   // Standard               Windows | Linux
        'S3'   // Standard               Windows | Linux
        'P1V3' // PremiumV3              Windows | Linux
        'P2V3' // PremiumV3              Windows | Linux
        'P3V3' // PremiumV3              Windows | Linux
        'I1'   // Isolated               Windows | Linux
        'I2'   // Isolated               Windows | Linux
        'I3'   // Isolated               Windows | Linux
        'Y1'   // Dynamic                Windows | Linux Functions
        'EP1'  // Premium Dynamic        Windows | Linux Functions
        'EP2'  // Premium Dynamic        Windows | Linux Functions
        'EP3'  // Premium Dynamic        Windows | Linux Functions
    ]
}

param capacity int {
  default: 1
}

param location string {
    default: resourceGroup().location
    metadata: {
        description: 'Location for all resources created'
    }
}

var dynamicSkuList = [
    'Y1'
    'EP1'
    'EP2'
    'EP3'
]

resource hostingPlan 'Microsoft.Web/serverfarms@2020-06-01' = {
    name: hostingPlanName
    location: location
    kind: contains(dynamicSkuList,appServiceSku) ? 'elastic' : operatingSystem
    sku: {
        name: appServiceSku
        capacity: appServiceSku == 'Y1' ? 0 : capacity
    }
    properties: {
        reserved: operatingSystem == 'linux'
    }
}

output hostingId string = hostingPlan.id