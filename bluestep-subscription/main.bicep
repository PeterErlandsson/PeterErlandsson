targetScope = 'tenant'

param Departments array = [
  'Infrastructure'
  'Web'
  'Data Management'
  'Finance'
]

resource Shared 'Microsoft.Subscription/aliases@2020-09-01' = {
  name: 'Shared Production'
  properties: {
    displayName: 'Shared Production'
    workload:'Production'
  }
}

resource ProdSubscriptions 'Microsoft.Subscription/aliases@2020-09-01' = [for Department in Departments: {
  name: '${Department} Production'
  properties: {
    displayName: '${Department} Production'
    workload:'Production'
  }
}]

resource DevSubscription 'Microsoft.Subscription/aliases@2020-09-01' = [for Department in Departments: {
  name: '${Department} Development'
  properties: {
    displayName: '${Department} Development'
    workload:'DevTest'
  }
}]

resource SandboxSubscription 'Microsoft.Subscription/aliases@2020-09-01' = [for Department in Departments: {
  name: '${Department} Sandbox'
  properties: {
    displayName: '${Department} Sandbox'
    workload:'DevTest'
  }
}]

resource MGBluestepRoot 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'Bluestep'
  properties: {
    displayName: 'Bluestep Bank AB'
    details:{
     parent:{
       id: '/providers/Microsoft.Management/managementGroups/1bab0d88-9e12-4b80-a8e6-5783c09b09fc'
     } 
    }
  }
}

resource MGBluestepProduction 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'BluestepProd'
  properties: {
    displayName: 'Bluestep Production'
    details:{
     parent:{
       id: MGBluestepRoot.id
     } 
    }
  }
}

resource MGBluestepDevelopment 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'BluestepDev'
  properties: {
    displayName: 'Bluestep Development'
    details:{
     parent:{
       id: MGBluestepRoot.id
     } 
    }
  }
}

resource MGBluestepSandbox 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'BluestepSandbox'
  properties: {
    displayName: 'Bluestep Sandbox'
    details:{
     parent:{
       id: MGBluestepRoot.id
     } 
    }
  }
}

output ProdSubscriptions array = [for Department in Departments: {
  id: '${reference(resourceId('Microsoft.Subscription/aliases','${Department} Production'),'2020-09-01','full').subscriptionId}'
}]

output DevSubscriptions array = [for Department in Departments: {
  id: '${reference(resourceId('Microsoft.Subscription/aliases','${Department} Development'),'2020-09-01','full').subscriptionId}'
}]

output SandboxSubscriptions array = [for Department in Departments: {
  id: '${reference(resourceId('Microsoft.Subscription/aliases','${Department} Sandbox'),'2020-09-01','full').subscriptionId}'
}]
// resource ProdSubChildren 'Microsoft.Management/managementGroups/subscriptions@2020-05-01' = [for Department in Departments: {
//   name: '${MGBluestepProduction.name}/${reference(resourceId('Microsoft.Subscription/aliases',Department),'2020-09-01','full').subscriptionId}'
//   // name: '${MGBluestepProduction.name}/${resourceId('Microsoft.Subscription/aliases',Department)}'
//   properties:{
//     displayName: '${Department} Production'
//     parent: {
//       parent: {
//         id: MGBluestepProduction.id
//       }
//     }
//   }
// }]